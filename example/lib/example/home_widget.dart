import 'dart:math';

import 'package:card_stack_widget/card_stack_widget.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: _buildTopBar(),
          ),
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
    );
  }

  CardStackWidget _buildCardStackWidget(BuildContext context) {
    final mockList = _buildMockList(context, size: 4);

    return CardStackWidget(
      swipeOrientation: SwipeOrientation.both,
      cardDismissOrientation: SwipeOrientation.up,
      positionFactor: 0.3,
      scaleFactor: 0.2,
      alignment: Alignment.center,
      reverseOrder: false,
      cardList: mockList,
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

  Container _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: const Icon(Icons.arrow_back_ios),
    );
  }

  _buildMockList(BuildContext context, {int size = 0}) {
    final double containerWidth = MediaQuery.of(context).size.width - 16;

    var list = <CardModel>[];
    for (int i = 0; i < size; i++) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);

      list.add(
        CardModel(
          backgroundColor: color,
          radius: 8,
          shadowColor: Colors.black.withOpacity(0.2),
          child: SizedBox(
            height: 310,
            width: containerWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$i",
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
        ),
      );
    }

    return list;
  }
}
