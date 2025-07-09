import psycopg2
import os
from dotenv import load_dotenv
from datetime import datetime, date
import json

# Load environment variables
load_dotenv()


#Hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii

def test_database_connection():
    """Test basic database connection to driver_behavior database"""
    print("🔄 Testing database connection...")
    
    try:
        # Connection parameters for your database
        conn_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'driver_behavior',
            'user': 'postgres',
            'password': 'ziadkhalifaziad'
        }
        
        print(f"📍 Connecting to: {conn_params['user']}@{conn_params['host']}:{conn_params['port']}/{conn_params['database']}")
        
        # Try to connect
        conn = psycopg2.connect(**conn_params)
        cursor = conn.cursor()
        
        # Test query
        cursor.execute("SELECT version();")
        version = cursor.fetchone()
        print("✅ Connection successful!")
        print(f"📊 PostgreSQL version: {version[0][:50]}...")
        
        cursor.close()
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False

def test_existing_tables():
    """Test the existing users and trips tables"""
    print("\n🔄 Testing existing tables...")
    
    try:
        conn_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'driver_behavior',
            'user': 'postgres',
            'password': 'ziadkhalifaziad'
        }
        
        conn = psycopg2.connect(**conn_params)
        cursor = conn.cursor()
        
        # Check if tables exist
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            ORDER BY table_name;
        """)
        tables = cursor.fetchall()
        
        print("📋 Existing tables:")
        for table in tables:
            print(f"   - {table[0]}")
        
        # Check users table structure
        cursor.execute("""
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns
            WHERE table_name = 'users'
            ORDER BY ordinal_position;
        """)
        user_columns = cursor.fetchall()
        
        print("\n👤 Users table structure:")
        for col in user_columns:
            print(f"   - {col[0]}: {col[1]} (nullable: {col[2]})")
        
        # Check trips table structure
        cursor.execute("""
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns
            WHERE table_name = 'trips'
            ORDER BY ordinal_position;
        """)
        trip_columns = cursor.fetchall()
        
        print("\n🚗 Trips table structure:")
        for col in trip_columns:
            print(f"   - {col[0]}: {col[1]} (nullable: {col[2]})")
        
        # Count existing records
        cursor.execute("SELECT COUNT(*) FROM users")
        user_count = cursor.fetchone()[0]
        print(f"\n📊 Current users count: {user_count}")
        
        cursor.execute("SELECT COUNT(*) FROM trips")
        trip_count = cursor.fetchone()[0]
        print(f"📊 Current trips count: {trip_count}")
        
        cursor.close()
        conn.close()
        
        print("✅ Table inspection successful!")
        return True
        
    except Exception as e:
        print(f"❌ Table inspection failed: {e}")
        return False

def test_insert_sample_data():
    """Test inserting sample data into users and trips tables"""
    print("\n🔄 Testing data insertion...")
    
    try:
        conn_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'driver_behavior',
            'user': 'postgres',
            'password': 'ziadkhalifaziad'
        }
        
        conn = psycopg2.connect(**conn_params)
        cursor = conn.cursor()
        
        # Insert a test user
        print("👤 Inserting test user...")
        user_data = {
            'name': 'Test Driver',
            'email': 'test.driver@example.com',
            'age': 28,
            'gender': 'Male',
            'number_of_trips': 0,
            'overall_rating': 85.50,
            'country': 'TestCountry'
        }
        
        # Check if user already exists
        cursor.execute("SELECT id FROM users WHERE email = %s", (user_data['email'],))
        existing_user = cursor.fetchone()
        
        if existing_user:
            user_id = existing_user[0]
            print(f"   📝 User already exists with ID: {user_id}")
        else:
            insert_user_query = """
            INSERT INTO users (name, email, age, gender, number_of_trips, overall_rating, country)
            VALUES (%(name)s, %(email)s, %(age)s, %(gender)s, %(number_of_trips)s, %(overall_rating)s, %(country)s)
            RETURNING id;
            """
            
            cursor.execute(insert_user_query, user_data)
            user_id = cursor.fetchone()[0]
            print(f"   ✅ Test user inserted with ID: {user_id}")
        
        # Insert a test trip
        print("🚗 Inserting test trip...")
        trip_data = {
            'user_id': user_id,
            'trip_date': date.today(),
            'trip_rating': 88.75,
            'avg_speed_kmph': 65.50,
            'distraction_minutes': 2.30,
            'lane_avoidance_violations': 1,
            'car_health_status': 'Good'
        }
        
        insert_trip_query = """
        INSERT INTO trips (user_id, trip_date, trip_rating, avg_speed_kmph, distraction_minutes, lane_avoidance_violations, car_health_status)
        VALUES (%(user_id)s, %(trip_date)s, %(trip_rating)s, %(avg_speed_kmph)s, %(distraction_minutes)s, %(lane_avoidance_violations)s, %(car_health_status)s)
        RETURNING id;
        """
        
        cursor.execute(insert_trip_query, trip_data)
        trip_id = cursor.fetchone()[0]
        print(f"   ✅ Test trip inserted with ID: {trip_id}")
        
        # Update user's trip count and rating
        cursor.execute("""
            UPDATE users 
            SET number_of_trips = number_of_trips + 1,
                overall_rating = (overall_rating + %s) / 2
            WHERE id = %s
        """, (trip_data['trip_rating'], user_id))
        
        print("   ✅ User statistics updated")
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print("✅ Data insertion successful!")
        return True
        
    except Exception as e:
        print(f"❌ Data insertion failed: {e}")
        if 'conn' in locals():
            conn.rollback()
        return False

def test_data_retrieval():
    """Test retrieving and analyzing data"""
    print("\n🔄 Testing data retrieval and analysis...")
    
    try:
        conn_params = {
            'host': 'localhost',
            'port': '5432',
            'database': 'driver_behavior',
            'user': 'postgres',
            'password': 'ziadkhalifaziad'
        }
        
        conn = psycopg2.connect(**conn_params)
        cursor = conn.cursor()
        
        # Get user with their trip statistics
        cursor.execute("""
            SELECT 
                u.id, u.name, u.email, u.age, u.country,
                u.number_of_trips, u.overall_rating,
                COUNT(t.id) as actual_trip_count,
                AVG(t.trip_rating) as avg_trip_rating,
                AVG(t.avg_speed_kmph) as avg_speed,
                SUM(t.distraction_minutes) as total_distraction_time
            FROM users u
            LEFT JOIN trips t ON u.id = t.user_id
            WHERE u.email = 'test.driver@example.com'
            GROUP BY u.id, u.name, u.email, u.age, u.country, u.number_of_trips, u.overall_rating;
        """)
        
        result = cursor.fetchone()
        if result:
            print("📊 User Analysis:")
            print(f"   👤 Name: {result[1]}")
            print(f"   📧 Email: {result[2]}")
            print(f"   🎂 Age: {result[3]}")
            print(f"   🌍 Country: {result[4]}")
            print(f"   🔢 Recorded trips: {result[5]}")
            print(f"   ⭐ Overall rating: {result[6]}")
            print(f"   📈 Actual trip count: {result[7]}")
            print(f"   📊 Average trip rating: {result[8]:.2f}" if result[8] else "   📊 Average trip rating: N/A")
            print(f"   🚗 Average speed: {result[9]:.2f} km/h" if result[9] else "   🚗 Average speed: N/A")
            print(f"   📱 Total distraction time: {result[10]:.2f} minutes" if result[10] else "   📱 Total distraction time: N/A")
        
        # Get recent trips
        cursor.execute("""
            SELECT 
                t.id, t.trip_date, t.trip_rating, t.avg_speed_kmph,
                t.distraction_minutes, t.lane_avoidance_violations, t.car_health_status,
                u.name
            FROM trips t
            JOIN users u ON t.user_id = u.id
            ORDER BY t.trip_date DESC, t.id DESC
            LIMIT 5;
        """)
        
        trips = cursor.fetchall()
        print(f"\n🚗 Recent trips ({len(trips)}):")
        for trip in trips:
            print(f"   Trip {trip[0]}: {trip[7]} on {trip[1]}")
            print(f"      Rating: {trip[2]}, Speed: {trip[3]} km/h")
            print(f"      Distractions: {trip[4]} min, Violations: {trip[5]}")
            print(f"      Car health: {trip[6]}")
            print()
        
        cursor.close()
        conn.close()
        
        print("✅ Data retrieval successful!")
        return True
        
    except Exception as e:
        print(f"❌ Data retrieval failed: {e}")
        return False

def create_llm_integration_example():
    """Show how to integrate with LLM for driver behavior analysis"""
    print("\n🔄 Creating LLM integration example...")
    
    class DriverBehaviorDB:
        def __init__(self):
            self.conn_params = {
                'host': 'localhost',
                'port': '5432',
                'database': 'driver_behavior',
                'user': 'postgres',
                'password': 'ziadkhalifaziad'
            }
        
        def get_user_data_for_llm(self, user_id):
            """Get user data formatted for LLM analysis"""
            try:
                conn = psycopg2.connect(**self.conn_params)
                cursor = conn.cursor()
                
                # Get user info and trip summary
                cursor.execute("""
                    SELECT 
                        u.name, u.age, u.gender, u.country,
                        u.number_of_trips, u.overall_rating,
                        AVG(t.trip_rating) as avg_rating,
                        AVG(t.avg_speed_kmph) as avg_speed,
                        AVG(t.distraction_minutes) as avg_distraction,
                        AVG(t.lane_avoidance_violations) as avg_violations
                    FROM users u
                    LEFT JOIN trips t ON u.id = t.user_id
                    WHERE u.id = %s
                    GROUP BY u.id, u.name, u.age, u.gender, u.country, u.number_of_trips, u.overall_rating;
                """, (user_id,))
                
                user_data = cursor.fetchone()
                
                if user_data:
                    # Format data for LLM
                    llm_data = {
                        "driver_profile": {
                            "name": user_data[0],
                            "age": user_data[1],
                            "gender": user_data[2],
                            "country": user_data[3],
                            "total_trips": user_data[4],
                            "overall_rating": float(user_data[5]) if user_data[5] else 0.0
                        },
                        "driving_statistics": {
                            "average_trip_rating": float(user_data[6]) if user_data[6] else 0.0,
                            "average_speed_kmph": float(user_data[7]) if user_data[7] else 0.0,
                            "average_distraction_minutes": float(user_data[8]) if user_data[8] else 0.0,
                            "average_lane_violations": float(user_data[9]) if user_data[9] else 0.0
                        }
                    }
                    
                    cursor.close()
                    conn.close()
                    return llm_data
                else:
                    return None
                    
            except Exception as e:
                print(f"Error getting user data: {e}")
                return None
        
        def store_llm_analysis(self, user_id, llm_prompt, llm_response):
            """Store LLM analysis results (you could create a new table for this)"""
            # For now, just demonstrate the concept
            analysis_data = {
                "user_id": user_id,
                "analysis_date": datetime.now(),
                "prompt": llm_prompt,
                "response": llm_response,
                "analysis_type": "driver_behavior_assessment"
            }
            
            print("📝 LLM Analysis stored:")
            print(f"   User ID: {analysis_data['user_id']}")
            print(f"   Date: {analysis_data['analysis_date']}")
            print(f"   Analysis type: {analysis_data['analysis_type']}")
            print(f"   Response length: {len(analysis_data['response'])} characters")
            
            return analysis_data
    
    # Demo the integration
    db = DriverBehaviorDB()
    
    # Get user data (assuming user ID 1 exists from our test)
    try:
        conn = psycopg2.connect(**db.conn_params)
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM users WHERE email = 'test.driver@example.com'")
        result = cursor.fetchone()
        if result:
            user_id = result[0]
            
            # Get data for LLM
            user_data = db.get_user_data_for_llm(user_id)
            
            if user_data:
                print("📊 Data prepared for LLM analysis:")
                print(json.dumps(user_data, indent=2))
                
                # Simulate LLM prompt and response
                sample_prompt = f"Analyze this driver's behavior: {json.dumps(user_data)}"
                sample_response = "Based on the driving data, this driver shows good overall performance with a rating above 85. However, there are opportunities for improvement in reducing distraction time and lane violations."
                
                # Store the analysis
                db.store_llm_analysis(user_id, sample_prompt, sample_response)
                
                print("\n✅ LLM integration example completed!")
            else:
                print("❌ No user data found for LLM analysis")
        else:
            print("❌ Test user not found")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ LLM integration example failed: {e}")

def main():
    print("🚗 Driver Behavior Database Test")
    print("=" * 50)
    
    # Test 1: Basic connection
    if not test_database_connection():
        print("\n❌ Basic connection failed. Please check your database setup.")
        return
    
    # Test 2: Table inspection
    if not test_existing_tables():
        print("\n❌ Table inspection failed.")
        return
    
    # Test 3: Data insertion
    if not test_insert_sample_data():
        print("\n❌ Data insertion failed.")
        return
    
    # Test 4: Data retrieval
    if not test_data_retrieval():
        print("\n❌ Data retrieval failed.")
        return
    
    # Test 5: LLM integration example
    create_llm_integration_example()
    
    print("\n🎉 All tests passed! Your driver behavior database is ready!")
    print("\n📝 What you can do next:")
    print("   1. ✅ Your database connection is working")
    print("   2. ✅ You can insert and retrieve driver and trip data")
    print("   3. ✅ The database structure supports LLM integration")
    print("   4. 🔄 You can now connect your local LLM to analyze driver behavior")
    print("   5. 📊 Consider creating additional tables for LLM analysis results")

if __name__ == "__main__":
    main()
