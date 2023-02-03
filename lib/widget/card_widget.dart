import 'package:card_stack_widget/model/card_model.dart';
import 'package:card_stack_widget/model/card_orientation.dart';
import 'package:flutter/material.dart';

import './card_stack_widget.dart';

class CardWidget extends StatefulWidget {
  /// Current card model shown
  final CardModel model;

  final double? scale;

  /// Enable the dragging on the card
  final bool draggable;

  /// Function invoked at the end of the drag. The [CardOrientation] parameter
  /// indicate the dismiss orientation.
  final Function(CardOrientation)? onCardDragEnd;

  /// Direction where the card could be dismissed and removed from the list.
  /// By default is [CardOrientation.both]
  final CardOrientation dismissOrientation;

  /// Drag direction enabled. By default is [CardOrientation.both]
  final CardOrientation swipeOrientation;

  /// Top from the parent
  final double positionTop;

  /// Change card opacity on drag (by default is disabled)
  final bool opacityChangeOnDrag;

  /// If not null, the function will be invoked on the tap of the card.
  final Function(CardModel)? onCardTap;

  /// Used for animate position when [CardStackWidget.animateCardScale] is set
  /// on true.
  final ValueNotifier<double> listenablePositionTop;

  /// Used for animate scale when [CardStackWidget.animateCardScale] is set
  /// on true.
  final ValueNotifier<double> listenableScale;

  /// Function called when this card is moved.
  final Function(Offset)? onCardUpdate;

  /// Used for animate the back card dismissed when it was on the top
  /// of the stack.
  final ValueNotifier<double>? listenableDismissedAnimation;

  const CardWidget({
    Key? key,
    required this.listenableScale,
    required this.listenablePositionTop,
    required this.positionTop,
    this.listenableDismissedAnimation,
    required this.model,
    required this.draggable,
    this.onCardTap,
    this.scale,
    this.onCardDragEnd,
    this.onCardUpdate,
    this.dismissOrientation = CardOrientation.both,
    this.swipeOrientation = CardOrientation.both,
    this.opacityChangeOnDrag = false,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with TickerProviderStateMixin {
  late AnimationController _dragAnimationController;
  late Animation<Offset> _dragAnimation;
  late double _draggingAnimationY;
  double _currentOpacity = 1.0;

  @override
  void initState() {
    _draggingAnimationY = widget.positionTop;

    _dragAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    _dragAnimation = Tween(
      begin: Offset(0, widget.positionTop),
      end: Offset(0, widget.positionTop),
    ).animate(_dragAnimationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animListenable =
        widget.listenableDismissedAnimation ?? ValueNotifier<double>(0.0);

    final scale = widget.scale ?? 1.0;

    return ValueListenableBuilder<double>(
      valueListenable: animListenable,
      builder: (_, startingAnim, __) {
        return CardBodyWidget(
          model: widget.model,
          dragAnimationValueY: _draggingAnimationY,
          dismissedAnimationValue: startingAnim,
          currentOpacity: _currentOpacity,
          handleVerticalEnd: _handleVerticalEnd,
          handleVerticalUpdate: _handleVerticalUpdate,
          listenablePositionTop: widget.listenablePositionTop,
          listenableScale: widget.listenableScale,
          onCardTap: widget.onCardTap,
          positionTop: widget.positionTop,
          scale: scale,
        );
      },
    );
  }

  /// Handle the update on drag for the current card visible only if the
  /// [CardWidget.draggable] property is set to `true`
  void _handleVerticalUpdate(DragUpdateDetails details) {
    if (widget.draggable && _isSwipeDirectionEnabled(details.delta.dy)) {
      setState(() {
        _currentOpacity = _calculateOpacity();

        _draggingAnimationY = _dragAnimation.value.dy;

        _dragAnimation = Tween(
            begin: Offset(0, _dragAnimation.value.dy),
            end: Offset(
              0,
              _dragAnimation.value.dy + details.delta.dy,
            )).animate(_dragAnimationController);
      });

      widget.onCardUpdate?.call(details.delta);

      _dragAnimationController.forward();
    }
  }

  /// Handle the drag at the end
  void _handleVerticalEnd(DragEndDetails details) {
    var endAnimationY = _dragAnimation.value.dy;

    if (endAnimationY != widget.positionTop) {
      setState(() {
        _currentOpacity = 1.0;

        _dragAnimation = Tween(
            begin: Offset(0, _dragAnimation.value.dy),
            end: Offset(
              0,
              widget.positionTop,
            )).animate(CurvedAnimation(
          parent: _dragAnimationController,
          curve: Curves.easeIn,
        ));

        _draggingAnimationY = widget.positionTop;
      });

      if (_shouldDismissCard(endAnimationY)) {
        widget.onCardDragEnd!(_getDismissOrientation(endAnimationY));
      }
    }
  }

  CardOrientation _getDismissOrientation(double endAnimationY) {
    if (endAnimationY < _draggingAnimationY) {
      return CardOrientation.up;
    } else {
      return CardOrientation.down;
    }
  }

  /// Check on the current card, if it is dismissible or not for the direction
  /// using the [CardWidget.dismissOrientation] property
  bool _shouldDismissCard(double endAnimationY) {
    switch (widget.dismissOrientation) {
      case CardOrientation.up:
        return endAnimationY < _draggingAnimationY;
      case CardOrientation.down:
        return endAnimationY > _draggingAnimationY;
      case CardOrientation.both:
        return true;
      case CardOrientation.none:
        return false;
    }
  }

  /// Check on the current card, if the swipe is enabled or not for the
  /// direction using the [CardWidget.swipeOrientation] property
  bool _isSwipeDirectionEnabled(double delta) {
    switch (widget.swipeOrientation) {
      case CardOrientation.up:
        return delta < 0;
      case CardOrientation.down:
        return delta > 0;
      case CardOrientation.both:
        return true;
      case CardOrientation.none:
        return false;
    }
  }

  /// Calculate the opacity to apply to the card if the
  /// [CardWidget.opacityChangeOnDrag] is enabled
  double _calculateOpacity() {
    if (!widget.opacityChangeOnDrag) return 1.0;

    final positionTop = widget.positionTop;
    final dragCurrent = _draggingAnimationY;

    double opacity;

    if (positionTop == 0 || dragCurrent == 0) {
      opacity = 1.0;
    } else if (positionTop < dragCurrent) {
      opacity = (positionTop * _currentOpacity) / dragCurrent;
    } else {
      opacity = dragCurrent / positionTop;
    }

    if (opacity.isNaN && _currentOpacity < 0.5) {
      return 0.0;
    } else if (opacity.isNaN && _currentOpacity > 0.5) {
      return 1.0;
    } else if (opacity > 1) {
      return 1.0;
    } else if (opacity < 0.0) {
      return 0.0;
    } else {
      return opacity;
    }
  }

  @override
  void dispose() {
    _dragAnimationController.dispose();
    super.dispose();
  }
}

class CardBodyWidget extends StatelessWidget {
  /// Value for dismissed animation
  final double? dismissedAnimationValue;

  /// Value for dragging animation
  final double dragAnimationValueY;

  /// Initial position of the card
  final double positionTop;

  /// Opacity for the current card
  final double currentOpacity;

  /// Scale for the current card
  final double scale;

  /// The card model
  final CardModel model;

  /// Notifier for the animation for the card not
  /// dragged
  final ValueNotifier<double> listenablePositionTop;

  /// Notifier for the animation for the scaling
  final ValueNotifier<double> listenableScale;

  /// Invoked when the card is dragged
  final Function(DragUpdateDetails) handleVerticalUpdate;

  /// Invoked when the card drag is ended
  final Function(DragEndDetails) handleVerticalEnd;

  /// Invoked when the card is tapped
  final Function(CardModel)? onCardTap;

  const CardBodyWidget({
    Key? key,
    required this.model,
    required this.listenablePositionTop,
    required this.listenableScale,
    required this.positionTop,
    required this.currentOpacity,
    required this.dragAnimationValueY,
    required this.scale,
    this.dismissedAnimationValue,
    required this.handleVerticalEnd,
    required this.handleVerticalUpdate,
    required this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var animationValue = dismissedAnimationValue ?? 0.0;

    return ValueListenableBuilder<double>(
      valueListenable: listenablePositionTop,
      builder: (_, top, child) {
        return Positioned(
          key: model.key,
          top: positionTop + dragAnimationValueY + top + animationValue,
          child: child ?? const IgnorePointer(),
        );
      },
      child: Opacity(
        opacity: currentOpacity,
        child: ValueListenableBuilder<double>(
          valueListenable: listenableScale,
          builder: (_, animScale, child) {
            return Transform.scale(
              scale: scale + animScale,
              child: child ?? const IgnorePointer(),
            );
          },
          child: CardChildWidget(
            handleVerticalEnd: handleVerticalEnd,
            handleVerticalUpdate: handleVerticalUpdate,
            model: model,
            onCardTap: onCardTap,
          ),
        ),
      ),
    );
  }
}

class CardChildWidget extends StatelessWidget {
  /// The card model
  final CardModel model;

  /// Function invoked when the card is moved
  final Function(DragUpdateDetails) handleVerticalUpdate;

  /// Function invoked when the card movement is finished
  final Function(DragEndDetails) handleVerticalEnd;

  /// Function invoked when is made a tap on the card
  final Function(CardModel)? onCardTap;

  const CardChildWidget({
    Key? key,
    required this.model,
    required this.handleVerticalUpdate,
    required this.handleVerticalEnd,
    required this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: handleVerticalUpdate,
      onVerticalDragEnd: handleVerticalEnd,
      onTap: () => onCardTap?.call(model),
      child: Container(
        padding: model.padding,
        margin: model.margin,
        decoration: BoxDecoration(
          gradient: model.gradient,
          image: model.imageDecoration,
          borderRadius: BorderRadius.all(model.radius),
          border: model.border,
          boxShadow: [
            BoxShadow(
              blurRadius: model.shadowBlurRadius,
              color: model.shadowColor,
            )
          ],
          color: model.backgroundColor,
        ),
        child: model.child,
      ),
    );
  }
}
