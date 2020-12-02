configuration TempTestAppC{

}
implementation {
    components TempTestC as App;
    components MainC, LedsC;
    components new TimerMilliC();

    App.Boot -> MainC;
    App.Leds -> LedsC;
    App.Timer -> TimerMilliC;

    components SerialPrintfC;
    components new SensirionSht11C() as TempSensor;
    components new HamamatsuS10871TsrC() as LightSensor;
    App.TempRead -> TempSensor.Temperature;
    
    App.LightRead -> LightSensor;

    App.HumidityRead -> TempSensor.Humidity;


}