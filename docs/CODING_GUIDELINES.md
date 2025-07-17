# 📝 Coding Guidelines

This document outlines the coding standards and guidelines for the **BLDC Engine Cooling Fan Control** project, following conventional clang coding guidelines.

---

## 🎯 **1. General Principles**

### **Code Style**
- Follow **conventional clang formatting** standards
- Use **4-space indentation** (no tabs)
- Maximum line length: **120 characters**
- Use **Unix line endings** (LF, not CRLF)

### **Naming Conventions**
- **Functions**: Must be prefixed by the component/module name in uppercase, followed by the subject, with the verb/action at the end (e.g., `VMD_voltageGet()`).
- **Variables**: `snake_case` for local variables (e.g., `current_temperature`). All global variables must be prefixed by the component/module name in uppercase (e.g., `VMD_current_temperature`).
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `MAX_FAN_SPEED`)
- **Macros**: `UPPER_SNAKE_CASE` (e.g., `#define MAX_TEMP 85`)
- **Types**: `snake_case` with `_t` suffix (e.g., `fan_state_t`)

#### **Detailed Naming Rules**
- **Functions**: Prefix with component/module name in uppercase, subject, then verb/action at the end (e.g., `VMD_voltageGet()`, `FAN_speedSet()`).
- **Global Variables**: Prefix with component/module name in uppercase (e.g., `VMD_current_temperature`).
- **Modules/Files**: Use lowercase with underscores (e.g., `fan_control.c`, `temperature_sensor.h`).
- **Structs**: `snake_case` with `_t` suffix (e.g., `fan_status_t`).
- **Unions**: `snake_case` with `_u` suffix (e.g., `sensor_data_u`).
- **Enums**: `snake_case` with `_e` suffix for the type (e.g., `fan_mode_e`), and `UPPER_SNAKE_CASE` for values (e.g., `FAN_MODE_OFF`).
- **Pointers**: Use `p_` prefix for pointer variables (e.g., `p_buffer`, `p_fan_status`).
- **Static/Internal Variables**: Prefix with `s_` (e.g., `s_last_error`).
- **Abbreviations**: Avoid unless widely recognized (e.g., use `temperature` not `temp`, except for well-known terms like `adc`, `pwm`).
- **Acronyms**: Use lowercase if part of a name (e.g., `can_message_id`), all uppercase if standalone constant (e.g., `MAX_PWM`).
- **Boolean Variables**: Use `is_`, `has_`, `can_`, or `should_` prefixes (e.g., `is_enabled`, `has_error`).
- **Function Parameters**: Use descriptive names (e.g., `speed`, `temperature`, `threshold`).
- **Prefix/Suffix for Clarity**: Use suffixes like `_min`, `_max`, `_cnt`, `_idx`, `_flag` for clarity (e.g., `speed_max`, `error_flag`).

#### **Examples**
```c
// Function naming
uint16_t FAN_voltageGet(void);
void FAN_speedSet(uint16_t speed);

// Global variable
uint16_t FAN_currentTemperature;

// Struct and enum naming
typedef struct {
    uint16_t speed;
    uint16_t temperature;
    bool is_enabled;
} fan_status_t;

typedef enum {
    FAN_MODE_OFF = 0,
    FAN_MODE_AUTO,
    FAN_MODE_MANUAL
} fan_mode_e;

// Pointer variable
uint16_t *p_buffer;

// Static/internal variable
static uint8_t s_errorCount;

// Boolean variable
bool is_overheated;

// Macro
#define FAN_MAX_SPEED 100

// Constant
const uint16_t FAN_temperatureThreshold = 85;
```

---

## 🔧 **2. C Language Standards**

### **C Standard**
- Use **C99** standard for all new code
- Avoid C11 features unless absolutely necessary
- Ensure compatibility with **XC16 compiler**

### **Header Files**
```c
#ifndef FAN_CONTROL_H
#define FAN_CONTROL_H

// Include standard headers first
#include <stdint.h>
#include <stdbool.h>

// Then project headers
#include "config.h"
#include "types.h"

// Function declarations
void FAN_init(void);
bool FAN_speedSet(uint16_t speed);

#endif // FAN_CONTROL_H
```

### **Source Files**
```c
// File header comment
/**
 * @file fan_control.c
 * @brief BLDC fan control implementation
 * @author Your Name
 * @date 2024
 */

// Include order
#include "fan_control.h"
#include <xc.h>
#include <libpic30.h>
```

---

## 📋 **3. Code Organization**

### **Function Structure**
```c
/**
 * @brief Calculate optimal fan speed based on temperature
 * @param temperature Current temperature in Celsius
 * @param target_temp Target temperature in Celsius
 * @return Calculated fan speed (0-100%)
 */
uint16_t FAN_speedCalculate(uint16_t temperature, uint16_t targetTemperature)
{
    // Input validation
    if (temperature > FAN_MAX_SPEED) {
        return FAN_MAX_SPEED;
    }
    
    // Main logic
    uint16_t speed = 0;
    if (temperature > targetTemperature) {
        speed = ((temperature - targetTemperature) * 100) / (FAN_MAX_SPEED - targetTemperature);
        if (speed > FAN_MAX_SPEED) {
            speed = FAN_MAX_SPEED;
        }
    }
    
    return speed;
}
```

### **Variable Declarations**
- Declare variables at the beginning of their scope
- Initialize variables when declaring
- Use meaningful names that describe purpose

```c
void FAN_temperatureProcess(void)
{
    uint16_t FAN_currentTemperature = FAN_temperatureSensorRead();
    uint16_t FAN_filteredTemperature = FAN_lowPassFilterApply(FAN_currentTemperature);
    uint16_t FAN_speed = FAN_speedCalculate(FAN_filteredTemperature, FAN_temperatureThreshold);
    FAN_speedSet(FAN_speed);
}
```

---

## 🛡️ **4. Safety and Reliability**

### **Error Handling**
- Always check return values from functions
- Use meaningful error codes
- Implement graceful degradation

```c
typedef enum {
    FAN_OK = 0,
    FAN_ERROR_INVALID_SPEED,
    FAN_ERROR_SENSOR_FAILURE,
    FAN_ERROR_COMMUNICATION
} fan_error_t;

fan_error_t FAN_speedSet(uint16_t speed)
{
    if (speed > FAN_MAX_SPEED) {
        return FAN_ERROR_INVALID_SPEED;
    }
    
    // Implementation
    return FAN_OK;
}
```

### **Resource Management**
- Always initialize hardware peripherals
- Implement proper shutdown sequences
- Use const qualifiers for read-only data

```c
// Configuration data should be const
static const uint16_t FAN_temperatureThresholds[] = {30, 50, 70, 85};
static const uint8_t FAN_numThresholds = sizeof(FAN_temperatureThresholds) / sizeof(FAN_temperatureThresholds[0]);
```

---

## 🔍 **5. Documentation Standards**

### **Function Documentation**
Use Doxygen-style comments for all public functions:

```c
/**
 * @brief Initialize the fan control system
 * 
 * This function configures the PWM module, ADC channels, and GPIO pins
 * required for fan control operation.
 * 
 * @return true if initialization successful, false otherwise
 * @note Must be called before any other fan control functions
 */
bool FAN_controlInit(void);
```

### **Code Comments**
- Comment **why**, not **what**
- Use `//` for single-line comments
- Use `/* */` for multi-line comments
- Document complex algorithms and business logic

```c
// Apply hysteresis to prevent rapid speed changes
if (abs(new_speed - current_speed) < HYSTERESIS_THRESHOLD) {
    return current_speed;
}
```

---

## ⚡ **6. Performance Guidelines**

### **Optimization**
- Use `static` for internal functions
- Minimize function call overhead in critical paths
- Use `inline` for small, frequently called functions
- Profile code before optimizing

```c
static inline uint16_t FAN_valueClamp(uint16_t value, uint16_t min, uint16_t max)
{
    if (value < min) return min;
    if (value > max) return max;
    return value;
}
```

### **Memory Usage**
- Use appropriate data types (uint8_t, uint16_t, etc.)
- Avoid dynamic memory allocation
- Use const for read-only data
- Minimize stack usage in interrupt handlers

---

## 🧪 **7. Testing Guidelines**

### **Unit Testing**
- Write testable code with clear interfaces
- Use dependency injection where possible
- Mock hardware dependencies for testing
- Aim for high code coverage

### **Integration Testing**
- Test hardware interactions
- Verify timing requirements
- Validate error handling paths

---

## 📝 **8. Code Review Checklist**

### **Before Submitting**
- [ ] Code follows naming conventions
- [ ] Functions are properly documented
- [ ] Error handling is implemented
- [ ] No compiler warnings
- [ ] Code is properly formatted
- [ ] Unit tests pass
- [ ] Integration tests pass

### **Review Points**
- [ ] Logic is correct and efficient
- [ ] Error conditions are handled
- [ ] Code is readable and maintainable
- [ ] Documentation is accurate
- [ ] No security vulnerabilities
- [ ] Performance requirements met

---

## 🔧 **9. Tools and Automation**

### **Code Formatting**
- Use `clang-format` with project-specific configuration
- Run formatting before committing
- Configure IDE to format on save

### **Static Analysis**
- Use compiler warnings (`-Wall -Wextra`)
- Consider using static analysis tools
- Address all warnings and errors

### **Build Configuration**
```makefile
CFLAGS += -Wall -Wextra -Werror
CFLAGS += -std=c99
CFLAGS += -O2
```

---

## 📚 **10. References**

- [Clang Formatting Style Guide](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
- [Microchip XC16 Compiler User Guide](https://www.microchip.com/en-us/tools-resources/develop/mplab-xc-compilers/xc16)
- [MISRA C Guidelines](./MISRA_RULES.md)

---

*Last updated: 2024* 