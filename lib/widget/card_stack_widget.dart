import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/card_model.dart';
import '../model/card_orientation.dart';
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
  /// By default is [CardOrientation.both]
  final CardOrientation? cardDismissOrientation;

  /// Drag direction enabled. By default is [CardOrientation.both]
  final CardOrientation? swipeOrientation;

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
    this.opacityChangeOnDrag = false,
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
    final lengthCardList = widget.cardList.length;

    final cardListOrdered = !widget.reverseOrder
        ? widget.cardList.reversed.toList(growable: false)
        : widget.cardList;

    final cards = <Widget>[];

    for (int currentIndex = 0; currentIndex < lengthCardList; currentIndex++) {
      var positionCalc = widget.positionFactor! * currentIndex * 10;
      var scalePercentage = lengthCardList * widget.scaleFactor! / 100;
      var indexPercentage =
          scalePercentage * (lengthCardList - currentIndex - 1);
      var scaleCalc = 1 - indexPercentage;

      cards.add(_buildCard(
        model: cardListOrdered[currentIndex],
        calculatedTop: positionCalc,
        calculatedScale: scaleCalc,
        draggable: currentIndex == lengthCardList - 1,
      ));
    }

    return cards;
  }

  Widget _buildCard({
    required double calculatedTop,
    required CardModel model,
    double? calculatedScale,
    bool? draggable,
  }) {
    return CardWidget(
      opacityChangeOnDrag: widget.opacityChangeOnDrag,
      positionTop: calculatedTop,
      swipeOrientation: widget.swipeOrientation ?? CardOrientation.both,
      dismissOrientation: widget.cardDismissOrientation ?? CardOrientation.both,
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
