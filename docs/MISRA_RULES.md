# 🛡️ MISRA C Rules

This document outlines the MISRA C:2012 guidelines adopted for the **BLDC Engine Cooling Fan Control** project to ensure code safety, reliability, and maintainability in automotive embedded systems.

---

## 📋 **1. MISRA Compliance Overview**

### **Compliance Level**
- **Required**: MISRA C:2012 **Mandatory** rules
- **Recommended**: MISRA C:2012 **Required** rules
- **Optional**: MISRA C:2012 **Advisory** rules (case-by-case basis)

### **Rule Categories**
- **Mandatory**: Must be followed (no deviations)
- **Required**: Should be followed (documented deviations only)
- **Advisory**: Recommended best practices

---

## 🔧 **2. Language Environment (Rules 1.x)**

### **Rule 1.1 - C Standard**
- **Status**: Mandatory
- **Requirement**: Only use C99 standard features
- **Implementation**: Use `-std=c99` compiler flag

### **Rule 1.2 - Language Extensions**
- **Status**: Required
- **Requirement**: Avoid language extensions unless necessary
- **Exceptions**: Microchip-specific extensions for dsPIC33

```c
// ✅ Allowed - Microchip extension for dsPIC33
__builtin_write_OSCCONL(OSCCON & 0xBF9F);

// ❌ Avoid - Non-standard extensions
__asm__ volatile("nop");
```

### **Rule 1.3 - Undefined Behavior**
- **Status**: Mandatory
- **Requirement**: Avoid undefined behavior
- **Implementation**: Use bounds checking, validate inputs

```c
// ✅ Safe array access
if (index < ARRAY_SIZE) {
    value = array[index];
}

// ❌ Unsafe - potential undefined behavior
value = array[index]; // No bounds check
```

---

## 📝 **3. Documentation (Rules 2.x)**

### **Rule 2.1 - Character Sets**
- **Status**: Required
- **Requirement**: Use only ISO/IEC 10646 character set
- **Implementation**: ASCII comments and strings only

### **Rule 2.2 - Source Code**
- **Status**: Required
- **Requirement**: Use only printable characters and control sequences
- **Implementation**: No non-printable characters in source

### **Rule 2.3 - Comments**
- **Status**: Advisory
- **Requirement**: Use `/* */` for comments
- **Implementation**: Avoid `//` comments

```c
/* ✅ Correct comment style */
uint16_t calculate_speed(void);

// ❌ Avoid single-line comments
uint16_t calculate_speed(void);
```

---

## 🔤 **4. Naming Conventions (Rules 3.x)**

### **Rule 3.1 - Character Sets**
- **Status**: Required
- **Requirement**: Use only basic source character set
- **Implementation**: ASCII identifiers only

### **Rule 3.2 - Identifier Length**
- **Status**: Required
- **Requirement**: Maximum 31 characters for internal identifiers
- **Implementation**: Keep names concise but descriptive

```c
// ✅ Good - descriptive but not too long
uint16_t temperature_threshold;

// ❌ Too long for internal identifier
uint16_t temperature_threshold_for_fan_control_system;
```

### **Rule 3.3 - Identifier Uniqueness**
- **Status**: Required
- **Requirement**: Unique identifiers in scope
- **Implementation**: Use prefixes for different modules

```c
// ✅ Good - module prefixes
fan_speed_t fan_get_speed(void);
temp_sensor_t temp_read_sensor(void);

// ❌ Confusing - similar names
uint16_t get_speed(void);
uint16_t get_speed(void); // Different function
```

---

## 📊 **5. Declarations and Definitions (Rules 4.x)**

### **Rule 4.1 - Declarations**
- **Status**: Required
- **Requirement**: All identifiers declared before use
- **Implementation**: Include headers, declare functions

### **Rule 4.2 - Function Declarations**
- **Status**: Required
- **Requirement**: Functions declared with parameters
- **Implementation**: Use function prototypes

```c
// ✅ Good - proper prototype
uint16_t calculate_fan_speed(uint16_t temperature, uint16_t target);

// ❌ Bad - no parameter information
uint16_t calculate_fan_speed();
```

### **Rule 4.3 - Variable Declarations**
- **Status**: Required
- **Requirement**: Variables declared with appropriate types
- **Implementation**: Use stdint.h types

```c
// ✅ Good - explicit types
uint16_t fan_speed;
int16_t temperature;

// ❌ Bad - implementation-defined sizes
int fan_speed;
long temperature;
```

### **Rule 4.4 - Array Declarations**
- **Status**: Required
- **Requirement**: Arrays declared with explicit sizes
- **Implementation**: Use const for array sizes

```c
// ✅ Good - explicit size
#define TEMP_ARRAY_SIZE 10
uint16_t temperature_array[TEMP_ARRAY_SIZE];

// ❌ Bad - magic number
uint16_t temperature_array[10];
```

---

## 🔢 **6. Types (Rules 5.x)**

### **Rule 5.1 - Integer Types**
- **Status**: Required
- **Requirement**: Use stdint.h types
- **Implementation**: uint8_t, uint16_t, int16_t, etc.

```c
// ✅ Good - explicit sizes
uint16_t fan_speed;
int16_t temperature;

// ❌ Bad - implementation-defined
int fan_speed;
long temperature;
```

### **Rule 5.2 - Floating Point**
- **Status**: Required
- **Requirement**: Use double for floating-point calculations
- **Implementation**: Avoid float unless necessary for performance

### **Rule 5.3 - Type Conversions**
- **Status**: Required
- **Requirement**: Explicit casts for type conversions
- **Implementation**: Cast when converting between types

```c
// ✅ Good - explicit cast
uint16_t speed = (uint16_t)(temperature * 100.0 / MAX_TEMP);

// ❌ Bad - implicit conversion
uint16_t speed = temperature * 100.0 / MAX_TEMP;
```

---

## 🔄 **7. Expressions (Rules 6.x)**

### **Rule 6.1 - Side Effects**
- **Status**: Required
- **Requirement**: No side effects in expressions
- **Implementation**: Separate statements for side effects

```c
// ✅ Good - separate statements
uint16_t temp = read_sensor();
if (temp > threshold) {
    set_fan_speed(MAX_SPEED);
}

// ❌ Bad - side effect in condition
if (read_sensor() > threshold) {
    set_fan_speed(MAX_SPEED);
}
```

### **Rule 6.2 - Operator Precedence**
- **Status**: Required
- **Requirement**: Use parentheses for clarity
- **Implementation**: Parenthesize complex expressions

```c
// ✅ Good - clear precedence
uint16_t speed = (temp - min_temp) * 100 / (max_temp - min_temp);

// ❌ Bad - unclear precedence
uint16_t speed = temp - min_temp * 100 / max_temp - min_temp;
```

### **Rule 6.3 - Boolean Expressions**
- **Status**: Required
- **Requirement**: Boolean expressions in control statements
- **Implementation**: Use explicit comparisons

```c
// ✅ Good - explicit boolean
if (temperature > threshold) {
    // action
}

// ❌ Bad - implicit boolean
if (temperature) {
    // action
}
```

---

## 🔀 **8. Control Flow (Rules 7.x)**

### **Rule 7.1 - Control Flow**
- **Status**: Required
- **Requirement**: No unreachable code
- **Implementation**: Remove dead code

### **Rule 7.2 - Switch Statements**
- **Status**: Required
- **Requirement**: Default case in switch statements
- **Implementation**: Always include default case

```c
// ✅ Good - with default case
switch (fan_state) {
    case FAN_OFF:
        turn_off_fan();
        break;
    case FAN_ON:
        turn_on_fan();
        break;
    default:
        handle_error();
        break;
}
```

### **Rule 7.3 - Loop Control**
- **Status**: Required
- **Requirement**: No break/continue in switch statements
- **Implementation**: Use return or goto instead

### **Rule 7.4 - For Loops**
- **Status**: Required
- **Requirement**: Simple initialization and increment
- **Implementation**: Keep loop control simple

```c
// ✅ Good - simple loop control
for (uint8_t i = 0; i < ARRAY_SIZE; i++) {
    process_element(i);
}

// ❌ Bad - complex loop control
for (uint8_t i = 0, j = 0; i < ARRAY_SIZE && j < OTHER_SIZE; i++, j += 2) {
    process_element(i);
}
```

---

## 🏗️ **9. Functions (Rules 8.x)**

### **Rule 8.1 - Function Definitions**
- **Status**: Required
- **Requirement**: Functions have single exit point
- **Implementation**: Use early returns sparingly

```c
// ✅ Good - single exit point
uint16_t calculate_speed(uint16_t temp) {
    uint16_t speed = 0;
    
    if (temp > MIN_TEMP) {
        speed = (temp - MIN_TEMP) * 100 / (MAX_TEMP - MIN_TEMP);
        if (speed > MAX_SPEED) {
            speed = MAX_SPEED;
        }
    }
    
    return speed;
}
```

### **Rule 8.2 - Function Parameters**
- **Status**: Required
- **Requirement**: Parameters not modified
- **Implementation**: Use const for input parameters

```c
// ✅ Good - const input parameter
uint16_t calculate_speed(const uint16_t temperature) {
    return temperature * 100 / MAX_TEMP;
}

// ❌ Bad - parameter modified
uint16_t calculate_speed(uint16_t temperature) {
    temperature = temperature * 100 / MAX_TEMP; // Modifies parameter
    return temperature;
}
```

### **Rule 8.3 - Function Returns**
- **Status**: Required
- **Requirement**: Functions return single type
- **Implementation**: Use error codes or status enums

```c
// ✅ Good - consistent return type
typedef enum {
    FAN_OK = 0,
    FAN_ERROR_INVALID_SPEED,
    FAN_ERROR_SENSOR_FAILURE
} fan_status_t;

fan_status_t set_fan_speed(uint16_t speed) {
    if (speed > MAX_SPEED) {
        return FAN_ERROR_INVALID_SPEED;
    }
    // Implementation
    return FAN_OK;
}
```

---

## 🔍 **10. Pointers and Arrays (Rules 9.x)**

### **Rule 9.1 - Pointer Declarations**
- **Status**: Required
- **Requirement**: Pointers declared with type information
- **Implementation**: Use typedef for complex pointer types

```c
// ✅ Good - clear pointer type
typedef uint16_t* temp_ptr_t;
temp_ptr_t temperature_pointer;

// ❌ Bad - unclear pointer type
uint16_t* temperature_pointer;
```

### **Rule 9.2 - Array Bounds**
- **Status**: Required
- **Requirement**: Array bounds checked before access
- **Implementation**: Validate indices

```c
// ✅ Good - bounds checking
if (index < ARRAY_SIZE) {
    value = array[index];
}

// ❌ Bad - no bounds check
value = array[index];
```

### **Rule 9.3 - Pointer Arithmetic**
- **Status**: Required
- **Requirement**: No pointer arithmetic
- **Implementation**: Use array indexing instead

```c
// ✅ Good - array indexing
for (uint8_t i = 0; i < ARRAY_SIZE; i++) {
    process_element(array[i]);
}

// ❌ Bad - pointer arithmetic
for (uint8_t* ptr = array; ptr < array + ARRAY_SIZE; ptr++) {
    process_element(*ptr);
}
```

---

## 🏛️ **11. Structures and Unions (Rules 10.x)**

### **Rule 10.1 - Structure Definitions**
- **Status**: Required
- **Requirement**: Structures have named members
- **Implementation**: Use descriptive member names

```c
// ✅ Good - named members
typedef struct {
    uint16_t temperature;
    uint16_t fan_speed;
    uint8_t status;
} fan_control_t;

// ❌ Bad - unnamed members
typedef struct {
    uint16_t;
    uint16_t;
    uint8_t;
} fan_control_t;
```

### **Rule 10.2 - Union Usage**
- **Status**: Required
- **Requirement**: Unions used for variant records only
- **Implementation**: Avoid unions for type punning

```c
// ✅ Good - variant record
typedef union {
    uint16_t raw_value;
    struct {
        uint8_t low_byte;
        uint8_t high_byte;
    } bytes;
} sensor_data_t;

// ❌ Bad - type punning
union {
    uint16_t int_value;
    uint8_t byte_array[2];
} converter;
```

---

## 📚 **12. Preprocessing Directives (Rules 11.x)**

### **Rule 11.1 - Macro Definitions**
- **Status**: Required
- **Requirement**: Macros have unique names
- **Implementation**: Use module prefixes

```c
// ✅ Good - unique names
#define FAN_MAX_SPEED 100
#define TEMP_MAX_VALUE 85

// ❌ Bad - generic names
#define MAX_SPEED 100
#define MAX_VALUE 85
```

### **Rule 11.2 - Macro Parameters**
- **Status**: Required
- **Requirement**: Macro parameters parenthesized
- **Implementation**: Parenthesize all macro parameters

```c
// ✅ Good - parenthesized parameters
#define CALC_SPEED(temp) ((temp) * 100 / MAX_TEMP)

// ❌ Bad - unparenthesized parameters
#define CALC_SPEED(temp) temp * 100 / MAX_TEMP
```

### **Rule 11.3 - Include Guards**
- **Status**: Required
- **Requirement**: Header files have include guards
- **Implementation**: Use #ifndef guards

```c
// ✅ Good - include guard
#ifndef FAN_CONTROL_H
#define FAN_CONTROL_H

// Header content

#endif // FAN_CONTROL_H
```

---

## 🔧 **13. Implementation-Specific Features (Rules 12.x)**

### **Rule 12.1 - Compiler Extensions**
- **Status**: Required
- **Requirement**: Document use of extensions
- **Implementation**: Comment all non-standard features

```c
// ✅ Good - documented extension
__builtin_write_OSCCONL(OSCCON & 0xBF9F); // Microchip dsPIC extension

// ❌ Bad - undocumented extension
__builtin_write_OSCCONL(OSCCON & 0xBF9F);
```

### **Rule 12.2 - Assembly Language**
- **Status**: Required
- **Requirement**: Assembly code documented
- **Implementation**: Use inline assembly sparingly

```c
// ✅ Good - documented assembly
__asm__ volatile("nop"); // Single cycle delay for dsPIC33

// ❌ Bad - undocumented assembly
__asm__ volatile("nop");
```

---

## 📋 **14. Deviation Management**

### **Deviation Process**
1. **Document**: Explain why deviation is necessary
2. **Review**: Get approval from team lead
3. **Monitor**: Track deviation impact
4. **Revisit**: Plan to remove deviation

### **Deviation Template**
```c
/*
 * MISRA Deviation: Rule X.Y
 * Reason: [Explain why deviation is necessary]
 * Impact: [Describe safety/performance impact]
 * Mitigation: [How risks are mitigated]
 * Review Date: [When to revisit]
 */
```

---

## 🧪 **15. Compliance Tools**

### **Static Analysis**
- **Tool**: PC-lint Plus with MISRA C:2012
- **Configuration**: Project-specific rule set
- **Frequency**: Every build

### **Code Review**
- **Checklist**: MISRA compliance review
- **Reviewer**: Senior developer
- **Frequency**: Before merge

### **Automation**
- **CI/CD**: Automated MISRA checking
- **Reports**: Compliance dashboard
- **Metrics**: Rule violation tracking

---

## 📚 **16. References**

- [MISRA C:2012 Guidelines](https://www.misra.org.uk/)
- [MISRA C:2012 Amendment 1](https://www.misra.org.uk/)
- [Microchip XC16 Compiler MISRA Support](https://www.microchip.com/)
- [Coding Guidelines](./CODING_GUIDELINES.md)

---

## 📝 **17. Compliance Checklist**

### **Before Code Review**
- [ ] All mandatory rules followed
- [ ] Required rules followed or deviations documented
- [ ] Static analysis passed
- [ ] No compiler warnings
- [ ] Code documented according to standards

### **Before Release**
- [ ] Full MISRA compliance report
- [ ] All deviations approved
- [ ] Performance requirements met
- [ ] Safety requirements validated

---

*Last updated: 2024* 