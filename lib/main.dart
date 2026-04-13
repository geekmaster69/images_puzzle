import 'package:flutter/material.dart';
import 'package:image_puzzle/screens/home.dart';

import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      debugShowCheckedModeBanner: false,
      home: PuzzleMenu(),
      theme: ThemeData(colorSchemeSeed: Colors.cyan, brightness: .dark),
    );
  }
}
