import 'package:app_radiologia/telas/Home.dart';
import 'package:app_radiologia/telas/TelaTermo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final aceiteSave = await SharedPreferences.getInstance();
  bool aceite = await aceiteSave.getBool("aceite");
  runApp(MaterialApp(home: aceite == true ? Home() : TelaTermo()));
}
