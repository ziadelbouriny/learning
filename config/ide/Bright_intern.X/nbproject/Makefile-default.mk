#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../../../modules/comm/can/src/can1.c ../../../modules/mcal/adc/src/adc1.c ../../../modules/mcal/dma/src/dma.c ../../../modules/mcal/pwm/src/pwm.c ../../../modules/mcal/system/src/traps.c ../../../modules/mcal/system/src/system.c ../../../modules/mcal/system/src/clock.c ../../../modules/mcal/system/src/reset.c ../../../modules/mcal/system/src/mcc.c ../../../modules/mcal/system/src/pin_manager.c ../../../modules/mcal/system/src/interrupt_manager.c ../../../modules/mcal/system/src/where_was_i.s ../../../modules/mcal/timer/src/tmr1.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1806128135/can1.o ${OBJECTDIR}/_ext/2039616766/adc1.o ${OBJECTDIR}/_ext/662975830/dma.o ${OBJECTDIR}/_ext/1274508124/pwm.o ${OBJECTDIR}/_ext/1298170971/traps.o ${OBJECTDIR}/_ext/1298170971/system.o ${OBJECTDIR}/_ext/1298170971/clock.o ${OBJECTDIR}/_ext/1298170971/reset.o ${OBJECTDIR}/_ext/1298170971/mcc.o ${OBJECTDIR}/_ext/1298170971/pin_manager.o ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o ${OBJECTDIR}/_ext/1298170971/where_was_i.o ${OBJECTDIR}/_ext/757945629/tmr1.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1806128135/can1.o.d ${OBJECTDIR}/_ext/2039616766/adc1.o.d ${OBJECTDIR}/_ext/662975830/dma.o.d ${OBJECTDIR}/_ext/1274508124/pwm.o.d ${OBJECTDIR}/_ext/1298170971/traps.o.d ${OBJECTDIR}/_ext/1298170971/system.o.d ${OBJECTDIR}/_ext/1298170971/clock.o.d ${OBJECTDIR}/_ext/1298170971/reset.o.d ${OBJECTDIR}/_ext/1298170971/mcc.o.d ${OBJECTDIR}/_ext/1298170971/pin_manager.o.d ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o.d ${OBJECTDIR}/_ext/1298170971/where_was_i.o.d ${OBJECTDIR}/_ext/757945629/tmr1.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1806128135/can1.o ${OBJECTDIR}/_ext/2039616766/adc1.o ${OBJECTDIR}/_ext/662975830/dma.o ${OBJECTDIR}/_ext/1274508124/pwm.o ${OBJECTDIR}/_ext/1298170971/traps.o ${OBJECTDIR}/_ext/1298170971/system.o ${OBJECTDIR}/_ext/1298170971/clock.o ${OBJECTDIR}/_ext/1298170971/reset.o ${OBJECTDIR}/_ext/1298170971/mcc.o ${OBJECTDIR}/_ext/1298170971/pin_manager.o ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o ${OBJECTDIR}/_ext/1298170971/where_was_i.o ${OBJECTDIR}/_ext/757945629/tmr1.o ${OBJECTDIR}/main.o

# Source Files
SOURCEFILES=../../../modules/comm/can/src/can1.c ../../../modules/mcal/adc/src/adc1.c ../../../modules/mcal/dma/src/dma.c ../../../modules/mcal/pwm/src/pwm.c ../../../modules/mcal/system/src/traps.c ../../../modules/mcal/system/src/system.c ../../../modules/mcal/system/src/clock.c ../../../modules/mcal/system/src/reset.c ../../../modules/mcal/system/src/mcc.c ../../../modules/mcal/system/src/pin_manager.c ../../../modules/mcal/system/src/interrupt_manager.c ../../../modules/mcal/system/src/where_was_i.s ../../../modules/mcal/timer/src/tmr1.c main.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=33EP256MC506
MP_LINKER_FILE_OPTION=,--script=p33EP256MC506.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1806128135/can1.o: ../../../modules/comm/can/src/can1.c  .generated_files/flags/default/57b26fc72319b96e3654aee5b4e4fc76302b7f78 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1806128135" 
	@${RM} ${OBJECTDIR}/_ext/1806128135/can1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1806128135/can1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/comm/can/src/can1.c  -o ${OBJECTDIR}/_ext/1806128135/can1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1806128135/can1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/2039616766/adc1.o: ../../../modules/mcal/adc/src/adc1.c  .generated_files/flags/default/f1ef09fee922052a31d867fa0098e2250487c676 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2039616766" 
	@${RM} ${OBJECTDIR}/_ext/2039616766/adc1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2039616766/adc1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/adc/src/adc1.c  -o ${OBJECTDIR}/_ext/2039616766/adc1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/2039616766/adc1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/662975830/dma.o: ../../../modules/mcal/dma/src/dma.c  .generated_files/flags/default/dc896fc994b11f19d7e97775a03c4ce3d314dc6d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/662975830" 
	@${RM} ${OBJECTDIR}/_ext/662975830/dma.o.d 
	@${RM} ${OBJECTDIR}/_ext/662975830/dma.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/dma/src/dma.c  -o ${OBJECTDIR}/_ext/662975830/dma.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/662975830/dma.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1274508124/pwm.o: ../../../modules/mcal/pwm/src/pwm.c  .generated_files/flags/default/9f6a32f51c54c926e40adee03a87f7d28c26fc64 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1274508124" 
	@${RM} ${OBJECTDIR}/_ext/1274508124/pwm.o.d 
	@${RM} ${OBJECTDIR}/_ext/1274508124/pwm.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/pwm/src/pwm.c  -o ${OBJECTDIR}/_ext/1274508124/pwm.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1274508124/pwm.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/traps.o: ../../../modules/mcal/system/src/traps.c  .generated_files/flags/default/a6c782264c6f40162c08ccc45dfd0d5eccc88f2a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/traps.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/traps.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/traps.c  -o ${OBJECTDIR}/_ext/1298170971/traps.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/traps.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/system.o: ../../../modules/mcal/system/src/system.c  .generated_files/flags/default/973d5055e27359335e65f844e91317c8cf1d4e6f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/system.c  -o ${OBJECTDIR}/_ext/1298170971/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/system.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/clock.o: ../../../modules/mcal/system/src/clock.c  .generated_files/flags/default/8ca46c727df88e7a4ce1ae7d73705955d3796093 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/clock.c  -o ${OBJECTDIR}/_ext/1298170971/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/clock.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/reset.o: ../../../modules/mcal/system/src/reset.c  .generated_files/flags/default/9891d14dfa2dab40d18471e01f87530bb5738bfc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/reset.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/reset.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/reset.c  -o ${OBJECTDIR}/_ext/1298170971/reset.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/reset.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/mcc.o: ../../../modules/mcal/system/src/mcc.c  .generated_files/flags/default/2e2ac25a3bd3bdd9cf890669adc182161a2bf4d9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/mcc.c  -o ${OBJECTDIR}/_ext/1298170971/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/mcc.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/pin_manager.o: ../../../modules/mcal/system/src/pin_manager.c  .generated_files/flags/default/79066e262fdd246dc0cf3ea822e85979dc7f0b4c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/pin_manager.c  -o ${OBJECTDIR}/_ext/1298170971/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/pin_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/interrupt_manager.o: ../../../modules/mcal/system/src/interrupt_manager.c  .generated_files/flags/default/cad5046435225c511b8cda97666b405c90f76e99 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/interrupt_manager.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/757945629/tmr1.o: ../../../modules/mcal/timer/src/tmr1.c  .generated_files/flags/default/e351593d6eaa7edabc054f44bf0594d6f3a36fdb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/757945629" 
	@${RM} ${OBJECTDIR}/_ext/757945629/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/757945629/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/timer/src/tmr1.c  -o ${OBJECTDIR}/_ext/757945629/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/757945629/tmr1.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/a0e0beb51afc77837ac02ed71ab41d10174c5e7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -mno-eds-warn  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1806128135/can1.o: ../../../modules/comm/can/src/can1.c  .generated_files/flags/default/a197f112995a9d7c851e1ab73a06aab4a85b509d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1806128135" 
	@${RM} ${OBJECTDIR}/_ext/1806128135/can1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1806128135/can1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/comm/can/src/can1.c  -o ${OBJECTDIR}/_ext/1806128135/can1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1806128135/can1.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/2039616766/adc1.o: ../../../modules/mcal/adc/src/adc1.c  .generated_files/flags/default/e621025258218eeff909c7170a8eba69f69dd6fe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2039616766" 
	@${RM} ${OBJECTDIR}/_ext/2039616766/adc1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2039616766/adc1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/adc/src/adc1.c  -o ${OBJECTDIR}/_ext/2039616766/adc1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/2039616766/adc1.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/662975830/dma.o: ../../../modules/mcal/dma/src/dma.c  .generated_files/flags/default/7f95aa9a48e4c0c8e5907fe2a3a9a11cee74807f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/662975830" 
	@${RM} ${OBJECTDIR}/_ext/662975830/dma.o.d 
	@${RM} ${OBJECTDIR}/_ext/662975830/dma.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/dma/src/dma.c  -o ${OBJECTDIR}/_ext/662975830/dma.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/662975830/dma.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1274508124/pwm.o: ../../../modules/mcal/pwm/src/pwm.c  .generated_files/flags/default/5d2b8b31065b53a8f9a3cfdb80dbe61822b9c478 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1274508124" 
	@${RM} ${OBJECTDIR}/_ext/1274508124/pwm.o.d 
	@${RM} ${OBJECTDIR}/_ext/1274508124/pwm.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/pwm/src/pwm.c  -o ${OBJECTDIR}/_ext/1274508124/pwm.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1274508124/pwm.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/traps.o: ../../../modules/mcal/system/src/traps.c  .generated_files/flags/default/8f55225fcebc429d539102b0e51f24007f2319a3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/traps.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/traps.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/traps.c  -o ${OBJECTDIR}/_ext/1298170971/traps.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/traps.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/system.o: ../../../modules/mcal/system/src/system.c  .generated_files/flags/default/661bad391d424c8175390a76123c6d8c43e71d51 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/system.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/system.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/system.c  -o ${OBJECTDIR}/_ext/1298170971/system.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/system.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/clock.o: ../../../modules/mcal/system/src/clock.c  .generated_files/flags/default/63c484ee4239293358494ed5cd4a20596a683cfb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/clock.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/clock.c  -o ${OBJECTDIR}/_ext/1298170971/clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/clock.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/reset.o: ../../../modules/mcal/system/src/reset.c  .generated_files/flags/default/4b79db36356a6f9dd5396269b621420cdd20b113 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/reset.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/reset.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/reset.c  -o ${OBJECTDIR}/_ext/1298170971/reset.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/reset.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/mcc.o: ../../../modules/mcal/system/src/mcc.c  .generated_files/flags/default/1d4ccad1a9543441a8f467ac2d19b9ad16363787 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/mcc.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/mcc.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/mcc.c  -o ${OBJECTDIR}/_ext/1298170971/mcc.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/mcc.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/pin_manager.o: ../../../modules/mcal/system/src/pin_manager.c  .generated_files/flags/default/af16239c366c7dd92f1b7c6c6381391ab00bf969 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/pin_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/pin_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/pin_manager.c  -o ${OBJECTDIR}/_ext/1298170971/pin_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/pin_manager.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/1298170971/interrupt_manager.o: ../../../modules/mcal/system/src/interrupt_manager.c  .generated_files/flags/default/ce57c7d2c00e1ce00bda96e56cf3972891bc1ec8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/system/src/interrupt_manager.c  -o ${OBJECTDIR}/_ext/1298170971/interrupt_manager.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/1298170971/interrupt_manager.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/_ext/757945629/tmr1.o: ../../../modules/mcal/timer/src/tmr1.c  .generated_files/flags/default/5619354aa2fb68fe65f2f4fcc19bf4213401da47 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/757945629" 
	@${RM} ${OBJECTDIR}/_ext/757945629/tmr1.o.d 
	@${RM} ${OBJECTDIR}/_ext/757945629/tmr1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  ../../../modules/mcal/timer/src/tmr1.c  -o ${OBJECTDIR}/_ext/757945629/tmr1.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/757945629/tmr1.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/226daf43aa7b069ce0e3b37f1d0855b1457fc44f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -mno-eds-warn  -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -O0 -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1298170971/where_was_i.o: ../../../modules/mcal/system/src/where_was_i.s  .generated_files/flags/default/82afdb132283a72547eaaec8cdbb2cee25d9df8c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../../../modules/mcal/system/src/where_was_i.s  -o ${OBJECTDIR}/_ext/1298170971/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -Wa,-MD,"${OBJECTDIR}/_ext/1298170971/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,--defsym=__ICD2RAM=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_ICD4=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/_ext/1298170971/where_was_i.o: ../../../modules/mcal/system/src/where_was_i.s  .generated_files/flags/default/bdfd8ddd16db7644873cceb7161b76b4877badd8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1298170971" 
	@${RM} ${OBJECTDIR}/_ext/1298170971/where_was_i.o.d 
	@${RM} ${OBJECTDIR}/_ext/1298170971/where_was_i.o 
	${MP_CC} $(MP_EXTRA_AS_PRE)  ../../../modules/mcal/system/src/where_was_i.s  -o ${OBJECTDIR}/_ext/1298170971/where_was_i.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -omf=elf -DXPRJ_default=$(CND_CONF)    -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -Wa,-MD,"${OBJECTDIR}/_ext/1298170971/where_was_i.o.d",--defsym=__MPLAB_BUILD=1,-g,--no-relax$(MP_EXTRA_AS_POST)  -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG -D__MPLAB_DEBUGGER_ICD4=1  -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src"  -mreserve=data@0x1000:0x101B -mreserve=data@0x101C:0x101D -mreserve=data@0x101E:0x101F -mreserve=data@0x1020:0x1021 -mreserve=data@0x1022:0x1023 -mreserve=data@0x1024:0x1027 -mreserve=data@0x1028:0x104F   -Wl,--local-stack,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,--defsym=__MPLAB_DEBUGGER_ICD4=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -I"../../../modules/mcal/adc/inc" -I"../../../modules/mcal/adc/src" -I"../../../modules/mcal/dma/src" -I"../../../modules/mcal/system/inc" -I"../../../modules/mcal/timer/src" -I"../../../modules/mcal/system/src" -I"../../../modules/mcal/timer/inc" -I"../../../modules/mcal/dma/inc" -I"../../../modules/comm/can/inc" -I"../../../modules/comm/can/src" -I"../../../modules/mcal/pwm/inc" -I"../../../modules/mcal/pwm/src" -Wl,--local-stack,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--stack=16,--check-sections,--data-init,--pack-data,--handles,--isr,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}/xc16-bin2hex ${DISTDIR}/Bright_intern.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
