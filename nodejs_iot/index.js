const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");
const readLastLines = require("read-last-lines");
var admin = require("firebase-admin");
var serviceAccount = require("/home/ly/serviceaccount.json"); // Or your config object as above.
const file = "/home/ly/tinyos-main/apps/do_an_he_nhung/BaseStation/output.txt";
const cors = require("cors");
const app = express();

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount), 
  databaseURL: "https://iotsmartagriculture-d8608-default-rtdb.firebaseio.com/",
});

var db = admin.database();
var ref1 = db.ref("Sensor1/");
var ref2 = db.ref("Sensor2/");
var ref3 = db.ref("Sensor3/");
var ref4 = db.ref("Sensor4/");

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

fs.watchFile(file, (curr, prev) => {
  readLastLines.read(file, 1).then((lines) => {
    if (lines.length > 40) {
      //IoT
      //let temperatureHex = lines[30] + lines[31] + lines[33] + lines[34];
      //let humidityHex = lines[36] + lines[37] + lines[39] + lines[40];
      //let visibleLight = lines[42] + lines[43] + lines[45] + lines[46];

      //PRJ
      let id1 = lines[24] + lines[25] + lines[27] + lines[28];
      let temperatureHex1 = lines[30] + lines[31] + lines[33] + lines[34];
      let humidityHex1 = lines[36] + lines[37] + lines[39] + lines[40];
      let T1 = parseInt(temperatureHex1, 16);
      let H1 = parseInt(humidityHex1, 16);
      let temperature1 = parseFloat(-39.6 + 0.01 * T1).toFixed(2);
      let humidityL1 =
        -2.0468 + 0.0367 * H1 - 1.5955 * Math.pow(10, -6) * Math.pow(H1, 2);
      let humidityT1 = parseFloat(
        (temperature1 - 25) * (0.01 + 0.00008 * H1) + humidityL1
      ).toFixed(2);
      ref1.update({
        id: id1,
        humidity: humidityT1,
        temperature: temperature1,
      });

      let id2 = lines[42] + lines[43] + lines[45] + lines[46];
      let temperatureHex2 = lines[48] + lines[49] + lines[51] + lines[52];
      let humidityHex2 = lines[54] + lines[55] + lines[57] + lines[58];
      let T2 = parseInt(temperatureHex2, 16);
      let H2 = parseInt(humidityHex2, 16);
      let temperature2 = parseFloat(-39.6 + 0.01 * T2).toFixed(2);
      let humidityL2 =
        -2.0468 + 0.0367 * H2 - 1.5955 * Math.pow(10, -6) * Math.pow(H2, 2);
      let humidityT2 = parseFloat(
        (temperature2 - 25) * (0.01 + 0.00008 * H2) + humidityL2
      ).toFixed(2);
      ref2.update({
        id: id2,
        humidity: humidityT2,
        temperature: temperature2,
      });

      let id3 = lines[60] + lines[61] + lines[63] + lines[64];
      let temperatureHex3 = lines[66] + lines[67] + lines[69] + lines[70];
      let humidityHex3 = lines[72] + lines[73] + lines[75] + lines[76];
      let T3 = parseInt(temperatureHex3, 16);
      let H3 = parseInt(humidityHex3, 16);
      let temperature3 = parseFloat(-39.6 + 0.01 * T3).toFixed(2);
      let humidityL3 =
        -2.0468 + 0.0367 * H3 - 1.5955 * Math.pow(10, -6) * Math.pow(H3, 2);
      let humidityT3 = parseFloat(
        (temperature3 - 25) * (0.01 + 0.00008 * H3) + humidityL3
      ).toFixed(2);
      ref3.update({
        id: id3,
        humidity: humidityT3,
        temperature: temperature3,
      });

      let id4 = lines[78] + lines[79] + lines[81] + lines[82];
      let temperatureHex4 = lines[84] + lines[85] + lines[87] + lines[88];
      let humidityHex4 = lines[90] + lines[91] + lines[93] + lines[94];
      let T4 = parseInt(temperatureHex4, 16);
      let H4 = parseInt(humidityHex4, 16);
      let temperature4 = parseFloat(-39.6 + 0.01 * T4).toFixed(2);
      let humidityL4 =
        -2.0468 + 0.0367 * H4 - 1.5955 * Math.pow(10, -6) * Math.pow(H4, 2);
      let humidityT4 = parseFloat(
        (temperature4 - 25) * (0.01 + 0.00008 * H4) + humidityL4
      ).toFixed(2);
      ref4.update({
        id: id4,
        humidity: humidityT4,
        temperature: temperature4,
      });

      // let infraredLightHex = lines[48] + lines[49] + lines[51] + lines[52];
      // let T = parseInt(temperatureHex, 16);
      // let H = parseInt(humidityHex, 16);
      // let L = parseInt(visibleLight, 16);
      // let temperature = parseFloat(-39.6 + 0.01 * T).toFixed(2);
      // let humidityL =
      //   -2.0468 + 0.0367 * H - 1.5955 * Math.pow(10, -6) * Math.pow(H, 2);
      // let humidityT = parseFloat(
      //   (temperature - 25) * (0.01 + 0.00008 * H) + humidityL
      // ).toFixed(2);
      // let light = parseFloat(
      //   0.625 * Math.pow(10, 6) * ((L / 4096) * 1.5) * Math.pow(10, -5) * 1000
      // ).toFixed(2);
      //ref.update({
      //   humidity: humidityT,
      //   light: light,
      //   temperature: temperature,
      // });
      // console.log("updated");
      
    }
  });
});
