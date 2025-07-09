#!/usr/bin/env python3
"""
Enhanced Driver Behavior Analysis System (DBAS) API Server - Corrected Version
This server connects to Raspberry Pi API endpoints and analyzes driving behavior
including speed limit compliance and traffic light violations
"""

from flask import Flask, request, jsonify
import json
import requests
import os
import pandas as pd
import numpy as np
import psycopg2
from psycopg2.extras import RealDictCursor
from datetime import datetime, timedelta
import traceback
import time
import re
from geopy.distance import geodesic
import yaml
from io import StringIO
from urllib.parse import quote
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL_NAME = "llama3.2:1b"
OVERPASS_API_URL = "https://overpass-api.de/api/interpreter"

# Raspberry Pi API Configuration
RASPBERRY_PI_CONFIG = {
    'host': 'dbaspi.local',
    'port': 5000,
    'base_url': 'http://dbaspi.local:5000',
    'timeout': 30
}

DB_CONFIG = {
    "dbname": "dbas_clients",
    "user": "postgres",
    "password": "ziadkhalifaziad",
    "host": "localhost",
    "port": 5432
}

def get_db_connection():
    """Get a new PostgreSQL database connection"""
    return psycopg2.connect(**DB_CONFIG)

class RaspberryPiApiClient:
    """Handles API communication with Raspberry Pi"""
    
    def __init__(self, pi_config):
        self.pi_config = pi_config
        self.base_url = pi_config['base_url']
        self.session = requests.Session()
        self.session.timeout = pi_config['timeout']
    
    def test_connection(self):
        """Test connection to Raspberry Pi"""
        try:
            url = f"{self.base_url}/health"
            response = self.session.get(url, timeout=5)
            return response.status_code == 200
        except Exception as e:
            logger.error(f"Connection test failed: {e}")
            return False
    
    def get_latest_trip(self, vin):
    	"""Get the latest trip/session ID for a given VIN"""
    	try:
            url = f"{self.base_url}/latesttrip"
            params = {'vin': vin} if vin else {}
        
            logger.info(f"Fetching latest trip from: {url} with params: {params}")
        
            response = self.session.get(url, params=params)
            response.raise_for_status()
        
            data = response.json()
            logger.info(f"Successfully fetched latest trip data: {data}")
        
            session_id = data.get('starttime')

            if session_id:
                return {
                    'vin': vin,
                    'session_id': session_id,
                    'timestamp': data.get('timestamp'),
                    'full_response': data
                }
        
            logger.error(f"Could not extract session ID from response: {data}")
            return None
            
    	except requests.exceptions.RequestException as e:
            logger.error(f"Request error fetching latest trip for VIN {vin}: {e}")
            return None
    	except Exception as e:
            logger.error(f"Unexpected error fetching latest trip for VIN {vin}: {e}")
            return None
    
    def get_trip_file(self, vin, session_id):
        """Get OBD trip file data for specific VIN and session"""
        try:
            url = f"{self.base_url}/tripfile"
            params = {
                'vin': vin,
                'startTime': session_id
            }
            
            logger.info(f"Fetching trip file from: {url} with params: {params}")
            
            response = self.session.get(url, params=params)
            response.raise_for_status()
            
            content_type = response.headers.get('content-type', '').lower()
            
            if 'application/json' in content_type:
                data = response.json()
                logger.info(f"Successfully fetched trip file JSON data for VIN: {data}")
                return data
            elif 'text/csv' in content_type or 'application/csv' in content_type:
                logger.info(f"Successfully fetched trip file CSV data for VIN: {vin}")
                return response.content
            else:
                try:
                    data = response.json()
                    logger.info(f"Successfully fetched trip file JSON data for VIN: {vin}")
                    return data
                except:
                    logger.info(f"Successfully fetched trip file raw data for VIN: {vin}")
                    return response.content
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Request error fetching trip file for VIN {vin}, session {session_id}: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error fetching trip file for VIN {vin}, session {session_id}: {e}")
            return None
    
    def get_trip_meta_details(self, vin, session_id):
        """Get camera metadata for specific VIN and session"""
        try:
            url = f"{self.base_url}/tripmetadetails"
            params = {
                'vin': vin,
                'startTime': session_id
            }
            
            logger.info(f"Fetching trip meta details from: {url} with params: {params}")
            
            response = self.session.get(url, params=params)
            response.raise_for_status()
            
            content_type = response.headers.get('content-type', '').lower()
            
            if 'application/json' in content_type:
                data = response.json()
                logger.info(f"Successfully fetched trip meta details JSON for VIN: {vin}")
                return data
            else:
                try:
                    data = response.json()
                    logger.info(f"Successfully fetched trip meta details JSON for VIN: {vin}")
                    return data
                except:
                    text_data = response.text
                    logger.info(f"Successfully fetched trip meta details text for VIN: {vin}")
                    return text_data
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Request error fetching trip meta details for VIN {vin}, session {session_id}: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error fetching trip meta details for VIN {vin}, session {session_id}: {e}")
            return None

class SpeedLimitAnalyzer:
    """Handles speed limit queries and analysis"""
    
    def __init__(self):
        self.cache = {}
        self.session = requests.Session()
    
    def get_speed_limit(self, lat, lon, radius=50):
        """Query OpenStreetMap for speed limit at given coordinates"""
        cache_key = f"{lat:.4f},{lon:.4f}"
        
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        try:
            overpass_query = f"""
            [out:json][timeout:10];
            (
              way(around:{radius},{lat},{lon})["highway"]["maxspeed"];
            );
            out geom;
            """
            
            response = self.session.post(
                OVERPASS_API_URL,
                data=overpass_query,
                headers={'Content-Type': 'text/plain'},
                timeout=10
            )
            
            if response.status_code == 200:
                data = response.json()
                
                closest_speed_limit = None
                min_distance = float('inf')
                road_class = "unknown"
                
                for element in data.get('elements', []):
                    if 'tags' in element and 'maxspeed' in element['tags']:
                        if 'geometry' in element:
                            for point in element['geometry']:
                                distance = geodesic((lat, lon), (point['lat'], point['lon'])).meters
                                if distance < min_distance:
                                    min_distance = distance
                                    speed_limit_str = element['tags']['maxspeed']
                                    
                                    speed_match = re.search(r'\d+', speed_limit_str)
                                    if speed_match:
                                        closest_speed_limit = int(speed_match.group())

                                    highway_type = element['tags'].get('highway', '')
                                    if highway_type in ['motorway', 'trunk']:
                                        road_class = 'highway'
                                    elif highway_type in ['residential', 'tertiary', 'secondary', 'primary']:
                                        road_class = 'urban'
                                    else:
                                        road_class = 'other'
                
                result = {
                    'speed_limit': closest_speed_limit or 50,
                    'road_class': road_class
                }
                self.cache[cache_key] = result
                return self.cache[cache_key]
                
        except Exception as e:
            logger.error(f"Error querying speed limit for {lat}, {lon}: {e}")
        
        default_result = {
            'speed_limit': 50,
            'road_class': 'urban'
        }
        self.cache[cache_key] = default_result
        return self.cache[cache_key]

class DataAnalyzer:
    """Handles analysis of different data types"""

    @staticmethod
    def get_road_type_for_event(event, speed_analyzer, radius=50):
        """Get road type (urban/highway) for a harsh event using GPS"""
        if not event['location_known']:
            return 'unknown'
    
        result = speed_analyzer.get_speed_limit(event['latitude'], event['longitude'], radius=radius)
        return result.get('road_class', 'unknown')


    @staticmethod
    def analyze_obd_data(obd_data, speed_analyzer):
        """Analyze OBD data with speed limit compliance"""
        try:
            logger.info(f"Analyzing OBD data of type: {type(obd_data)}")
        
            if obd_data is None:
                logger.error("Received empty (None) OBD data")
                return {"error": "Empty OBD data received"}, None
                
            elif isinstance(obd_data, list):
                try:
                    df = pd.DataFrame(obd_data)
                    logger.info("Successfully parsed OBD data from list of records")
                except Exception as e:
                    logger.error(f"Failed to parse list OBD data: {e}")
                    return {"error": "Invalid list data structure"}, None         
                            
            else:
                logger.error(f"Unsupported OBD data type: {type(obd_data)}")
                return {"error": "Unsupported data format"}, None
                          

            df['vehicle_speed'] = pd.to_numeric(df['vehicle_speed'], errors='coerce')
            df['throttle_pos'] = pd.to_numeric(df['throttle_pos'], errors='coerce')
            df['longitude'] = pd.to_numeric(df['longitude'], errors='coerce')
            df['latitude'] = pd.to_numeric(df['latitude'], errors='coerce')
                    
            # Basic metrics
            metrics = {
                "avg_speed": df['vehicle_speed'].mean() if 'vehicle_speed' in df.columns else 0,
                "max_speed": df['vehicle_speed'].max() if 'vehicle_speed' in df.columns else 0,
                "avg_throttle": df['throttle_pos'].mean() if 'throttle_pos' in df.columns else 0,
                "distance_traveled": DataAnalyzer.calculate_distance(df),
                "total_records": len(df)
            }

            if 'time' in df.columns:
                df['time'] = pd.to_datetime(df['time'], errors='coerce')
                df['hour'] = df['time'].dt.hour
                night_hours = [21, 22, 23, 0, 1, 2, 3, 4, 5]  # 9 PM to 5 AM
                df['is_night'] = df['hour'].isin(night_hours)
                
                night_rows = df[df['is_night']].shape[0]
                total_rows = len(df)
                
                night_percentage = (night_rows / total_rows) * 100 if total_rows > 0 else 0
                
                metrics["trip_daytime"] = "night" if night_percentage > 50 else "day"
            else:
                metrics["trip_daytime"] = "unknown"

            df['time_diff_sec'] = df['time'].diff().dt.total_seconds()
            df['speed_diff_kph'] = df['vehicle_speed'].diff()
            df['acceleration_mps2'] = (df['speed_diff_kph'] / 3.6) / df['time_diff_sec']

            harsh_acceleration_threshold = 2.5  # m/s²
            harsh_braking_threshold = -2.5      # m/s²

            harsh_events = []
            
            for idx, row in df.iterrows():
                acc = row['acceleration_mps2']
                if pd.isna(acc):
                    continue
            
                if acc > harsh_acceleration_threshold:
                    event_type = 'harsh_acceleration'
                elif acc < harsh_braking_threshold:
                    event_type = 'harsh_braking'
                else:
                    continue
            
                lat = row.get('latitude', np.nan)
                lon = row.get('longitude', np.nan)
            
                harsh_events.append({
                    'timestamp': row.get('time'),
                    'type': event_type,
                    'acceleration': acc,
                    'latitude': lat if pd.notna(lat) else None,
                    'longitude': lon if pd.notna(lon) else None,
                    'location_known': pd.notna(lat) and pd.notna(lon)
                })
            
            # Count total events
            metrics["harsh_acceleration_count"] = sum(1 for e in harsh_events if e['type'] == 'harsh_acceleration')
            metrics["harsh_braking_count"] = sum(1 for e in harsh_events if e['type'] == 'harsh_braking')
            
            # Store full list for further analysis
            metrics["harsh_events"] = harsh_events

            # Enrich harsh events with road type info
            for event in metrics["harsh_events"]:
                road_info = DataAnalyzer.get_road_type_for_event(event, speed_analyzer)
                event['road_class'] = road_info
            
            # Count urban vs highway harsh events
            urban_harsh_acc = sum(1 for e in metrics["harsh_events"] if e.get('type') == 'harsh_acceleration' and e.get('road_class') == 'urban')
            highway_harsh_acc = sum(1 for e in metrics["harsh_events"] if e.get('type') == 'harsh_acceleration' and e.get('road_class') == 'highway')
            
            urban_harsh_brake = sum(1 for e in metrics["harsh_events"] if e.get('type') == 'harsh_braking' and e.get('road_class') == 'urban')
            highway_harsh_brake = sum(1 for e in metrics["harsh_events"] if e.get('type') == 'harsh_braking' and e.get('road_class') == 'highway')
            
            metrics.update({
                "urban_harsh_accelerations": urban_harsh_acc,
                "highway_harsh_accelerations": highway_harsh_acc,
                "urban_harsh_brakes": urban_harsh_brake,
                "highway_harsh_brakes": highway_harsh_brake
            })


            # Speed limit analysis
            speed_violations = []
            if 'latitude' in df.columns and 'longitude' in df.columns and 'vehicle_speed' in df.columns:
                logger.info("Analyzing speed limit compliance...")
                
                # Sample data to reduce API calls
                sample_df = df.iloc[::10].copy() if len(df) > 50 else df.copy()
                
                for idx, row in sample_df.iterrows():
                    if pd.notna(row['latitude']) and pd.notna(row['longitude']) and pd.notna(row['vehicle_speed']):
                        # Call get_speed_limit and store the result
                        result = speed_analyzer.get_speed_limit(row['latitude'], row['longitude'])

                        speed_limit = result['speed_limit']
                        road_class = result['road_class']
                        actual_speed = row['vehicle_speed']

                        if actual_speed > speed_limit + 5:  # 5 km/h tolerance
                            violation_severity = min(100, ((actual_speed - speed_limit) / speed_limit) * 100)
                            speed_violations.append({
                                'timestamp': row.get('timestamp', ''),
                                'location': f"{row['latitude']:.4f},{row['longitude']:.4f}",
                                'speed_limit': speed_limit,
                                'actual_speed': actual_speed,
                                'excess_speed': actual_speed - speed_limit,
                                'severity': violation_severity,
                                'road_class': road_class
                            })
            
            metrics['speed_violations'] = speed_violations
            metrics['speed_violation_count'] = len(speed_violations)
            metrics.update({
                "urban_speed_violation_count": sum(1 for v in speed_violations if v.get('road_class') == 'urban'),
                "highway_speed_violation_count": sum(1 for v in speed_violations if v.get('road_class') == 'highway'),
                "other_road_violation_count": sum(1 for v in speed_violations if v.get('road_class') not in ['urban', 'highway']),
            })

            print("metrics", metrics)
            
            return metrics, df
            
        except Exception as e:
            logger.error(f"Error analyzing OBD data: {e}")
            return {"error": str(e)}, None
    
    @staticmethod
    def analyze_camera_metadata(meta_data):
        """Analyze camera metadata for distractions and other behaviors"""
        try:
            if not meta_data:
                return {
                    "safe_distractions": 0,
                    "critical_distractions": 0,
                    "total_distraction_score": 0,
                    "lane_violations": 0,
                    "lane_discipline_score": 0,
                    "traffic_light_events": [],
                    "traffic_violations": 0
                }

            analysis_result = {
                "safe_distractions": 0,
                "critical_distractions": 0,
                "lane_violations": 0,
                "lane_discipline_score": 0,
                "traffic_light_events": [],
                "traffic_violations": 0,
                "total_distraction_score": 0
            }

            # Handle structured input (dict)
            if isinstance(meta_data, dict):
                analysis_result.update({
                    "safe_distractions": meta_data.get('safe_distractions', 0),
                    "critical_distractions": meta_data.get('critical_distractions', 0),
                    "lane_violations": meta_data.get('lane_violations', 0),
                    "traffic_light_events": meta_data.get('traffic_light_events', [])
                })

            # Handle unstructured input (raw text)
            elif isinstance(meta_data, str):
                # Improved regex to capture face distraction counts
                safe_match = re.search(r'Safe Distraction times $2-5 seconds$ : (\d+)', meta_data)
                critical_match = re.search(r'Critical Distraction times $>5 seconds$ : (\d+)', meta_data)

                analysis_result["safe_distractions"] = int(safe_match.group(1)) if safe_match else 0
                analysis_result["critical_distractions"] = int(critical_match.group(1)) if critical_match else 0

                # Lane Violation Parsing (with duration breakdown)
                def extract_lane_count(pattern):
                    match = re.search(pattern, meta_data, re.IGNORECASE)
                    return int(match.group(1)) if match else 0

                less_than_2 = extract_lane_count(r'Less than 2 Seconds: (\d+)')
                between_2_5 = extract_lane_count(r'2 - 5 Seconds: (\d+)')
                between_6_10 = extract_lane_count(r'6 - 10 Seconds: (\d+)')
                more_than_10 = extract_lane_count(r'More than 10 Seconds: (\d+)')

                total_lane_violations = less_than_2 + between_2_5 + between_6_10 + more_than_10

                analysis_result.update({
                    "less_than_2_seconds": less_than_2,
                    "between_2_5_seconds": between_2_5,
                    "between_6_10_seconds": between_6_10,
                    "more_than_10_seconds": more_than_10,
                    "lane_violations": total_lane_violations,
                    "lane_discipline_score": (
                        less_than_2 * 1 +
                        between_2_5 * 2 +
                        between_6_10 * 4 +
                        more_than_10 * 8
                    )
                })

                # Traffic Light Event Detection
                date_format = r"(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})"
                dates_encountered = re.findall(date_format, meta_data)

                # Convert strings to datetime objects
                traffic_light_events = []
                for ts in dates_encountered:
                    try:
                        dt = datetime.strptime(ts, "%Y-%m-%d %H:%M:%S")
                        traffic_light_events.append(dt)
                    except ValueError as ve:
                        logger.warning(f"Invalid traffic light timestamp: {ts} – {ve}")
                        continue

                analysis_result["traffic_light_events"] = traffic_light_events

            # Calculate final scores
            distraction_score = (analysis_result['safe_distractions'] * 2) + (analysis_result['critical_distractions'] * 10)
            analysis_result['total_distraction_score'] = distraction_score

            return analysis_result

        except Exception as e:
            logger.error(f"Error analyzing camera metadata: {e}")
            return {"error": str(e)}


    @staticmethod
    def detect_red_light_violations(camera_metrics, obd_df):
        """
        Detect how many times the driver failed to stop safely at red lights.
        A violation occurs if vehicle speed > 5 km/h within ±3 seconds of a red light encounter.
        """
        traffic_light_events = camera_metrics.get("traffic_light_events", [])
        violations = 0

        if obd_df is None or obd_df.empty:
            logger.warning("No OBD data available; skipping red light violation detection")
            camera_metrics["traffic_violations"] = 0
            return camera_metrics

        # Ensure timestamp is datetime type
        if 'timestamp' in obd_df.columns:
            obd_df['timestamp'] = pd.to_datetime(obd_df['timestamp'], errors='coerce')
        else:
            logger.warning("No 'timestamp' column found in OBD data; cannot check red light compliance")
            camera_metrics["traffic_violations"] = 0
            return camera_metrics

        for light_time in traffic_light_events:
            # Find closest OBD record within ±3 seconds
            obd_df['time_diff_sec'] = abs((obd_df['timestamp'] - light_time).dt.total_seconds())
            closest_row = obd_df[obd_df['time_diff_sec'] <= 3].nsmallest(1, 'time_diff_sec')

            if not closest_row.empty:
                speed_at_light = closest_row.iloc[0]['vehicle_speed']
                if speed_at_light > 5:
                    violations += 1
                    logger.info(f"Violation detected at red light: Speed={speed_at_light:.1f} km/h at {light_time}")

        # Update metrics with final count
        camera_metrics["traffic_violations"] = violations
        return camera_metrics
    
    @staticmethod
    def calculate_distance(df):
        """Calculate total distance using GPS coordinates"""
        if len(df) < 2 or 'latitude' not in df.columns or 'longitude' not in df.columns:
            return 0
        
        total_distance = 0
        for i in range(1, len(df)):
            try:
                if (pd.notna(df.iloc[i]['latitude']) and pd.notna(df.iloc[i]['longitude']) and
                    pd.notna(df.iloc[i-1]['latitude']) and pd.notna(df.iloc[i-1]['longitude'])):
                    
                    point1 = (df.iloc[i-1]['latitude'], df.iloc[i-1]['longitude'])
                    point2 = (df.iloc[i]['latitude'], df.iloc[i]['longitude'])
                    distance = geodesic(point1, point2).kilometers
                    total_distance += distance
            except Exception as e:
                logger.warning(f"Error calculating distance at index {i}: {e}")
                continue
        
        return total_distance

def create_analysis_prompt(obd_metrics, camera_metrics):
    """Create comprehensive analysis prompt for LLM"""
    
    speed_violations_summary = ""
    if obd_metrics.get('speed_violations'):
        violations = obd_metrics['speed_violations']
        avg_excess = sum(v['excess_speed'] for v in violations) / len(violations)
        max_excess = max(v['excess_speed'] for v in violations)
        speed_violations_summary = f"""
- Speed Limit Violations: {len(violations)}
- Average Excess Speed: {avg_excess:.1f} km/h
- Maximum Excess Speed: {max_excess:.1f} km/h"""

    prompt = f"""
You are an expert driving behavior analyst. Analyze the comprehensive driving data and provide:
1. A driving score out of 100 (where 100 is perfect driving)
2. A list of specific improvement suggestions prioritized by safety impact

COMPREHENSIVE DRIVING DATA:
===========================

Vehicle Performance:
- Average Speed: {obd_metrics.get('avg_speed', 0):.1f} km/h
- Maximum Speed: {obd_metrics.get('max_speed', 0):.1f} km/h
- Harsh Acceleration Events: {obd_metrics.get('harsh_acceleration_count', 0)}
- Harsh Braking Events: {obd_metrics.get('harsh_braking_count', 0)}
- Distance Traveled: {obd_metrics.get('distance_traveled', 0):.2f} km

Speed Obey Compliance:{speed_violations_summary}

Driver Attention & Behavior:
- Safe Distractions (2-5s): {camera_metrics.get('safe_distractions', 0)}
- Critical Distractions (>5s): {camera_metrics.get('critical_distractions', 0)}
- Total Distraction Score: {camera_metrics.get('total_distraction_score', 0)}

Lane Discipline:
- Short Drifts (<2s): {camera_metrics.get('less_than_2_seconds', 0)}
- Medium Drifts (2-5s): {camera_metrics.get('between_2_5_seconds', 0)}
- Long Drifts (6-10s): {camera_metrics.get('between_6_10_seconds', 0)}
- Extended Drifts (>10s): {camera_metrics.get('more_than_10_seconds', 0)}
- Lane Discipline Score (weighted): {camera_metrics.get('lane_discipline_score', 0)}

Traffic Signal Compliance:
- Traffic Signal Violations: {camera_metrics.get('traffic_violations', 0)}

TRIP TIME CONTEXT:
==================
- Driving occurred during: {obd_metrics.get('trip_daytime', 'unknown')}

TRIP CONTEXT:
=============
Driving Environment:
- Urban Speed Violations: {obd_metrics.get('urban_speed_violation_count', 0)}
- Highway Speed Violations: {obd_metrics.get('highway_speed_violation_count', 0)}
- Other Road Type Violations: {obd_metrics.get('other_road_violation_count', 0)}

Harsh Driving by Road Type:
- Urban Harsh Accelerations: {obd_metrics.get('urban_harsh_accelerations', 0)}
- Highway Harsh Accelerations: {obd_metrics.get('highway_harsh_accelerations', 0)}
- Urban Harsh Braking Events: {obd_metrics.get('urban_harsh_brakes', 0)}
- Highway Harsh Braking Events: {obd_metrics.get('highway_harsh_brakes', 0)}

SCORING CRITERIA:
=================
- Speed limit compliance (25 points max)
- Traffic signal compliance (20 points max)  
- Smooth driving behavior (20 points max)
- Attention management (20 points max)
- Lane discipline (15 points max)

Deduct points severely for:
- Speeding >10 km/h over limit (especially in urban areas)
  - Urban speeding: Hardest penalty due to high pedestrian risk
  - Highway speeding: Moderate penalty unless repeated
- Critical distractions (>5 seconds eyes off road)
  - Includes phone use, eating, adjusting settings while moving
  - Deduct extra if these occur at night when visibility is low or during rush hour
- Traffic signal violations (red light/run-stop sign)
  - Zero tolerance policy; highest severity category
  - Deduct more if occurred at night when visibility is low
- Harsh acceleration/braking:
  - At night: Deduct more heavily due to reduced visibility
  - In urban zones: Deduct heavily (sudden changes increase crash risk)
  - On highways: Deduct moderately for frequent or extreme events
- Lane discipline issues:
  - Unsignaled lane changes
  - Drifting across lane lines
  - Repeated lane violations
  - Especially risky at night - deduct more heavily

Please provide your response in this EXACT format:

SCORE: [number between 0-100]

PRIORITY IMPROVEMENTS:
1. [Highest priority safety issue]

2. [Second priority issue]  

3. [Third priority issue]

4. [Fourth priority issue]

5. [Fifth priority issue]

Focus on the most dangerous behaviors first, then address efficiency and comfort issues.
"""
    return prompt

def query_ollama(prompt):
    """Send prompt to Ollama and get response"""
    try:
        payload = {
            "model": MODEL_NAME,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.2,
                "top_p": 0.9,
                "num_predict": 600
            }
        }
        
        response = requests.post(OLLAMA_URL, json=payload, timeout=60)
        response.raise_for_status()
        
        result = response.json()
        return result.get('response', 'No response received')
            
    except Exception as e:
        logger.error(f"Error communicating with Ollama: {e}")
        return f"Error communicating with Ollama: {str(e)}"

def parse_llm_response(response):
    """Parse the LLM response to extract score and suggestions"""
    try:
        lines = response.strip().split('\n')
        score = 75  # Default score
        suggestions = []
        
        # Look for score
        for line in lines:
            if line.strip().upper().startswith('SCORE:'):
                score_text = line.replace('SCORE:', '').replace('score:', '').strip()
                numbers = re.findall(r'\d+', score_text)
                if numbers:
                    score = min(100, max(0, int(numbers[0])))
                break
        
        # Look for priority improvements
        in_improvements = False
        for line in lines:
            line = line.strip()
            if 'PRIORITY IMPROVEMENTS:' in line.upper() or 'SUGGESTIONS:' in line.upper():
                in_improvements = True
                continue
            
            if in_improvements and line:
                if line.startswith(('1.', '2.', '3.', '4.', '5.')):
                    suggestion = re.sub(r'^\d+\.\s*', '', line).strip()
                    if suggestion and len(suggestion) > 10:
                        suggestions.append(suggestion)
                elif line and not line.startswith('Focus on'):
                    if len(suggestions) < 5:
                        suggestions.append(line)
        
        # Fallback suggestions if parsing fails
        if not suggestions:
            suggestions = [
                "Maintain speed within posted limits at all times",
                "Come to complete stops at red lights and stop signs", 
                "Keep your attention focused on driving - avoid distractions",
                "Stay within lane boundaries and signal lane changes",
                "Practice smooth acceleration and braking techniques"
            ]
        
        return score, suggestions[:5]
        
    except Exception as e:
        logger.error(f"Error parsing LLM response: {e}")
        return 70, ["Focus on safe driving practices", "Follow all traffic laws"]


def insert_user_if_not_exists(vin):
    """Insert user (VIN) if not already in the users table"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("INSERT INTO users (vin) SELECT %s WHERE NOT EXISTS (SELECT 1 FROM users WHERE vin = %s)", (vin, vin))
        conn.commit()
        cur.close()
    except Exception as e:
        logger.error(f"Error inserting user (VIN): {e}")
        conn.rollback()
        raise

def save_trip_data(vin, session_id, score, improvements, detailed_analysis):
    """Save LLM response and metrics to the trips table"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO trips (vin, session_id, driving_score, priority_improvements, detailed_analysis)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (vin, session_id) DO NOTHING
        """, (
            vin,
            session_id,
            score,
            improvements,
            json.dumps(detailed_analysis)
        ))

        conn.commit()
        cur.close()
    except Exception as e:
        logger.error(f"Error saving trip data: {e}")
        conn.rollback()
        raise        

# Initialize components
api_client = RaspberryPiApiClient(RASPBERRY_PI_CONFIG)
speed_analyzer = SpeedLimitAnalyzer()
data_analyzer = DataAnalyzer()

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    try:
        pi_connected = api_client.test_connection()
        
        # Test Ollama connection
        ollama_connected = False
        try:
            test_response = requests.get("http://localhost:11434/api/tags", timeout=5)
            ollama_connected = test_response.status_code == 200
        except:
            pass
        
        return jsonify({
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
            "raspberry_pi_connected": pi_connected,
            "ollama_connected": ollama_connected,
            "raspberry_pi_url": api_client.base_url
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 500

@app.route('/insights', methods=['POST'])
def get_trip_insights():
    """Endpoint to retrieve full trip insights including raw metrics and analysis"""
    try:
        # 1. Validate input
        if not request.is_json:
            return jsonify({"error": "Request must be JSON"}), 400

        vin = request.json.get('vin')
        if not vin:
            return jsonify({"error": "VIN is required"}), 400

        logger.info(f"Fetching full trip insights for VIN: {vin}")

        # 2. Get latest trip info
        latest_trip = api_client.get_latest_trip(vin)
        if not latest_trip:
            return jsonify({"error": "Could not fetch latest trip information"}), 404

        session_id = latest_trip['session_id']

        # 3. Fetch OBD data
        obd_data = api_client.get_trip_file(vin, session_id)
        if not obd_data:
            return jsonify({"error": "Could not fetch OBD trip data"}), 500

        # 4. Fetch camera metadata
        camera_data = api_client.get_trip_meta_details(vin, session_id)
        if not camera_data:
            return jsonify({"error": "Could not fetch camera metadata"}), 500

        # 5. Analyze data
        obd_metrics, obd_df = data_analyzer.analyze_obd_data(obd_data, speed_analyzer)
        if isinstance(obd_metrics.get("error"), str):
            logger.error(f"Error in OBD data analysis: {obd_metrics['error']}")
            return jsonify({"error": obd_metrics["error"]}), 500

        camera_metrics = data_analyzer.analyze_camera_metadata(camera_data)

        # 6. Build comprehensive insights response
        insights_response = {
            "vin": vin,
            "session_id": session_id,
            "obd_data_summary": {
                "avg_speed_kmh": round(obd_metrics.get("avg_speed", 0), 2),
                "max_speed_kmh": round(obd_metrics.get("max_speed", 0), 2),
                "distance_km": round(obd_metrics.get("distance_traveled", 0), 2),
                "harsh_acceleration_count": obd_metrics.get("harsh_acceleration_count", 0),
                "harsh_braking_count": obd_metrics.get("harsh_braking_count", 0),
                "speed_violation_count": obd_metrics.get("speed_violation_count", 0),
                "trip_daytime": obd_metrics.get("trip_daytime", "unknown"),
            },
            "camera_data_summary": {
                "safe_distractions": camera_metrics.get("safe_distractions", 0),
                "critical_distractions": camera_metrics.get("critical_distractions", 0),
                "lane_violations": camera_metrics.get("lane_violations", 0),
                "traffic_violations": camera_metrics.get("traffic_violations", 0),
            },
        }

        logger.info(f"Trip insights successfully generated for VIN: {vin}")
        return jsonify(convert_numpy(insights_response)), 200

    except Exception as e:
        error_msg = f"Error generating trip insights: {str(e)}"
        logger.error(f"{error_msg}\n{traceback.format_exc()}")
        return jsonify({
            "error": error_msg,
            "timestamp": datetime.now().isoformat()
        }), 500
        


@app.route('/analyze', methods=['POST'])
def analyze_driving_behavior():
    """Main endpoint to analyze driving behavior - called by mobile app"""
    try:
        # Get VIN from request
        if not request.is_json:
            return jsonify({"error": "Request must be JSON"}), 400
        
        vin = request.json.get('vin')
        if not vin:
            return jsonify({"error": "VIN is required"}), 400
        
        logger.info(f"Starting analysis for VIN: {vin}")
        
        # Step 1: Get latest trip/session ID
        logger.info("Step 1: Fetching latest trip information...")
        latest_trip = api_client.get_latest_trip(vin)
        if not latest_trip:
            return jsonify({"error": "Could not fetch latest trip information"}), 404
        
        session_id = latest_trip['session_id']
        logger.info(f"Found latest session: {session_id}")
        
        # Step 2: Fetch trip file (OBD data)
        logger.info("Step 2: Fetching trip file (OBD data)...")
        obd_data = api_client.get_trip_file(vin, session_id)
        if not obd_data:
            return jsonify({"error": "Could not fetch OBD trip data"}), 404
        
        # Step 3: Fetch trip metadata (camera data)
        logger.info("Step 3: Fetching trip metadata (camera data)...")
        camera_data = api_client.get_trip_meta_details(vin, session_id)
        if not camera_data:
            logger.warning("Could not fetch camera metadata, proceeding with OBD-only analysis")
            camera_data = {}
        
        # Step 4: Analyze data
        logger.info("Step 4: Analyzing data...")
        
        # Analyze OBD data
        obd_metrics, obd_df = data_analyzer.analyze_obd_data(obd_data, speed_analyzer)
        if 'error' in obd_metrics:
            return jsonify({"error": f"OBD analysis failed: {obd_metrics['error']}"}), 500
        
        # Analyze camera metadata  
        camera_metrics = data_analyzer.analyze_camera_metadata(camera_data)

        camera_metrics = data_analyzer.detect_red_light_violations(camera_metrics, obd_df)
        
        logger.info(f"Analysis complete:")
        logger.info(f"- OBD metrics: Speed violations: {obd_metrics.get('speed_violation_count', 0)}")
        logger.info(f"- Camera metrics: {camera_metrics}")
        
        # Step 5: Generate LLM analysis
        logger.info("Step 5: Generating LLM analysis...")
        prompt = create_analysis_prompt(obd_metrics, camera_metrics)
        llm_response = query_ollama(prompt)
        
        print(llm_response)
        
        # Parse LLM response
        score, suggestions = parse_llm_response(llm_response)

        # Step 6: Prepare comprehensive response
        try:
            # Insert user if not exists
            insert_user_if_not_exists(vin)

            # Save to database
            save_trip_data(
                vin=vin,
                session_id=session_id,
                score=score,
                improvements=suggestions,
                detailed_analysis={
                    "vehicle_performance": {
                        "avg_speed": round(obd_metrics.get('avg_speed', 0), 2),
                        "max_speed": round(obd_metrics.get('max_speed', 0), 2),
                        "distance_km": round(obd_metrics.get('distance_traveled', 0), 2),
                        "total_records": obd_metrics.get('total_records', 0)
                    },
                    "traffic_compliance": {
                        "urban_speed_violations": obd_metrics.get("urban_speed_violation_count", 0),
                        "highway_speed_violations": obd_metrics.get("highway_speed_violation_count", 0),
                        "speed_violation_count": obd_metrics.get("speed_violation_count", 0)
                    },
                    "attention_and_behavior": {
                        "safe_distractions": camera_metrics.get("safe_distractions", 0),
                        "critical_distractions": camera_metrics.get("critical_distractions", 0),
                        "lane_discipline_score": camera_metrics.get("lane_discipline_score", 0),
                        "traffic_violations": camera_metrics.get("traffic_violations", 0),
                        "total_distraction_score": camera_metrics.get("total_distraction_score", 0)
                    }
                }
            )

        except Exception as db_err:
            logger.error(f"Database error while saving trip: {db_err}")
            return jsonify({"error": "Failed to store trip data"}), 500
        
        
        logger.info(f"Analysis completed successfully. Score: {score}")
        return jsonify(convert_numpy(response))

        
    except Exception as e:
        error_msg = f"Analysis error: {str(e)}"
        logger.error(f"Error in analyze_driving_behavior: {error_msg}")
        logger.error(traceback.format_exc())
        return jsonify({"error": error_msg, "timestamp": datetime.now().isoformat()}), 500

def convert_numpy(obj):
    if isinstance(obj, dict):
        return {k: convert_numpy(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_numpy(i) for i in obj]
    elif isinstance(obj, (np.integer, np.int64)):
        return int(obj)
    elif isinstance(obj, (np.floating, np.float64)):
        return float(obj)
    else:
        return obj


@app.route('/test-connection', methods=['GET'])
def test_connection():
    """Test endpoint to verify Raspberry Pi connectivity"""
    try:
        vin = request.args.get('vin', 'test')
        
        # Test basic connection
        connected = api_client.test_connection()
        if not connected:
            return jsonify({"error": "Cannot connect to Raspberry Pi"}), 500
        
        # Test latest trip endpoint
        latest_trip = api_client.get_latest_trip(vin)
        
        return jsonify({
            "status": "success",
            "raspberry_pi_connected": True,
            "latest_trip_test": latest_trip is not None,
            "latest_trip_data": latest_trip,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("=" * 60)
    print("Enhanced Driver Behavior Analysis System")
    print("=" * 60)
    print("Features:")
    print("✓ Raspberry Pi API integration")
    print("✓ Speed limit compliance analysis via OpenStreetMap")
    print("✓ Traffic violation detection")
    print("✓ Distraction monitoring")
    print("✓ Comprehensive safety scoring with Ollama LLM")
    print("✓ Improved error handling and logging")
    print()
    print("Prerequisites:")
    print("1. Ollama running: ollama serve")
    print("2. Raspberry Pi accessible at:", RASPBERRY_PI_CONFIG['base_url'])
    print("3. Internet connection for OpenStreetMap queries")
    print()
    print("Endpoints:")
    print("- POST /analyze (main endpoint for mobile app)")
    print("- GET /health (system health check)")
    print("- GET /test-connection (test Raspberry Pi connectivity)")
    print()
    print("API Server starting on: http://0.0.0.0:5000")
    print("=" * 60)
    
    app.run()
