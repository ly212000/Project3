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
    uses {
        interface Read<uint16_t> as TempRead;
        interface Read<uint16_t> as LightRead;
        interface Read<uint16_t> as HumidityRead; 
    }
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
    uint16_t temp;
    uint16_t light;
    uint16_t humidity;
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

        if(call TempRead.read() == SUCCESS){
            // success
        }else {
            call Leds.led1Toggle();     
        }

        if(call LightRead.read() == SUCCESS){
            // success
        }else {
            call Leds.led1Toggle();
        }

        if(call HumidityRead.read() == SUCCESS){
            // success
        }else {
            call Leds.led1Toggle();
        }

        if (_radioBusy == FALSE){
            // Create packet
            SensorMsg_t* msg = call Packet.getPayload(& _packet, sizeof(SensorMsg_t));
            msg -> NodeId = TOS_NODE_ID;
            msg -> Data[0]= (uint8_t) light;
            msg -> Data[1]= (uint8_t) temp;
            msg -> Data[2]= (uint8_t) humidity;
                  
            // Sending packet
            if(call AMSend.send(AM_BROADCAST_ADDR, & _packet, sizeof(SensorMsg_t)) == SUCCESS){
                _radioBusy = TRUE;
            }
        }
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
                //
            }
        }    
        return msg;
    }

    event void TempRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            temp = (uint16_t)(-39.6 + 0.01*val);
        }else {                 //problem
            printf("Error reading from sensor temp! \r\n");
        }
    }

    event void LightRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            light = 2.5*(val/4096.0)*6250.0;
        }else {                 //problem
            printf("Error reading from sensor light! \r\n");
        }
    }

    event void HumidityRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            humidity = -2.0468 + 0.0367*val-1.5955*pow(10,-6)*val*val;
        }else {                 //problem
            printf("Error reading from sensor humidity! \r\n");
        }
    }
}