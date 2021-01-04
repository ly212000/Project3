
#ifndef RADIO_SENSE_H
#define RADIO_SENSE_H

typedef nx_struct radio_sense_msg {
  nx_uint16_t id;
  nx_uint16_t temp;
  nx_uint16_t humi;
} radio_sense_msg_t;

typedef nx_struct radio_combine_msg {
  radio_sense_msg_t combine_msg[4];
} radio_combine_msg_t;

enum {
  AM_RADIO_SENSE_MSG = 7,
};




#endif
