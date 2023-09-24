import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import '../theme/app_theme.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appThemeData,
      home: GameScreen(),
    );
  }
}