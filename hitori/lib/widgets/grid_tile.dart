import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GridTileWidget extends StatefulWidget {
  final int row;
  final int col;
  bool isBlack;
  int value;

  // ignore: use_key_in_widget_constructors
  GridTileWidget({
    required this.row,
    required this.col,
    this.isBlack = false,
    required this.value,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GridTileWidgetState createState() => _GridTileWidgetState();
}

class _GridTileWidgetState extends State<GridTileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isBlack = !widget.isBlack;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: widget.isBlack ? const Color.fromARGB(255, 43, 43, 43) : const Color.fromARGB(255, 161, 161, 161),
        ),
        child: Center(
          child: Text(
            widget.value.toString(),
            style: TextStyle(
              color: widget.isBlack ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
