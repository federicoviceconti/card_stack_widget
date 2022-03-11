import 'package:card_stack_widget/model/card_model.dart';
import 'package:card_stack_widget/model/swipe_orientation.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  /// Current card model shown
  final CardModel? model;

  final double? scale;

  /// Enable the dragging on the card
  final bool? draggable;

  /// Function invoked at the end of the drag
  final Function()? onCardDragEnd;

  /// Direction where the card could be dismissed and removed from the list
  final SwipeOrientation? dismissOrientation;

  /// Drag direction enabled
  final SwipeOrientation? swipeOrientation;

  /// Top from the parent
  final double? positionTop;

  const CardWidget({
    Key? key,
    this.positionTop,
    this.scale,
    this.model,
    this.draggable,
    this.onCardDragEnd,
    this.dismissOrientation,
    this.swipeOrientation,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  double draggingAnimationY = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween(
      begin: Offset(0, widget.positionTop!),
      end: Offset(0, widget.positionTop!),
    ).animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.positionTop! + _animation.value.dy,
        child: Transform.scale(
          scale: widget.scale!,
          child: GestureDetector(
            onVerticalDragUpdate: _handleVerticalUpdate,
            onVerticalDragEnd: _handleVerticalEnd,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.model!.radius)),
                boxShadow: [
                  BoxShadow(blurRadius: 2, color: widget.model!.shadowColor)
                ],
                color: widget.model!.backgroundColor,
              ),
              child: widget.model!.child,
            ),
          ),
        ));
  }

  void _handleVerticalUpdate(DragUpdateDetails details) {
    if (widget.draggable! && _isSwipeDirectionEnabled(details.delta.dy)) {
      setState(() {
        draggingAnimationY = _animation.value.dy;

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

  void _handleVerticalEnd(DragEndDetails details) {
    var endAnimationY = _animation.value.dy;

    setState(() {
      _animation = Tween(
          begin: Offset(0, _animation.value.dy),
          end: Offset(
            0,
            widget.positionTop!,
          )).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ));
    });

    _animationController.forward();

    if (_shouldDismissCard(endAnimationY)) {
      widget.onCardDragEnd!();
    }
  }

  bool _shouldDismissCard(double endAnimationY) {
    if (widget.dismissOrientation == SwipeOrientation.up) {
      return endAnimationY < draggingAnimationY;
    } else if (widget.dismissOrientation == SwipeOrientation.down) {
      return endAnimationY > draggingAnimationY;
    }

    return true;
  }

  bool _isSwipeDirectionEnabled(double delta) {
    if (widget.swipeOrientation == SwipeOrientation.up) {
      return delta < 0;
    } else if (widget.swipeOrientation == SwipeOrientation.down) {
      return delta > 0;
    }

    return true;
  }
}
