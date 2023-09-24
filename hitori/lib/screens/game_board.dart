import 'package:flutter/material.dart';
import '../models/grid.dart';
import '../widgets/grid_tile.dart';

// ignore: use_key_in_widget_constructors
class GameBoard extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late Grid grid;

  @override
  void initState() {
    super.initState();
    grid = Grid(5); // Ici la taille de la grille.
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}