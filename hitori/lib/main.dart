import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/game_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  int _counter = 0;
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
  bool showContinueButton = true;

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


  void _turnOnOffButton() {
    setState(() {
      showContinueButton = !showContinueButton;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
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
                        // Action à exécuter pour le bouton "Continuer la partie"
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _turnOnOffButton,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 50),
                    ),
                    child: const Text(
                      "Allumer/Éteindre bouton continuer",
                      style: TextStyle(fontSize: 25),
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