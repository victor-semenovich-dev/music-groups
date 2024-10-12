import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_groups/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MusicGroupsApp());
}
