import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/card_model.dart';
import '../model/card_orientation.dart';
import '../widget/card_widget.dart';

/// This class has the aim to show a stack of cards based on [cardList].
///
/// For example, we have three cards (A, B, C), and [reverseOrder] is set to
/// false. They will be shown like:
///                _______
///         ______|   C  |
///  ______|   B  |      |
/// |   A  |      |______|
/// |      |______|
/// |______|
class CardStackWidget extends StatefulWidget {
  /// Default value for [positionFactor]
  static const double positionFactorDefault = 1.0;

  /// Default value for [scaleFactor]
  static const double scaleFactorDefault = 1.0;

  /// List of card shown
  final List<CardModel> cardList;

  /// Scale factor for items into the list
  final double scaleFactor;

  /// Distance factor between items
  final double positionFactor;

  /// Cards alignment
  final Alignment? alignment;

  /// Should show list in reverse order. By default is `false`.
  final bool reverseOrder;

  /// Direction where the card could be dismissed and removed from the list
  /// By default is [CardOrientation.both]
  final CardOrientation cardDismissOrientation;

  /// Drag direction enabled. By default is [CardOrientation.both]
  final CardOrientation swipeOrientation;

  /// Change card opacity on drag (by default is disabled)
  final bool opacityChangeOnDrag;

  /// If not null, the function will be invoked on the tap of the card.
  final Function(CardModel)? onCardTap;

  const CardStackWidget({
    Key? key,
    required this.cardList,
    this.alignment,
    double? positionFactor,
    double? scaleFactor,
    this.reverseOrder = false,
    CardOrientation? cardDismissOrientation,
    CardOrientation? swipeOrientation,
    this.onCardTap,
    this.opacityChangeOnDrag = false,
  })  : scaleFactor = scaleFactor ?? scaleFactorDefault,
        positionFactor = positionFactor ?? positionFactorDefault,
        cardDismissOrientation = cardDismissOrientation ?? CardOrientation.both,
        swipeOrientation = swipeOrientation ?? CardOrientation.both,
        super(key: key);

  @override
  _CardStackWidgetState createState() => _CardStackWidgetState();
}

class _CardStackWidgetState extends State<CardStackWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildCardStack();
  }

  Widget _buildCardStack() {
    return Stack(
      alignment: widget.alignment ?? Alignment.center,
      children: _buildCards(),
    );
  }

  /// Return a list of widget with type of [CardWidget]
  List<CardWidget> _buildCards() {
    final lengthCardList = widget.cardList.length;

    final cardListOrdered = widget.reverseOrder
        ? widget.cardList.reversed.toList(growable: false)
        : widget.cardList;

    final cards = <CardWidget>[];

    for (int currentIndex = 0; currentIndex < lengthCardList; currentIndex++) {
      var positionCalc = widget.positionFactor * currentIndex * 10;
      var scalePercentage = lengthCardList * widget.scaleFactor / 100;
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

  /// Return a widget of type [CardWidget]
  CardWidget _buildCard({
    required double calculatedTop,
    required CardModel model,
    required bool draggable,
    double? calculatedScale,
  }) {
    return CardWidget(
      opacityChangeOnDrag: widget.opacityChangeOnDrag,
      positionTop: calculatedTop,
      swipeOrientation: widget.swipeOrientation,
      dismissOrientation: widget.cardDismissOrientation,
      scale: calculatedScale,
      model: model,
      draggable: draggable,
      onCardTap: widget.onCardTap,
      onCardDragEnd: () {
        var model = widget.cardList.removeAt(widget.cardList.length - 1);
        setState(() {
          widget.cardList.insert(0, model);
        });
      },
    );
  }
}
