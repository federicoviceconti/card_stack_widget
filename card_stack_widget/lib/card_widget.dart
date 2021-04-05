import 'package:card_stack_widget/model/card_model.dart';
import 'package:card_stack_widget/model/swipe_horientation.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final CardModel model;
  final double positionTop;
  final double scale;
  final bool draggable;
  final Function() onCardDragEnd;
  final SwipeOrientation dismissOrientation;
  final SwipeOrientation swipeOrientation;

  CardWidget({
    this.positionTop,
    this.scale,
    this.model,
    this.draggable,
    this.onCardDragEnd,
    this.dismissOrientation,
    this.swipeOrientation
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;
  double draggingAnimationY = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(
            begin: Offset(0, widget.positionTop),
            end: Offset(0, widget.positionTop))
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.positionTop + _animation.value.dy,
        child: Transform.scale(
          scale: widget.scale,
          child: GestureDetector(
            onVerticalDragUpdate: _handleVerticalUpdate,
            onVerticalDragEnd: _handleVerticalEnd,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(widget.model.radius)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: widget.model.shadowColor)
                  ],
                  color: widget.model.backgroundColor),
              child: widget.model.child,
            ),
          ),
        ));
  }

  void _handleVerticalUpdate(DragUpdateDetails details) {
    if (widget.draggable && isSwipeDirectionEnabled(details.delta.dy)) {
      setState(() {
        draggingAnimationY = _animation.value.dy;

        _animation = Tween(
                begin: Offset(0, _animation.value.dy),
                end: Offset(0, _animation.value.dy + details.delta.dy))
            .animate(_animationController);
      });

      _animationController.forward();
    }
  }

  void _handleVerticalEnd(DragEndDetails details) {
    var endAnimationY = _animation.value.dy;

    setState(() {
      _animation = Tween(
              begin: Offset(0, _animation.value.dy),
              end: Offset(0, widget.positionTop))
          .animate(CurvedAnimation(
              parent: _animationController, curve: Curves.easeIn));
    });

    _animationController.forward();

    if(shouldDismissCard(endAnimationY)) {
      widget?.onCardDragEnd();
    }
  }

  bool shouldDismissCard(double endAnimationY) {
    if(widget.dismissOrientation == SwipeOrientation.up) {
      return endAnimationY < draggingAnimationY;
    } else if(widget.dismissOrientation == SwipeOrientation.down) {
      return endAnimationY > draggingAnimationY;
    }

    return true;
  }

  bool isSwipeDirectionEnabled(double delta) {
    if(widget.swipeOrientation == SwipeOrientation.up) {
      return delta < 0;
    } else if(widget.swipeOrientation == SwipeOrientation.down) {
      return delta > 0;
    }

    return true;
  }
}
