import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final Function(int) onTileTapped;

  const GameBoard({
    Key? key,
    required this.board,
    required this.onTileTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onTileTapped(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: board[index] == 'X'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
