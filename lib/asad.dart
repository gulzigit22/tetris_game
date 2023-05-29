// import 'package:flutter/material.dart';
// import 'dart:math';

// void main() {
//   runApp(TetrisApp());
// }

// class TetrisApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tetris',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TetrisScreen(),
//     );
//   }
// }

// class TetrisScreen extends StatefulWidget {
//   @override
//   _TetrisScreenState createState() => _TetrisScreenState();
// }

// class _TetrisScreenState extends State<TetrisScreen> {
//   final int rows = 20;
//   final int columns = 10;
//   List<List<Color>> grid;
//   List<Point<int>> currentShape;
//   Point<int> currentShapePosition;
//   List<List<Color>> tetrominoes;

//   @override
//   void initState() {
//     super.initState();
//     initializeGame();
//   }

//   void initializeGame() {
//     grid = List.generate(rows, (_) => List.filled(columns, Colors.grey));
//     currentShapePosition = Point(columns ~/ 2, 0);
//     tetrominoes = [
//       [Colors.blue, Colors.blue, Colors.blue, Colors.blue],
//       [Colors.yellow, Colors.yellow, Colors.yellow, Colors.yellow],
//       [Colors.green, Colors.green, Colors.green, Colors.green],
//       [Colors.red, Colors.red, Colors.red, Colors.red],
//       [Colors.orange, Colors.orange, Colors.orange, Colors.orange],
//       [Colors.purple, Colors.purple, Colors.purple, Colors.purple],
//       [Colors.teal, Colors.teal, Colors.teal, Colors.teal],
//     ];
//     generateShape();
//   }

//   void generateShape() {
//     final random = Random();
//     final shapeIndex = random.nextInt(tetrominoes.length);
//     currentShape = tetrominoes[shapeIndex];
//   }

//   bool isValidMove() {
//     for (var i = 0; i < currentShape.length; i++) {
//       final row = currentShape[i].y + currentShapePosition.y;
//       final col = currentShape[i].x + currentShapePosition.x;
//       if (row < 0 || row >= rows || col < 0 || col >= columns) {
//         return false;
//       }
//       if (grid[row][col] != Colors.grey) {
//         return false;
//       }
//     }
//     return true;
//   }

//   void placeShape() {
//     for (var i = 0; i < currentShape.length; i++) {
//       final row = currentShape[i].y + currentShapePosition.y;
//       final col = currentShape[i].x + currentShapePosition.x;
//       grid[row][col] = currentShape[i];
//     }
//     checkLines();
//     generateShape();
//     currentShapePosition = Point(columns ~/ 2, 0);
//     if (!isValidMove()) {
//       gameOver();
//     }
//   }

//   void checkLines() {
//     for (var row = rows - 1; row >= 0; row--) {
//       var lineFilled = true;
//       for (var col = 0; col < columns; col++) {
//         if (grid[row][col] == Colors.grey) {
//           lineFilled = false;
//           break;
//         }
//       }
//       if (lineFilled) {
//         clearLine(row);
//         shiftLines(row);
//       }
//     }
//   }

//   void clearLine(int row) {
//     for (var col = 0; col < columns; col++) {
//       grid[row][col] = Colors.grey;
//     }
//   }

//   void shiftLines(int row) {
//     for (var i = row - 1; i >= 0; i--) {
//       for (var col = 0; col < columns; col++) {
//         grid[i + 1][col] = grid[i][col];
//       }
//     }
//   }

//   void gameOver() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Game Over'),
//         content: Text('You lost!'),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Play Again'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               initializeGame();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tetris'),
//       ),
//       body: GestureDetector(
//         onHorizontalDragEnd: (DragEndDetails details) {
//           if (details.primaryVelocity > 0) {
//             moveRight();
//           } else if (details.primaryVelocity < 0) {
//             moveLeft();
//           }
//         },
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: GridView.builder(
//                 padding: EdgeInsets.all(8),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: columns,
//                   childAspectRatio: 1.0,
//                   crossAxisSpacing: 4,
//                   mainAxisSpacing: 4,
//                 ),
//                 itemCount: rows * columns,
//                 itemBuilder: (BuildContext context, int index) {
//                   final row = index ~/ columns;
//                   final col = index % columns;
//                   final color = grid[row][col];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: color,
//                       border: Border.all(color: Colors.grey),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             RaisedButton(
//               child: Text('Rotate'),
//               onPressed: rotateShape,
//             ),
//             RaisedButton(
//               child: Text('Move Left'),
//               onPressed: moveLeft,
//             ),
//             RaisedButton(
//               child: Text('Move Right'),
//               onPressed: moveRight,
//             ),
//             RaisedButton(
//               child: Text('Move Down'),
//               onPressed: moveDown,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void rotateShape() {
//     setState(() {
//       final List<Point<int>> rotatedShape = List.generate(
//         currentShape.length,
//         (i) => Point(currentShape[i].y, -currentShape[i].x),
//       );
//       final oldShape = currentShape;
//       currentShape = rotatedShape;
//       if (!isValidMove()) {
//         currentShape = oldShape;
//       }
//     });
//   }

//   void moveLeft() {
//     setState(() {
//       currentShapePosition = Point(
//         currentShapePosition.x - 1,
//         currentShapePosition.y,
//       );
//       if (!isValidMove()) {
//         currentShapePosition = Point(
//           currentShapePosition.x + 1,
//           currentShapePosition.y,
//         );
//       }
//     });
//   }

//   void moveRight() {
//     setState(() {
//       currentShapePosition = Point(
//         currentShapePosition.x + 1,
//         currentShapePosition.y,
//       );
//       if (!isValidMove()) {
//         currentShapePosition = Point(
//           currentShapePosition.x - 1,
//           currentShapePosition.y,
//         );
//       }
//     });
//   }

//   void moveDown() {
//     setState(() {
//       currentShapePosition = Point(
//         currentShapePosition.x,
//         currentShapePosition.y + 1,
//       );
//       if (!isValidMove()) {
//         currentShapePosition = Point(
//           currentShapePosition.x,
//           currentShapePosition.y - 1,
//         );
//         placeShape();
//       }
//     });
//   }
// }
