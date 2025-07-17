/**
  Generated main.c file from MPLAB Code Configurator

  @Company
    Microchip Technology Inc.

  @File Name
    main.c

  @Summary
    This is the generated main.c using PIC24 / dsPIC33 / PIC32MM MCUs.

  @Description
    This source file provides main entry point for system initialization and application code development.
    Generation Information :
        Product Revision  :  PIC24 / dsPIC33 / PIC32MM MCUs - 1.171.5
        Device            :  dsPIC33EP256MC506
    The generated drivers are tested against the following:
        Compiler          :  XC16 v2.10
        MPLAB 	          :  MPLAB X v6.05
*/

/*
    (c) 2020 Microchip Technology Inc. and its subsidiaries. You may use this
    software and any derivatives exclusively with Microchip products.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE, OR ITS INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION
    WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
    BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
    FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
    ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
    THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE
    TERMS.
*/

/**
  Section: Included Files
*/
#include "system.h"
#include "can1.h"


volatile bool canMessageReceived = false;
CAN_MSG_OBJ rxMessage;
uint8_t rxData[8] = {0};


void CAN1_ReceiveCallback(void) {
    if (CAN1_ReceivedMessageCountGet() > 0) {
        if (CAN1_Receive(&rxMessage)) {
            canMessageReceived = true;
        }
    }
}

// Bus-off error handler
void BusErrorHandler(void) {
    while (1);
}



int main(void) {
    SYSTEM_Initialize();
    
    rxMessage.data = rxData;

    // Register callback for receive interrupt
    CAN1_SetRxBufferInterruptHandler(&CAN1_ReceiveCallback);

    // Register error handlers
    CAN1_SetBusErrorHandler(&BusErrorHandler);

    // Enable transmit and receive DMA
    CAN1_TransmitEnable();
    CAN1_ReceiveEnable();

    // Switch to configuration mode first
    CAN1_OperationModeSet(CAN_CONFIGURATION_MODE);
    if (CAN1_OperationModeGet() == CAN_CONFIGURATION_MODE) {
        CAN1_OperationModeSet(CAN_NORMAL_2_0_MODE);
    }

    // Prepare transmit message
    CAN_MSG_OBJ txMessage;
    uint8_t txData[8] = {'H', 'e', 'l', 'l', 'o', 0x01, 0x02, 0x03};
    txMessage.msgId = 0x100;                 // Standard ID
    txMessage.field.idType = CAN_FRAME_STD;  // Standard frame
    txMessage.field.frameType = CAN_FRAME_DATA;
    txMessage.field.dlc = CAN_DLC_8;
    txMessage.data = txData;

    while (1) {
        static uint32_t tickCount = 0;
        if (++tickCount >= 1000000) {
            if (!CAN1_IsBusOff()) {
                CAN1_Transmit(CAN_PRIORITY_LOW, &txMessage);
            }
            tickCount = 0;
        }

        if (canMessageReceived) {
            canMessageReceived = false;

            uint8_t modifiedData[8];

            for (int i = 0; i < rxMessage.field.dlc; i++) {
                modifiedData[i] = rxMessage.data[i] + 1;
            }

            rxMessage.data = modifiedData;
            
            CAN1_Transmit(CAN_PRIORITY_HIGH, &rxMessage);
        }
    }

    return 0;
}
/**
 End of File
*/

