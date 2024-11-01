import 'dart:math';

import '../card_stack_widget.dart';
import 'package:flutter/material.dart';

class HomeWidgetNew extends StatelessWidget {
  const HomeWidgetNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real page example'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: _buildFromTo(),
            ),
            Flexible(
              flex: 10,
              child: _buildCardStackWidget(context),
            )
          ],
        ),
      ),
    );
  }

  CardStackWidget _buildCardStackWidget(BuildContext context) {
    return CardStackWidget.builder(
      count: 4,
      builder: (index) => _buildItemCard(index, context),
      opacityChangeOnDrag: true,
      swipeOrientation: CardOrientation.both,
      cardDismissOrientation: CardOrientation.both,
      positionFactor: 3,
      scaleFactor: 1.5,
      alignment: Alignment.center,
      reverseOrder: false,
      reverseSize: true,
      dismissedCardDuration: const Duration(milliseconds: 300),
    );
  }

  Row _buildFromTo() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(Icons.trip_origin),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(Icons.trip_origin),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 9,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "From...",
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "To...",
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildItemCard(int index, BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 16;

    var color =
        Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

    return CardModel(
      backgroundColor: color,
      radius: const Radius.circular(8.0),
      shadowColor: Colors.black.withOpacity(0.2),
      child: SizedBox(
        height: 310,
        width: containerWidth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Builder: $index",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "From",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Apple Palo Alto, 340 University Ave, Palo Alto, CA 94301, Stati Uniti",
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "To",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Googleplex, 1600 Amphitheatre Pkwy, Mountain View, CA 94043, Stati Uniti",
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset("assets/directions.png"),
            )
          ],
        ),
      ),
    );
  }
}
