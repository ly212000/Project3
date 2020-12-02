configuration ButtonControlAppC {
}
implementation {
    components ButtonControlC;

    components MainC;
    ButtonControlC.Boot -> MainC;

    components UserButtonC;
    ButtonControlC.Get -> UserButtonC;
    ButtonControlC.Notify -> UserButtonC;

    components new TimerMilliC() as Timer0;
    components new TimerMilliC() as Timer1;
    components new TimerMilliC() as Timer2;
    ButtonControlC.Timer0 -> Timer0;
    ButtonControlC.Timer1 -> Timer1;
    ButtonControlC.Timer2 -> Timer2;

    components new TimerMilliC() as MoodTimerC;
    ButtonControlC.MoodTimer -> MoodTimerC;

    components LedsC;
    ButtonControlC.Leds -> LedsC;
 
 
}
