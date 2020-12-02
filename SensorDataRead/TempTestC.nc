#include <Timer.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

module TempTestC {
    uses {
        interface Boot;
        interface Timer<TMilli>;
        interface Leds;

        // Read
        interface Read<uint16_t> as TempRead;
        interface Read<uint16_t> as LightRead;
        interface Read<uint16_t> as HumidityRead; 

    }
}

implementation {
    uint16_t temp;
    uint16_t light;
    uint16_t humidity;
    
    event void Boot.booted(){
        call Timer.startPeriodic(5000);
        call Leds.led1On();
    }

    event void Timer.fired(){
        if(call TempRead.read() == SUCCESS){
            call Leds.led2Toggle();     // success
        }else {
            call Leds.led2Toggle();     // problem
        }

        if(call LightRead.read() == SUCCESS){
            call Leds.led0Toggle();     // success
        }else {
            call Leds.led0Toggle();     // problem
        }

        if(call HumidityRead.read() == SUCCESS){
            call Leds.led1Toggle();     // success
        }else {
            call Leds.led1Toggle();     // problem
        }

    }

    event void TempRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            temp = (uint16_t)(-39.6 + 0.01*val);
           // printf("    temp is : %d ", temp);
           printf("value is: %d", val);
        }else {                 //problem
            printf("Error reading from sensor temp! \r\n");
        }
    }

    event void LightRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            light = 2.5*(val/4096.0)*6250.0;
         //   printf("Current  light is : %d", light);
        }else {                 //problem
            printf("Error reading from sensor light! \r\n");
        }
    }

    event void HumidityRead.readDone(error_t result, uint16_t val){
        if (result == SUCCESS){      // success
            humidity = -2.0468 + 0.0367*val-1.5955*pow(10,-6)*val*val;
          //  printf("    humidity is : %d % \r\n\n", humidity);
        }else {                 //problem
            printf("Error reading from sensor humidity! \r\n");
        }
    }
}