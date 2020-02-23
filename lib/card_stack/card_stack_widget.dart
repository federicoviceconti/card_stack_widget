import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card/card_stack/model/dismiss_horientation.dart';

import 'card_widget.dart';
import 'model/card_model.dart';

class CardStackWidget extends StatefulWidget {
  final List<CardModel> cardList;
  final double scaleFactor;
  final double positionFactor;
  final Alignment alignment;
  final bool reverseOrder;
  final DismissOrientation cardDismissOrientation;

  CardStackWidget({
    this.cardList,
    this.scaleFactor,
    this.positionFactor,
    this.alignment,
    this.reverseOrder,
    this.cardDismissOrientation
  });

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
    return Container(
      child: Stack(
          alignment: widget?.alignment ?? Alignment.center, children: cards),
    );
  }

  _buildCard(
      {double calculatedTop,
      double calculatedScale,
      CardModel model,
      bool draggable}) {
    return CardWidget(
      dismissOrientation: widget?.cardDismissOrientation ?? DismissOrientation.both,
      positionTop: calculatedTop,
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

  List<Widget> _buildCards() {
    var lengthCardList = widget.cardList.length;

    var cardListOrdered = !widget.reverseOrder
        ? widget.cardList.reversed.toList(growable: false)
        : widget.cardList;

    var cardWidgetList = cardListOrdered.asMap().entries.map<Widget>((entry) {
      var index = entry.key;
      var model = entry.value;

      var positionCalc = widget.positionFactor * index * 100;

      var scalePercentage = (lengthCardList * widget.scaleFactor / 10);
      var indexPercentage = scalePercentage * (lengthCardList - index - 1);
      var scaleCalc = 1 - indexPercentage;

      return _buildCard(
          calculatedTop: positionCalc,
          calculatedScale: scaleCalc,
          model: model,
          draggable: index == lengthCardList - 1);
    }).toList(growable: false);

    return cardWidgetList;
  }
}
