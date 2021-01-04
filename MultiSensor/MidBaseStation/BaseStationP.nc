#include "AM.h"
#include "RadioSense.h"
module BaseStationP @safe() {
  uses {
    interface Boot;
    interface SplitControl as RadioControl;
    interface AMSend as RadioSend[am_id_t id];
    interface Receive as RadioReceive[am_id_t id];
    interface Receive as RadioSnoop[am_id_t id];
    interface Packet as RadioPacket;
    interface AMPacket as RadioAMPacket;
    interface Timer<TMilli> as MilliTimer;

    interface Read<uint16_t> as HumiSensor;
    interface Read<uint16_t> as TempSensor;
    interface Leds;
  }
}

implementation
{
  enum {
    RADIO_QUEUE_LEN = 12,
    NUM_COMBINE_PACKET = 4,
  };
  message_t  radioQueueBufs[RADIO_QUEUE_LEN];
  message_t  * ONE_NOK radioQueue[RADIO_QUEUE_LEN];
  uint8_t    radioIn, radioOut;
  bool       radioBusy, radioFull;

  message_t packet;
  message_t thisSens;
  uint8_t count = 0;

  uint16_t ID = 0x1111;
  uint16_t Temp;
  uint16_t Humi;

  task void addMsgToQueue();
  task void radioSendTask();

  void dropBlink() {
    call Leds.led2Toggle();
  }

  void failBlink() {
    call Leds.led2Toggle();
  }

  event void Boot.booted() {
    uint8_t i;

    for (i = 0; i < RADIO_QUEUE_LEN; i++)
      radioQueue[i] = &radioQueueBufs[i];
    radioIn = radioOut = 0;
    radioBusy = FALSE;
    radioFull = TRUE;

    if (call RadioControl.start() == EALREADY)
      radioFull = FALSE;
    call MilliTimer.startPeriodic(5000);

  }

  event void RadioControl.startDone(error_t error) {
    if (error == SUCCESS) {
      radioFull = FALSE;
    }
  }

 
  event void RadioControl.stopDone(error_t error) {}

  event void MilliTimer.fired() {

    if ( call TempSensor.read() == SUCCESS
		&& call HumiSensor.read() == SUCCESS)
    {
      call Leds.led1Toggle();
    }
    else 
      call Leds.led2Toggle();
  }

  event void TempSensor.readDone(error_t result, uint16_t val)
  {
    if (result == SUCCESS)
    {
      Temp = val;                  		
    }
    else 
      call Leds.led2On();
  }
	
 

  event void HumiSensor.readDone(error_t result, uint16_t val)
  {
    if (result == SUCCESS)
    {
      Humi = val; 
      post addMsgToQueue(); 
    }
    else 
      call Leds.led2On();
  }

  

  message_t* ONE receive(message_t* ONE msg, void* payload, uint8_t len);
  
  event message_t *RadioSnoop.receive[am_id_t id](message_t *msg,
						    void *payload,
						    uint8_t len) {
    return receive(msg, payload, len);
  }
  
  event message_t *RadioReceive.receive[am_id_t id](message_t *msg,
						    void *payload,
						    uint8_t len) {
    return receive(msg, payload, len);
  }
  
  task void addMsgToQueue(){
    
    radio_sense_msg_t* rsm;

      rsm = (radio_sense_msg_t*)call RadioPacket.getPayload(&thisSens, sizeof(radio_sense_msg_t));
      if (rsm == NULL) {
	return;
      }
      rsm->id = ID;
      rsm->temp = Temp;
      rsm->humi = Humi;
    receive(&thisSens, rsm, sizeof(radio_sense_msg_t));
  }

  message_t* receive(message_t *msg, void *payload, uint8_t len) {
    message_t *ret = msg;
    bool reflectToken = FALSE;

    atomic
      if (!radioFull)
	{
	  reflectToken = TRUE;
	  ret = radioQueue[radioIn];
	  radioQueue[radioIn] = msg;
          count++;
	  if (++radioIn >= RADIO_QUEUE_LEN)
	    radioIn = 0;
	  if (radioIn == radioOut)
	    radioFull = TRUE;

	  if (!radioBusy)
	    {
	      post radioSendTask();
	      radioBusy = TRUE;
	    }
	}
      else
	dropBlink();

    if (reflectToken) {
     
    }
    
    return ret;
  }
  
  task void radioSendTask() {
    uint8_t i;
    message_t* msg;
    radio_combine_msg_t* payload;
    radio_sense_msg_t * rsm[NUM_COMBINE_PACKET];
    atomic
    if (count < 4 || (radioIn == radioOut && !radioFull)){
	  radioBusy = FALSE;
	  return;
	  } 
    for(i = 0; i < NUM_COMBINE_PACKET; i++){
	    uint8_t index = radioOut + i;
	    if (index >= RADIO_QUEUE_LEN) index = index - RADIO_QUEUE_LEN;
	    msg = radioQueue[index];
	    rsm[i] = (radio_sense_msg_t*) call RadioPacket.getPayload(msg,sizeof(radio_sense_msg_t));
    } 	  
    
    payload = (radio_combine_msg_t*)call RadioPacket.getPayload(&packet, sizeof(radio_combine_msg_t));
    if (payload == NULL) {
	    return;
    }
    payload->combine_msg[0] = *rsm[0];
    payload->combine_msg[1] = *rsm[1];
    payload->combine_msg[2] = *rsm[2];
    payload->combine_msg[3] = *rsm[3];
    if (call RadioSend.send[23](0x0002, &packet, sizeof(radio_combine_msg_t)) == SUCCESS)
      call Leds.led0Toggle();
    else{
	    failBlink();
	    post radioSendTask();
    }
  }
  event void RadioSend.sendDone[am_id_t id](message_t* msg, error_t error) {
    if (error != SUCCESS)
      failBlink();
    else
      atomic
	if (&packet == msg)
	  {
	    if (radioOut + NUM_COMBINE_PACKET  >= RADIO_QUEUE_LEN)
	      radioOut = radioOut + NUM_COMBINE_PACKET - RADIO_QUEUE_LEN;
              count -=4;

	    if (radioFull)
	      radioFull = FALSE;
	  }
    
    post radioSendTask();
  }

  
}  
