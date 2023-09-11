import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
    setState(() {
      _counter++;
    });
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
      gridSize = (prefs.getString("gridSize") != null ? listOfGrid[prefs.getString("gridSize")] : 5)!;
      stringGridSize = (prefs.getString("gridSize") ?? "5x5")!;
    });
  }

  void setNewDefaultGridSize(value) async {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 80.0, bottom: 120),
              child: Row(
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
            ),
            if (showContinueButton) // Affiche le bouton "Continuer la partie" si showContinueButton est true
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Action à exécuter pour le bouton "Continuer la partie"
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Text(
                    "Continuer la partie",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            Center(
              child: SizedBox(
                width: 300.0, // Définissez la largeur souhaitée
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Centrer horizontalement
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 20), child: Text(
                      "Taille de la grille",
                      style: TextStyle(fontSize: 20,
                          fontFamily: 'Libre', fontStyle: FontStyle.italic),
                    )),
                    DropdownButton<int>(
                      value: gridSize,
                      onChanged: (int? selectedSize) {
                        if (selectedSize != null) {
                          setState(() {
                            gridSize = selectedSize;
                            setNewDefaultGridSize("${selectedSize}x$selectedSize");
                          });
                        }
                      },
                      items: listOfGrid.entries.map((MapEntry<String, int> entry) {
                        return DropdownMenuItem<int>(
                          value: entry.value,
                          child: Text(entry.key),
                        );
                      }).toList(),
                    ),
                    Text("$gridSize")
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _incrementCounter,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                ),
                child: const Text(
                  "▶️ Nouvelle Partie",
                  style: TextStyle(fontSize: 22),
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
        ),
      ),
    );
  }
}
