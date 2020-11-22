import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:music_groups/ui/app.dart';

void main() {
  if (firebase.apps.isEmpty) {
    firebase.initializeApp(
        apiKey: "AIzaSyAYF_m4iFeSLK1OQbC-hSeo253CKzu-Otc",
        authDomain: "music-groups-9b0cb.firebaseapp.com",
        databaseURL: "https://music-groups-9b0cb.firebaseio.com",
        projectId: "music-groups-9b0cb",
        storageBucket: "music-groups-9b0cb.appspot.com",
        messagingSenderId: "159157977140",
        appId: "1:159157977140:web:fb2f463810ec120eef4a61");
  }
  runApp(MusicGroupsApp());
}
