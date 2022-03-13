import 'package:card_stack_widget/card_stack_widget.dart';
import 'package:flutter/material.dart';

/// This class is used by the [CardStackWidget] for the
/// [CardStackWidget.cardList] attribute.
class CardModel {
  final Key? key;

  /// Shadow applied to the card
  final Color shadowColor;

  /// Color applied to the background of the card
  final Color backgroundColor;

  /// Radius applied to the card
  final Radius radius;

  /// Widget inside the card
  final Widget? child;

  CardModel({
    this.key,
    this.child,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.radius = Radius.zero,
  });

  @override
  String toString() {
    return 'CardModel{key: $key}';
  }
}
