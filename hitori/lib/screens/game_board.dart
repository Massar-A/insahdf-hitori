import 'package:flutter/material.dart';
import '../models/grid.dart';
import '../widgets/grid_tile.dart';

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
  void initState() {
    super.initState();
    grid = Grid(widget.gridSize); // Ici la taille de la grille.
  }

  @override
  Widget build(BuildContext context) {
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
              return GridTileWidget(
                row: row,
                col: col,
                value: grid.cells[row][col].value,
                isBlack: grid.cells[row][col].isBlack
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                onPressed: () {
                  // Ajoutez ici le code pour sauvegarder la partie en cours.
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(140, 48),
                ),
                child: Text("Quitter"),
              )
            ),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                onPressed: () {
                  // Ajoutez ici le code pour sauvegarder la partie en cours.
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(140, 48),
                ),
                child: Text("Valider"),
              )
            ),
          ],
        )
      ]
    );
  }
}
