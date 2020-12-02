#include <Timer.h>
#include <UserButton.h>
module ButtonControlC {
    uses {
        interface Boot;
        interface Get<button_state_t>;
        interface Notify<button_state_t>;
        interface Timer<TMilli> as MoodTimer;
        interface Timer<TMilli> as Timer0;
        interface Timer<TMilli> as Timer1;
        interface Timer<TMilli> as Timer2;
        interface Leds;
    }
}

implementation {
    uint8_t mood;
    uint8_t redVar;     //Led0
    uint8_t yellowVar;  //Led1
    uint8_t blueVar;    //Led2

    event void Boot.booted(){
        call Notify.enable();
        mood = 0;
        redVar = 0;
        yellowVar = 0;
        blueVar = 0;
    }

    event void Notify.notify(button_state_t value){
        /*if (value == BUTTON_PRESSED && mood == 0){
            call Leds.led0On();
        }else if  (value == BUTTON_RELEASED && mood == 0){
            call Leds.led0Off();
            mood = 1;
        }else if (value == BUTTON_PRESSED && mood == 1){
            call Leds.led1On();
        }else if  (value == BUTTON_RELEASED && mood == 1){
            call Leds.led1Off();
            mood = 2;
        }else if (value == BUTTON_PRESSED && mood == 2){
            call Leds.led2On();
        }else if (value == BUTTON_RELEASED && mood == 2){
            call Leds.led2Off();
            mood = 3;
        }else if (value == BUTTON_PRESSED && mood == 3){
            call MoodTimer.startPeriodic(1000);
        }else if (value == BUTTON_RELEASED && mood == 3){
            mood = 0;
            call MoodTimer.stopC();
        
        }*/


        if (value == BUTTON_PRESSED && mood == 0){
            mood = 1;
        }else if (value == BUTTON_PRESSED && mood == 1){
            mood = 2;
        }else if (value == BUTTON_PRESSED && mood == 2){
            mood = 3;
        }else if (value == BUTTON_PRESSED && mood == 3){
            //MoodTimer.startPeriodic(2000);
            mood = 0;
            call MoodTimer.stop();
            call Timer0.stop();
            call Timer1.stop();
            call Timer2.stop();
        }


        if(mood == 0){
            call Leds.led0On();
            //call Leds.led1Off();
            //call Leds.led2Off();
            call MoodTimer.stop();
        }else if(mood == 1){
            call Leds.led1On();
            //call Leds.led0Off();
            //call Leds.led2Off();
        }else if(mood == 2){
            call Leds.led2On();
            //call Leds.led0Off();
            //call Leds.led1Off();
        }else if (mood == 3){
            call MoodTimer.startPeriodic(1000);
        }

    }

    event void Timer0.fired(){
        call Leds.led0Toggle();
    }
  
    event void Timer1.fired(){
        call Leds.led1Toggle();
    }
  
    event void Timer2.fired(){
        call Leds.led2Toggle();
    }

    event void MoodTimer.fired(){
        call Timer0.startPeriodic( 100 );  
        call Timer1.startPeriodic( 100 );	
        call Timer2.startPeriodic( 100 );
        
    }
      
}
    