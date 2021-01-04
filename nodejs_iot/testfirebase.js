import React from 'react';
import {StyleSheet, Text, View} from 'react-native';
import * as firebase from 'firebase'
export default class App extends React.Component {
    constructor(props){
        super(props);
        var firebaseConfig = {
            apiKey: "AIzaSyALfMvfZyWB_t1jDlfkgVqvspJtspevYnI",
            authDomain: "iotsmartagriculture-d8608.firebaseapp.com",
            databaseURL: "https://iotsmartagriculture-d8608-default-rtdb.firebaseio.com",
            projectId: "iotsmartagriculture-d8608",
            storageBucket: "iotsmartagriculture-d8608.appspot.com",
            messagingSenderId: "80783742934",
            appId: "1:80783742934:web:fa86be256f4e9ff96c7677",
            measurementId: "G-98W2PF307G"
          };
          // Initialize Firebase
          firebase.initializeApp(firebaseConfig);
          firebase.analytics();
        
    }
}
