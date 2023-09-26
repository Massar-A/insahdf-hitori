import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Hitori Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = "Hitori";
  static const Map<String, int> listOfGrid = {
    "5x5": 5,
    "6x6": 6,
    "7x7": 7,
    "8x8": 8,
    "9x9": 9,
    "10x10": 10,
    "11x11": 11,
    "12x12": 12
  };
  bool showContinueButton = false;

  int gridSize = 5;
  String stringGridSize = "5x5";

  void _incrementCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(gridSize: gridSize),
      ),
    );
  }

  void _continueGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameScreen(gridSize: 0),
      ),
    );
  }

  void _showContinueButton() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    if (File('$path/gameInProgress.json').existsSync()) {
      if (await File('$path/gameInProgress.json').length() > 1) {
        print("wsh");
        print(await File('$path/gameInProgress.json').readAsString());
        setState(() {
          showContinueButton = true;
        });
      } else {
        setState(() {
          showContinueButton = false;
        });
      }
    } else {
      await File('$path/gameInProgress.json').create();
      setState(() {
        showContinueButton = false;
      });
    }
  }

  void _turnOnOffButton() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/gameInProgress.json');
    print(await file.readAsString());
    File('$path/gameInProgress.json').writeAsStringSync('');
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
    _showContinueButton();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      gridSize = (prefs.getString("gridSize") != null
          ? listOfGrid[prefs.getString("gridSize")]
          : 5)!;
      stringGridSize = prefs.getString("gridSize") ?? "5x5";
    });
  }

  void _setNewDefaultGridSize(value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("gridSize", value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 80, bottom: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hitori",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Libre',
                            fontSize: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: showContinueButton,
                  // Affiche le bouton "Continuer la partie" si showContinueButton est true
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        _continueGame();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 48),
                      ),
                      child: const Text(
                        "Continuer la partie",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !showContinueButton,
                  // Affiche le bouton "Continuer la partie" si showContinueButton est true
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 48,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 350, // Définissez la largeur souhaitée
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Centrer horizontalement
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: _incrementCounter,
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 48),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.play_arrow_rounded),
                                Text(
                                  "Nouvelle Partie",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DropdownButton<int>(
                          value: gridSize,
                          onChanged: (int? selectedSize) {
                            if (selectedSize != null) {
                              setState(() {
                                gridSize = selectedSize;
                                _setNewDefaultGridSize(
                                    "${selectedSize}x$selectedSize");
                              });
                            }
                          },
                          items: listOfGrid.entries
                              .map((MapEntry<String, int> entry) {
                            return DropdownMenuItem<int>(
                              value: entry.value,
                              child: Text(entry.key),
                            );
                          }).toList(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
