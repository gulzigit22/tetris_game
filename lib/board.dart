import 'dart:async';
import 'dart:math';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLoength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 800);
    gameloop(frameRate);
  }

  void gameloop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        chekLanding();

        currentPiece.movePiece(Direction.down);
      });
    });
  }

  bool chekCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLoength || col < 0 || col >= rowLength) {
        return true;
      }
    }
    return false;
  }

  void chekLanding() {
    if (chekCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randonType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randonType);
    currentPiece.initializePiece();
  }

  void moveLeft() {
    if (!chekCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void movePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void moveRigth() {
    if (!chekCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 55, 5, 193),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLoength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                      child: index,
                    );
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                        color: tetrominoColors[tetrominoType], child: '');
                  } else {
                    return Pixel(
                      color: Colors.grey[800],
                      child: index,
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: moveLeft,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: movePiece,
                  icon: const Icon(Icons.rotate_left),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: moveRigth,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
