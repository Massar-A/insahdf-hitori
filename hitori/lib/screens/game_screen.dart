import 'package:flutter/material.dart';
import '../screens/game_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jeu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75, // On donne une hauteur pour contenir le GridView
              child: GameBoard(),
            ),
            // Ajoutez d'autres widgets pour les contrôles du jeu ici.
          ],
        ),
      ),
    );
  }
}
