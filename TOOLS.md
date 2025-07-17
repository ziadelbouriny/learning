# 🛠️ Project Development Tools

This document lists all tools required to develop, build, and debug the **BLDC Engine Cooling Fan Control** project.

---

## 🔧 **1. Microchip MPLAB X IDE**

- **Description**: Integrated Development Environment (IDE) for Microchip PIC and dsPIC microcontrollers.
- **Recommended Version**: v6.x or newer
- **Download Link**: [MPLAB X IDE Download](https://www.microchip.com/en-us/tools-resources/develop/mplab-x-ide)

### ✅ **Key Features**
- Project management for dsPIC33 and PIC24 devices
- Integrated debugger support
- Compatible with XC16 compiler

---

## 🔧 **2. Microchip XC16 Compiler**

- **Description**: ANSI C compiler for 16-bit PIC24 and dsPIC33 microcontrollers.
- **Recommended Version**: v2.x or newer
- **Download Link**: [XC16 Compiler Download](https://www.microchip.com/en-us/tools-resources/develop/mplab-xc-compilers/xc16)

### ✅ **Key Features**
- Optimisations for real-time embedded applications
- Command-line build support for CI/CD pipelines
- Free and PRO licenses available

---

## 🔧 **3. Development Board**

- **Description**: Development board for dsPIC33 microcontroller family.
- **Model**: dsPIC33 Development Board
- **Datasheet**: [DS-52080a.pdf](./docs/datasheets/DS-52080a.pdf)

### ✅ **Key Features**
- dsPIC33 microcontroller support
- Integrated debugging capabilities
- Peripheral interfaces for fan control development
- On-board sensors and actuators for testing

### 🔗 **Documentation**
- **Datasheet**: [DS-52080a.pdf](./docs/datasheets/DS-52080a.pdf) - Complete technical specifications and pin configurations
- **User Guide**: Refer to datasheet for setup and configuration instructions

---

## 🔧 **4. Microcontroller**

- **Description**: dsPIC33CK Digital Signal Controller for motor control applications.
- **Model**: dsPIC33CK64MC105
- **Architecture**: 16-bit dsPIC33CK with DSP capabilities
- **Datasheet**: [dsPIC33CK64MC105 Datasheet](./docs/datasheets/dsPIC33CK64MC105%20Motor%20Control%20Plug-In%20Module%20(PIM)%20Information%20Sheet%20for%20External%20Op%20Amp%20Configuration%20DS-50002925a%20(1).pdf)

### ✅ **Key Features**
- **Core**: 16-bit dsPIC33CK with DSP instructions
- **Motor Control**: Specialized for BLDC motor control applications
- **PWM Modules**: Multiple PWM modules for motor control
- **ADC**: High-speed ADC for sensor reading
- **Communication**: UART, SPI, I2C interfaces
- **Timers**: Multiple timers for precise control loops

### 🔧 **Peripherals for Fan Control**
- **PWM Modules**: For BLDC motor control
- **ADC Channels**: For temperature sensor reading
- **GPIO Pins**: For control signals and status LEDs
- **Timer Modules**: For precise timing and control loops
- **Communication**: CAN, UART for system communication

---

## 💡 **Notes**

- Ensure MPLAB X IDE and XC16 compiler are installed and added to your system PATH for command-line builds.  
- For production releases, **XC16 PRO license** is recommended to maximise optimisation performance.  
- Always check for **latest versions** before integrating into your build environment to avoid compatibility issues.

---

### 📌 **Future Tooling**

Other tools such as CAN analyzers, debugger firmware versions, and script toolchains will be documented as integration progresses.

---

