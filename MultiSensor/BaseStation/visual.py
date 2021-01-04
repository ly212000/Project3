import numpy as np
import pandas as pd

def tempTo(a):
    b = float(-39.6 + 0.01*a)
    return round(b, 2)
def humiTo(a):
    b = float(-2.0468 + 0.0367*a-1.5955*(10**(-6))*(a**2))
    return round(b, 2)

f = open('output.txt','r')
col_names = ['type_packet','destination_address','source_address'
            , 'len_payload', 'id_group', 'note_id1', 'temp1' ,'humi1'
            , 'note_id2', 'temp2' ,'humi2', 'note_id3', 'temp3' 
            , 'humi3', 'note_id4', 'temp4' ,'humi4']

df = pd.DataFrame([0 for i in range(len(col_names))], columns = col_names)

while True:
    data=f.readline()
    if data == ['']:
        break
    data = data.split(" ")
    try:
        data.remove('\n')
    except:
        continue
    type_msg = data[0]
    destination_add = data[1]+data[2]
    source_add = data[3]+data[4]
    len_payload = data[5]
    id_group = data[6]

    id_note1 = data[8]+data[9]
    temp1 = int(data[10]+data[11],16)
    temp1 = tempTo(temp1)
    humi1 = int(data[12]+data[13],16)
    humi1 = humiTo(humi1)

    id_note2 = data[14]+data[15]
    temp2 = int(data[16]+data[17],16)
    temp2 = tempTo(temp2)
    humi2 = int(data[18]+data[19],16)
    humi2 = humiTo(humi2)

    id_note3 = data[20]+data[21]
    temp3 = int(data[22]+data[23],16)
    temp3 = tempTo(temp3)
    humi3 = int(data[24]+data[25],16)
    humi3 = humiTo(humi3)

    id_note4 = data[26]+data[27]
    temp4 = int(data[28]+data[29],16)
    temp4 = tempTo(temp4)
    humi4 = int(data[30]+data[31],16)
    humi4 = humiTo(humi4)

    data1 = [type_msg, destination_add, source_add, len_payload, id_group, id_note1, temp1,
                        humi1, id_note2, temp2, humi2, id_note3, temp3, humi3, id_note4, temp1, humi4]
    df1 = pd.DataFrame(data1, columns = col_names)
    df = df.append(df1, ignore_index = True)

print(df)


