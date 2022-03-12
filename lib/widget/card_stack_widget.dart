import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/card_model.dart';
import '../model/swipe_orientation.dart';
import '../widget/card_widget.dart';

class CardStackWidget extends StatefulWidget {
  /// List of card shown
  final List<CardModel> cardList;

  /// Scale factor for items into the list
  final double? scaleFactor;

  /// Distance factor between items
  final double? positionFactor;

  /// Cards alignment
  final Alignment? alignment;

  /// Should show list in reverse order
  final bool reverseOrder;

  /// Direction where the card could be dismissed and removed from the list
  final SwipeOrientation? cardDismissOrientation;

  /// Drag direction enabled
  final SwipeOrientation? swipeOrientation;

  /// Change card opacity on drag (by default is disabled)
  final bool opacityChangeOnDrag;

  const CardStackWidget({
    Key? key,
    required this.cardList,
    this.scaleFactor,
    this.positionFactor,
    this.alignment,
    this.reverseOrder = false,
    this.cardDismissOrientation,
    this.swipeOrientation,
    this.opacityChangeOnDrag = false
  }) : super(key: key);

  @override
  _CardStackWidgetState createState() => _CardStackWidgetState();
}

class _CardStackWidgetState extends State<CardStackWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildCardStack();
  }

  Widget _buildCardStack() {
    var cards = _buildCards();
    return Stack(
      alignment: widget.alignment ?? Alignment.center,
      children: cards,
    );
  }

  List<Widget> _buildCards() {
    var lengthCardList = widget.cardList.length;

    var cardListOrdered = !widget.reverseOrder
        ? widget.cardList.reversed.toList(growable: false)
        : widget.cardList;

    var cardWidgetList = cardListOrdered.asMap().entries.map<Widget>((entry) {
      var index = entry.key;
      var model = entry.value;

      var positionCalc = widget.positionFactor! * index * 10;
      var scalePercentage = lengthCardList * widget.scaleFactor! / 100;
      var indexPercentage = scalePercentage * (lengthCardList - index - 1);
      var scaleCalc = 1 - indexPercentage;

      return _buildCard(
        calculatedTop: positionCalc,
        calculatedScale: scaleCalc,
        model: model,
        draggable: index == lengthCardList - 1,
      );
    }).toList(growable: false);

    return cardWidgetList;
  }

  Widget _buildCard({
    required double calculatedTop,
    double? calculatedScale,
    CardModel? model,
    bool? draggable,
  }) {
    return CardWidget(
      opacityChangeOnDrag: widget.opacityChangeOnDrag,
      positionTop: calculatedTop,
      swipeOrientation: widget.swipeOrientation ?? SwipeOrientation.both,
      dismissOrientation:
          widget.cardDismissOrientation ?? SwipeOrientation.both,
      scale: calculatedScale,
      model: model,
      draggable: draggable,
      onCardDragEnd: () {
        var model = widget.cardList.removeAt(widget.cardList.length - 1);
        setState(() {
          widget.cardList.insert(0, model);
        });
      },
    );
  }
}
