import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitori/main.dart';
import 'package:path_provider/path_provider.dart';
import '../models/grid.dart';

// ignore: use_key_in_widget_constructors
class GameBoard extends StatefulWidget {
  final int gridSize; // Ajoutez cette variable

  // ignore: use_key_in_widget_constructors
  const GameBoard({required this.gridSize}); // Ajoutez le constructeur

  @override
  // ignore: library_private_types_in_public_api
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late Grid grid;

  @override
  void initState() async {
    super.initState();
    grid = Grid(widget.gridSize, _getJson()); // Ici la taille de la grille.
  }

  Future<String> _initializePath() async {
    print("aled");
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory);
    String _path = directory.path;
    return _path;
  }

  Future<Map<String, dynamic>> _getJson() async {
    String string = await _initializePath();
    final file = File('$string/gameInProgress.json');
    Map<String, dynamic>  jsonData = {'test': 0};

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      print("hola");
      print(jsonString);
      jsonData = json.decode(jsonString);
    }
    return jsonData;
  }

  Future<bool> _turnOnOffButton() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/gameInProgress.json');
    File('$path/gameInProgress.json').writeAsStringSync('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Stopwatch stopwatch = Stopwatch()..start();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: grid.size,
            ),
            itemCount: grid.size * grid.size,
            itemBuilder: (context, index) {
              final row = index ~/ grid.size;
              final col = index % grid.size;
              return grid.cells[row][col];
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      grid.saveToJsonFile();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(
                            title: 'Hitori',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(140, 48),
                    ),

                    child: const Text("Quitter"),
                  )
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      
                      if (grid.isGridValid()) {
                        // La grille est valide, affichez un message de félicitations et le temps mis.
                        final elapsedSeconds = stopwatch.elapsed.inSeconds;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Félicitations !"),
                              content: Text("Vous avez résolu la grille en $elapsedSeconds secondes."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();// Fermez la boîte de dialogue.
                                    _turnOnOffButton();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MyHomePage(
                                          title: 'Hitori',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // La grille n'est pas valide, affichez un message d'erreur.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("La grille n'est pas valide. Veuillez réessayer."),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(140, 48),
                    ),
                    child: const Text("Valider")
                  )),

            ],
          ),
        ]);
  }
}
