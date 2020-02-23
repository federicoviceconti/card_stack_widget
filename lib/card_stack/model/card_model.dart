import 'package:flutter/material.dart';

class CardModel {
  final Color shadowColor;
  final Color backgroundColor;
  final double radius;
  final Widget child;

  CardModel({
    this.child,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.radius
  });
}