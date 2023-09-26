import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

import '../widgets/grid_tile.dart';

class Grid {
  final int size;
  late List<List<GridTileWidget>> cells;

  Grid(this.size) {
    cells = generateHitoriGrid();
  }

  Map<String, dynamic> toJson() {
    List<List<Map<String, dynamic>>> gridJson = cells.map((row) {
      return row.map((cell) {
        return {
          'value': cell.value,
          'isBlack': cell.isBlack,
        };
      }).toList();
    }).toList();

    Map<String, dynamic> jsonMap = {
    'time': 0,// chronomètre, vous devez définir la valeur du chronomètre ici,
    'grid': gridJson,
  };
    print(jsonMap);
    return jsonMap;
  }
  Future<File> get _localFile async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    if(await File('$path/gameInProgress.json').exists()){
      return File('$path/gameInProgress.json');
    } else {
      return File('$path/gameInProgress.json').create();
    }
  }
  Future<File> saveToJsonFile() async {
    final jsonData = toJson();
    final jsonString = jsonEncode(jsonData);

    var file = await _localFile;// Remplacez 'your_file.json' par le chemin de votre fichier JSON.
    if(await file.length() > 1){
      file.delete();
      file = await _localFile;
    }
    
    return file.writeAsString(jsonString);
  }



  List<List<GridTileWidget>> generateHitoriGrid() {
    // Créer une grille vide avec des cases blanches.
    List<List<GridTileWidget>> grid = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => GridTileWidget(
          row: i,
          col: j,
          isBlack: false,
          value: 0, // Valeur initiale (0 pour une case blanche).
        ),
      ),
    );

    // Placer des cases noires aléatoirement dans la grille.
    placeRandomBlackCells(grid);

    // Remplir les valeurs initiales conformément aux règles de Hitori.
    fillNonBlackCells(grid);

    fillBlackTilesWithRandomValues(grid);

    return grid;
  }

  void placeRandomBlackCells(List<List<GridTileWidget>> grid) {
    final int numberOfBlackCells = (17*(size*size)/100).floor();

    Random random = Random();
    List<List<GridTileWidget>> temp;

    do {
      // Copie de la grille initiale.
      temp = List.generate(size, (i) => List.generate(size, (j) => GridTileWidget(
        row: i,
        col: j,
        isBlack: false,
        value: grid[i][j].value,
      )));

      int placedBlackCells = 0;
      while (placedBlackCells < numberOfBlackCells) {
        int i = random.nextInt(size);
        int j = random.nextInt(size);
        
        if (!temp[i][j].isBlack) {
          temp[i][j].isBlack = true;
          placedBlackCells++;
        }
      }
    } while (isGridDivided(temp) || isBlackTileAdjacent(temp));

    // Placez les cases noires sur la grille d'origine.
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        grid[i][j].isBlack = temp[i][j].isBlack;
      }
    }
  }


  // On remplie les cases non noires avec des valeures comprises entre 1 et la taille de la grille
  void fillNonBlackCells(List<List<GridTileWidget>> grid) {
    final int size = grid.length;
    // problème similaire au problème des N-Reines.
    _backtrackFill(grid, 0, 0, size);
  }

  bool _backtrackFill(List<List<GridTileWidget>> grid, int row, int col, int size) {
    if (row == size) {
      return true; // Toutes les cases non noires ont été remplies avec succès.
    }

    if (!grid[row][col].isBlack) {
      List<int> availableValues = List.generate(size, (index) => index + 1);
      availableValues.shuffle(); // Mélangez les valeurs possibles.

      for (int value in availableValues) {
        if (!_isValueInRow(grid, row, value) && !_isValueInColumn(grid, col, value)) {
          grid[row][col].value = value;

          int nextRow = row;
          int nextCol = col + 1;
          if (nextCol == size) {
            nextRow++;
            nextCol = 0;
          }

          if (_backtrackFill(grid, nextRow, nextCol, size)) {
            return true; // La valeur a été attribuée avec succès, continuer avec la prochaine case.
          }

          // Si la valeur ne convient pas, réinitialisez la case.
          grid[row][col].value = 0;
        }
      }
    } else {
      // Case noire, passez à la prochaine case.
      int nextRow = row;
      int nextCol = col + 1;
      if (nextCol == size) {
        nextRow++;
        nextCol = 0;
      }
      return _backtrackFill(grid, nextRow, nextCol, size);
    }

    return false; // Aucune valeur possible n'a fonctionné pour cette case.
  }

  // On vérifie si la valeur est présente sur la ligne
  bool _isValueInRow(List<List<GridTileWidget>> grid, int row, int value) {
    return grid[row].any((tile) => tile.value == value);
  }

  // On vérifie si la valeur est présente sur la colonne
  bool _isValueInColumn(List<List<GridTileWidget>> grid, int col, int value) {
    return grid.any((row) => row[col].value == value);
  }

  // Remplir les cases noires par des valeurs aléatoires
  void fillBlackTilesWithRandomValues(List<List<GridTileWidget>> grid) {
    final int size = grid.length;
    final Random random = Random();

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (grid[i][j].isBlack) {
          grid[i][j].value = random.nextInt(size) + 1;
        }
      }
    }
  }


  //TODO Méthode pour vérifier si la grille est valide selon les règles du jeu Hitori
  bool _isValidGrid(List<List<GridTileWidget>> grid) {
  final int size = grid.length;

  // Vérifiez chaque ligne et colonne pour les doublons.
  for (int i = 0; i < size; i++) {
    Set<int> rowSet = {};
    Set<int> colSet = {};
    
    for (int j = 0; j < size; j++) {
      int rowValue = grid[i][j].value;
      int colValue = grid[j][i].value;

      if (rowValue != 0) {
        if (rowSet.contains(rowValue)) {
          return false; // Doublon dans la ligne.
        }
        rowSet.add(rowValue);
      }

      if (colValue != 0) {
        if (colSet.contains(colValue)) {
          return false; // Doublon dans la colonne.
        }
        colSet.add(colValue);
      }
    }
  }

  // Vérifiez les cases noires.
  if (isBlackTileAdjacent(grid)) {
    return false;
  }

  // Vérifiez que les cases noires ne divisent pas la grille en deux zones distinctes.
  if (!isGridDivided(grid)) {
    return false;
  }

  return true;
}

bool isBlackTileAdjacent(List<List<GridTileWidget>> grid) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (grid[i][j].isBlack) {
        // Vérifiez si la case noire ne touche pas une autre case noire.
        if (i > 0 && grid[i - 1][j].isBlack) {
          return true; // Case noire adjacente verticalement.
        }
        if (i < size - 1 && grid[i + 1][j].isBlack) {
          return true; // Case noire adjacente verticalement.
        }
        if (j > 0 && grid[i][j - 1].isBlack) {
          return true; // Case noire adjacente horizontalement.
        }
        if (j < size - 1 && grid[i][j + 1].isBlack) {
          return true; // Case noire adjacente horizontalement.
        }
      }
    }
  }
  return false;
}

bool isGridDivided(List<List<GridTileWidget>> grid) {
  final int size = grid.length;
  bool start = false;
  List<List<bool>> visited = List.generate(size, (_) => List.generate(size, (_) => false));

  // Recherche de la première case non noire.
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (!grid[i][j].isBlack && !visited[i][j] && !start) {
        // Démarrez la recherche en profondeur à partir de cette case.
        _dfs(grid, visited, i, j);
        start = true;
      }
    }
  }

  // Vérifiez si toutes les cases non noires ont été visitées.
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (!grid[i][j].isBlack && !visited[i][j]) {
        return true; // Toutes les cases non noires ne sont pas visitées, la grille est divisée.
      }
    }
  }

  return false; // Toutes les cases non noires ont été visitées, la grille n'est pas divisée.
}

void _dfs(List<List<GridTileWidget>> grid, List<List<bool>> visited, int row, int col) {
  if (row < 0 || row >= grid.length || col < 0 || col >= grid[0].length || visited[row][col] || grid[row][col].isBlack) {
    return; // Cas de base de l'arrêt de la recherche.
  }
  
  visited[row][col] = true;

  // Parcours en profondeur vers les cases adjacentes.
  _dfs(grid, visited, row - 1, col);
  _dfs(grid, visited, row + 1, col);
  _dfs(grid, visited, row, col - 1);
  _dfs(grid, visited, row, col + 1);
}

  // Vérifier si la grille est résolue
  bool isGridSolved() {
    // Implémentez votre logique de résolution ici
    // Comparez la grille avec les règles du jeu Hitori.
    // Renvoyez true si la grille est résolue, sinon false.
    return false;
  }


}
