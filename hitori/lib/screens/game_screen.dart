import 'package:flutter/material.dart';
import '../screens/game_board.dart';

class GameScreen extends StatefulWidget {
  final int gridSize;

  // ignore: use_key_in_widget_constructors
  const GameScreen({required this.gridSize});

  @override
  // ignore: library_private_types_in_public_api
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jeu'),
          automaticallyImplyLeading: false,
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  // On donne une hauteur pour contenir le GridView
                  child: GameBoard(
                    gridSize: widget.gridSize,
                  ),
                ),
                // Ajoutez d'autres widgets pour les contrôles du jeu ici.
              ],
            ),
          ),
        ));
  }
}
