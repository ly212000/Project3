configuration BaseStationC {
}
implementation {
  components MainC, BaseStationP, LedsC;
  components ActiveMessageC as Radio;

  components new SensirionSht11C() as TempSensor;
  components new SensirionSht11C() as HumiSensor;
  components new TimerMilliC();
  MainC.Boot <- BaseStationP;

  BaseStationP.RadioControl -> Radio;
 
  BaseStationP.RadioSend -> Radio;
  BaseStationP.RadioReceive -> Radio.Receive;
  BaseStationP.RadioSnoop -> Radio.Snoop;
  BaseStationP.RadioPacket -> Radio;
  BaseStationP.RadioAMPacket -> Radio;
  
  BaseStationP.Leds -> LedsC;
  BaseStationP.MilliTimer -> TimerMilliC;
  
  BaseStationP.TempSensor -> TempSensor.Temperature;
  BaseStationP.HumiSensor -> HumiSensor.Humidity;
}
