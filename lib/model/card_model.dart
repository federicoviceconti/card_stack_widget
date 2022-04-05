import 'package:card_stack_widget/card_stack_widget.dart';
import 'package:flutter/material.dart';

/// This class is used by the [CardStackWidget] for the
/// [CardStackWidget.cardList] attribute.
class CardModel {
  final Key? key;

  /// Color of the shadow applied to the card decoration
  final Color shadowColor;

  /// Color applied to the background
  final Color backgroundColor;

  /// Radius applied to the border
  final Radius radius;

  /// Border applied to the child's container decoration
  final BoxBorder? border;

  /// Widget rendered into the stack
  final Widget? child;

  /// Padding applied to the child's container
  final EdgeInsets? padding;

  /// Margin applied to the child's container
  final EdgeInsets? margin;

  /// Gradient applied to the child's container decoration
  final Gradient? gradient;

  /// Image for decoration applied to the child's container
  final DecorationImage? imageDecoration;

  /// Radius applied to the shadow decoration
  final double shadowBlurRadius;

  CardModel({
    this.key,
    this.child,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.radius = Radius.zero,
    this.border,
    this.padding,
    this.margin,
    this.gradient,
    this.imageDecoration,
    this.shadowBlurRadius = 2.0,
  });

  @override
  String toString() {
    return 'CardModel{key: $key}';
  }
}
