import 'package:card_stack_widget/model/card_model.dart';
import 'package:card_stack_widget/model/card_orientation.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  /// Current card model shown
  final CardModel model;

  final double? scale;

  /// Enable the dragging on the card
  final bool draggable;

  /// Function invoked at the end of the drag
  final Function()? onCardDragEnd;

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

  CardWidget({
    required this.positionTop,
    required this.model,
    required this.draggable,
    this.onCardTap,
    this.scale,
    this.onCardDragEnd,
    this.dismissOrientation = CardOrientation.both,
    this.swipeOrientation = CardOrientation.both,
    this.opacityChangeOnDrag = false,
  }) : super(key: model.key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late double _draggingAnimationY;
  double _currentOpacity = 1.0;

  @override
  void initState() {
    _draggingAnimationY = widget.positionTop;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
    _animation = Tween(
      begin: Offset(0, widget.positionTop),
      end: Offset(0, widget.positionTop),
    ).animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.positionTop + _animation.value.dy,
        child: Opacity(
          opacity: _currentOpacity,
          child: Transform.scale(
            scale: widget.scale!,
            child: GestureDetector(
              onVerticalDragUpdate: _handleVerticalUpdate,
              onVerticalDragEnd: _handleVerticalEnd,
              onTap: () => widget.onCardTap?.call(widget.model),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(widget.model.radius),
                  boxShadow: [
                    BoxShadow(blurRadius: 2, color: widget.model.shadowColor)
                  ],
                  color: widget.model.backgroundColor,
                ),
                child: widget.model.child,
              ),
            ),
          ),
        ));
  }

  /// Handle the update on drag for the current card visible only if the
  /// [CardWidget.draggable] property is set to `true`
  void _handleVerticalUpdate(DragUpdateDetails details) {
    if (widget.draggable && _isSwipeDirectionEnabled(details.delta.dy)) {
      setState(() {
        _currentOpacity = _calculateOpacity();

        _draggingAnimationY = _animation.value.dy;

        _animation = Tween(
            begin: Offset(0, _animation.value.dy),
            end: Offset(
              0,
              _animation.value.dy + details.delta.dy,
            )).animate(_animationController);
      });

      _animationController.forward();
    }
  }

  /// Handle the drag at the end
  void _handleVerticalEnd(DragEndDetails details) {
    var endAnimationY = _animation.value.dy;

    if (endAnimationY != widget.positionTop) {
      setState(() {
        _currentOpacity = 1.0;

        _animation = Tween(
            begin: Offset(0, _animation.value.dy),
            end: Offset(
              0,
              widget.positionTop,
            )).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ));

        _draggingAnimationY = widget.positionTop;
      });

      if (_shouldDismissCard(endAnimationY)) {
        widget.onCardDragEnd!();
      }
    }
  }

  /// Check on the current card, if it is dismissible or not for the direction
  /// using the [CardWidget.dismissOrientation] property
  bool _shouldDismissCard(double endAnimationY) {
    if (widget.dismissOrientation == CardOrientation.up) {
      return endAnimationY < _draggingAnimationY;
    } else if (widget.dismissOrientation == CardOrientation.down) {
      return endAnimationY > _draggingAnimationY;
    }

    return true;
  }

  /// Check on the current card, if the swipe is enabled or not for the
  /// direction using the [CardWidget.swipeOrientation] property
  bool _isSwipeDirectionEnabled(double delta) {
    if (widget.swipeOrientation == CardOrientation.up) {
      return delta < 0;
    } else if (widget.swipeOrientation == CardOrientation.down) {
      return delta > 0;
    }

    return true;
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
    _animationController.dispose();
    super.dispose();
  }
}
