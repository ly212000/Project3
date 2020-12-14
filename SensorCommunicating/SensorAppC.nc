configuration SensorAppC{

} 

implementation {
    components SensorC as App;
    components MainC; // Boot
    components LedsC; //Led
    components new TimerMilliC();

    App.Boot -> MainC;
    App.Leds -> LedsC;
    App.Timer -> TimerMilliC;

    // Read Light, Temp, Humidity
    components SerialPrintfC;
    components new SensirionSht11C() as TempSensor;
    components new HamamatsuS10871TsrC() as LightSensor;
    App.TempRead -> TempSensor.Temperature;
    App.LightRead -> LightSensor;
    App.HumidityRead -> TempSensor.Humidity;

    components UserButtonC;
    App.Get -> UserButtonC;
    App.Notify -> UserButtonC;

    // Radio Communication
    components ActiveMessageC;
    components new AMSenderC(AM_RADIO);
    components new AMReceiverC(AM_RADIO);
    App.Packet -> AMSenderC;
    App.AMPacket -> AMSenderC;
    App.AMSend -> AMSenderC;
    App.AMControl -> ActiveMessageC;
    App.Receive -> AMReceiverC; 
}