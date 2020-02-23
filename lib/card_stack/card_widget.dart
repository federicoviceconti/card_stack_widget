import 'package:flutter/material.dart';
import 'package:flutter_card/card_stack/model/card_model.dart';
import 'package:flutter_card/card_stack/model/dismiss_horientation.dart';

class CardWidget extends StatefulWidget {
  final CardModel model;
  final double positionTop;
  final double scale;
  final bool draggable;
  final Function() onCardDragEnd;
  final DismissOrientation dismissOrientation;

  CardWidget({
    this.positionTop,
    this.scale,
    this.model,
    this.draggable,
    this.onCardDragEnd,
    this.dismissOrientation
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;
  double startingAnimationValueY = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(
            begin: Offset(0, widget.positionTop),
            end: Offset(0, widget.positionTop))
        .animate(_animationController);

    startingAnimationValueY = _animation.value.dy;

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
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.black.withOpacity(0.15))
                  ],
                  color: widget.model.backgroundColor),
              child: widget.model.child,
            ),
          ),
        ));
  }

  void _handleVerticalUpdate(DragUpdateDetails details) {
    if (widget.draggable) {
      setState(() {
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
    if(widget.dismissOrientation == DismissOrientation.up) {
      return endAnimationY < startingAnimationValueY;
    } else if(widget.dismissOrientation == DismissOrientation.down) {
      return endAnimationY > startingAnimationValueY;
    }

    return true;
  }
}
