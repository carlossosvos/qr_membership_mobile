import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/services/firebase_options.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
