import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card/card_stack/card_stack_widget.dart';
import 'package:flutter_card/card_stack/model/card_model.dart';

import '../card_stack/model/swipe_horientation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mockList = _buildMockList(size: 4, context: context);

    return SafeArea(
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                        child: Icon(Icons.trip_origin),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
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
                            child: TextField(
                              decoration: InputDecoration(hintText: "From..."),
                            )),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              decoration: InputDecoration(hintText: "To..."),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 9,
            child: CardStackWidget(
              swipeOrientation: SwipeOrientation.down,
              positionFactor: 0.2,
              scaleFactor: 0.3,
              alignment: Alignment.center,
              reverseOrder: false,
              cardList: mockList,
              cardDismissOrientation: SwipeOrientation.down),
          )
        ],
      ),
    );
  }

  _buildMockList({int size, BuildContext context}) {
    final double containerWidth = MediaQuery.of(context).size.width - 16;

    var list = List<CardModel>();
    for (int i = 0; i < size; i++) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);

      list.add(CardModel(
          backgroundColor: color,
          radius: 8,
          shadowColor: Colors.black.withOpacity(0.2),
          child: Container(
              height: 300,
              width: containerWidth,
              child: Stack(
                children: [
                  Center(
                    child: Text("${i + 1}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ))));
    }

    return list;
  }
}
