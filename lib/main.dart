import 'package:flutter/material.dart';
import 'package:image_puzzle/screens/home.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();


  await Environments.initialize();
  await DatabaseHelper.init();
  await AdMobPlugin.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(top: false, child: PuzzleMenu()),
      theme: ThemeData(colorSchemeSeed: Colors.cyan, brightness: .dark),
    );
  }
}
