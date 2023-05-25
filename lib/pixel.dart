import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Pixel extends StatelessWidget {
  Pixel({super.key, required this.color, required this.child});
  final color;
  final child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.all(1),
      child: Center(
        child: Text(
          child.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
