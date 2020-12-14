#ifndef SENSOR_H
#define SENSOR_H

typedef nx_struct SensorMsg{
    nx_uint16_t NodeId;
    nx_uint8_t Data[3];
}SensorMsg_t;

enum{
    AM_RADIO = 6
};
#endif /* SENSOR_H */