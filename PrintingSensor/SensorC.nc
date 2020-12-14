#include <Timer.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <UserButton.h>
#include "Sensor.h"

module SensorC
{
    // general interface
    uses {
        interface Boot;
        interface Timer<TMilli>;
        interface Leds;
    }
    //UserButton
    uses {
        interface Get<button_state_t>;
        interface Notify<button_state_t>;
    }
    /*
    uses {
        interface Read<uint16_t> as TempRead;
        interface Read<uint16_t> as LightRead;
        interface Read<uint16_t> as HumidityRead; 
    }*/
    //Radio
    uses {
        interface Packet;
        interface AMPacket;
        interface AMSend;
        interface SplitControl as AMControl;
        interface Receive;
    }
}

implementation {

    bool _radioBusy = FALSE;
    message_t _packet;
    SensorMsg_t *_Node;
    

    event void Boot.booted(){
        _Node -> NodeId = TOS_NODE_ID;
        _Node -> Data[0] = 0;   // set Light = 0
        _Node -> Data[1] = 0;   // set temperature = 0
        _Node -> Data[2] = 0;   // set humidity = 0
        call Timer.startPeriodic(5000);
        call Notify.enable();
        call AMControl.start();
    }

    event void Notify.notify(button_state_t val){
        
    }

    event void Timer.fired(){
        printf("\r\n\n");
    }

    

    event void AMSend.sendDone(message_t *msg, error_t error){
        if (msg == & _packet){
            _radioBusy = FALSE;
        }
    }

    event void AMControl.startDone(error_t error){
        if (error == SUCCESS){
            call Leds.led0On();

        }else{
            call AMControl.start();

        }
    }

    event void AMControl.stopDone(error_t error){

    }

    event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){
        if (len == sizeof(SensorMsg_t)){
            SensorMsg_t * incomingPacket = (SensorMsg_t*)payload;
            if (incomingPacket -> NodeId != 1){
                printf("Sensor gui id = %d la : %d ; %d ; %d \r\n", incomingPacket->NodeId,
                 incomingPacket->Data[0],incomingPacket->Data[1], incomingPacket->Data[2]);
            }
        }    
        return msg;
    }
}