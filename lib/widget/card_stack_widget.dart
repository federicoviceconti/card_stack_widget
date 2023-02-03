import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/card_model.dart';
import '../model/card_orientation.dart';
import '../widget/card_widget.dart';

typedef CardStackWidgetBuilder = CardModel Function(int index);

/// This class has the aim to show a stack of cards based on [cardList].
///      ______
///     |  C  |
///    _|_____|_        <- For example, we have three cards (A, B, C)
///   |    B   |        <- and [reverseOrder] is set to false
///  _|________|_
/// |     A     |
/// |___________|
class CardStackWidget extends StatefulWidget {
  /// Default value for [positionFactor].
  static const double positionFactorDefault = 1.0;

  /// Default value for [scaleFactor].
  static const double scaleFactorDefault = 1.0;

  /// List of card shown.
  final List<CardModel> cardList;

  /// Scale factor for items into the list.
  final double scaleFactor;

  /// Distance factor between items.
  final double positionFactor;

  /// Cards alignment. Default it's [Alignment.center].
  final Alignment? alignment;

  /// Should show list in reverse order. By default is `false`.
  final bool reverseOrder;

  /// Direction where the card could be dismissed and removed from the list
  /// By default is [CardOrientation.both].
  final CardOrientation cardDismissOrientation;

  /// Drag direction enabled. By default is [CardOrientation.both].
  final CardOrientation swipeOrientation;

  /// Change card opacity on drag (by default is disabled).
  final bool opacityChangeOnDrag;

  /// If not null, the function will be invoked on the tap of the card.
  final Function(CardModel)? onCardTap;

  /// Animate the card using a smooth transition.
  /// It's better to use with [opacityChangeOnDrag] set on `true`.
  final bool animateCardScale;

  /// The appear duration time for the back card on the stack,
  /// when the card on the top is dismissed
  final Duration? dismissedCardDuration;

  /// Create a stack of card with a specified length, via the [count] parameter.
  ///
  /// To render the item, is used the [builder] property.
  CardStackWidget.builder({
    required int count,
    required CardStackWidgetBuilder builder,
    Key? key,
    double? positionFactor,
    double? scaleFactor,
    CardOrientation? cardDismissOrientation,
    CardOrientation? swipeOrientation,
    this.alignment,
    this.reverseOrder = false,
    this.onCardTap,
    this.opacityChangeOnDrag = false,
    this.animateCardScale = false,
    this.dismissedCardDuration,
  })  : scaleFactor = scaleFactor ?? scaleFactorDefault,
        positionFactor = positionFactor ?? positionFactorDefault,
        cardDismissOrientation = cardDismissOrientation ?? CardOrientation.both,
        swipeOrientation = swipeOrientation ?? CardOrientation.both,
        cardList = _getCardListFromBuilder(builder, count),
        super(key: key);

  /// Create a stack of card using the [CardModel] properties inside the
  /// [cardList] parameter.
  const CardStackWidget({
    required this.cardList,
    Key? key,
    double? positionFactor,
    double? scaleFactor,
    CardOrientation? cardDismissOrientation,
    CardOrientation? swipeOrientation,
    this.alignment,
    this.reverseOrder = false,
    this.onCardTap,
    this.opacityChangeOnDrag = false,
    this.animateCardScale = false,
    this.dismissedCardDuration,
  })  : scaleFactor = scaleFactor ?? scaleFactorDefault,
        positionFactor = positionFactor ?? positionFactorDefault,
        cardDismissOrientation = cardDismissOrientation ?? CardOrientation.both,
        swipeOrientation = swipeOrientation ?? CardOrientation.both,
        super(key: key);

  @override
  _CardStackWidgetState createState() => _CardStackWidgetState();

  /// Used to create the [CardModel] at the specified index.
  ///
  /// Returns a list of CardModel, built via the [builder] function.
  static List<CardModel> _getCardListFromBuilder(
    CardStackWidgetBuilder builder,
    int count,
  ) {
    final cardList = <CardModel>[];

    for (int current = 0; current < count; current++) {
      cardList.add(builder.call(current));
    }

    return cardList;
  }
}

class _CardStackWidgetState extends State<CardStackWidget>
    with TickerProviderStateMixin {
  final listenableStartingAnimation = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment ?? Alignment.center,
      children: _buildCards(),
    );
  }

  /// Return a list of widget with type of [CardWidget].
  List<CardWidget> _buildCards() {
    final lengthCardList = widget.cardList.length;

    final cardListOrdered = widget.reverseOrder
        ? widget.cardList.reversed.toList(growable: false)
        : widget.cardList;

    final cards = <CardWidget>[];

    for (int currentIndex = 0; currentIndex < lengthCardList; currentIndex++) {
      final positionCalc = widget.positionFactor * currentIndex * 10;

      final scalePercentage = lengthCardList * widget.scaleFactor / 100;

      final indexPercentage =
          scalePercentage * (lengthCardList - currentIndex - 1);

      final scaleCalc = 1 - indexPercentage;

      final model = cardListOrdered[currentIndex];

      final draggable = currentIndex == lengthCardList - 1;

      final listenableTop = ValueNotifier<double>(0);

      final listenableScale = ValueNotifier<double>(0);

      final card = CardWidget(
        listenableDismissedAnimation:
            currentIndex == 0 ? listenableStartingAnimation : null,
        listenablePositionTop: listenableTop,
        listenableScale: listenableScale,
        opacityChangeOnDrag: widget.opacityChangeOnDrag,
        positionTop: positionCalc,
        swipeOrientation: widget.swipeOrientation,
        dismissOrientation: widget.cardDismissOrientation,
        scale: scaleCalc,
        model: model,
        draggable: draggable,
        onCardTap: widget.onCardTap,
        onCardDragEnd: _updateCardListOnAnimationEnd,
        onCardUpdate: (delta) {
          if (widget.animateCardScale) {
            _makeAnimationValue(cards, currentIndex, delta);
          }
        },
      );

      cards.add(card);
    }

    return cards;
  }

  /// This is used to make a smooth animation between cards into the list,
  /// when the [widget.animateCardScale] is set to `true`.
  void _makeAnimationValue(
      List<CardWidget> cards, int currentIndex, Offset delta) {
    for (int current = 0; current < cards.length; current++) {
      if (current == currentIndex) continue;

      if (delta.dy > 0 &&
          current < cards.length &&
          cards[current].scale! + cards[current].listenableScale.value <
              cards[current + 1].scale!) {
        cards[current].listenableScale.value += delta.dy / 500;

        if (delta.dy > 0 &&
            current < cards.length &&
            cards[current].positionTop +
                    cards[current].listenablePositionTop.value <
                cards[current + 1].positionTop) {
          cards[current].listenablePositionTop.value += delta.dy / 2;
        }
      }
    }
  }

  /// Reorder the element inside the [widget.cardList] at the end of the
  /// animation based on swipe orientation
  void _updateCardListOnAnimationEnd(CardOrientation orientation) {
    final lastElementIndex = !widget.reverseOrder
        ? (orientation == CardOrientation.down ? widget.cardList.length - 1 : 0)
        : (orientation == CardOrientation.down
            ? 0
            : widget.cardList.length - 1);

    final firstElementIndex = !widget.reverseOrder
        ? (orientation == CardOrientation.down ? 0 : widget.cardList.length - 1)
        : (orientation == CardOrientation.down
            ? widget.cardList.length - 1
            : 0);

    final model = widget.cardList.removeAt(lastElementIndex);

    setState(() {
      widget.cardList.insert(firstElementIndex, model);
    });

    if(widget.dismissedCardDuration != null) {
      _makeAnimationOnLastCard();
    }
  }
  
  /// Create an animation for the back card on the stack
  /// when this is dismissed
  void _makeAnimationOnLastCard() {
    final controller = AnimationController(
      vsync: this,
      duration: widget.dismissedCardDuration ?? Duration.zero,
    );

    final animation = Tween<double>(
      begin: 20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));
    animation.addListener(() {
      listenableStartingAnimation.value = animation.value;
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}
