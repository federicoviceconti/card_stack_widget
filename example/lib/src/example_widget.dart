import 'package:example/src/card_change_widget.dart';
import 'package:example/src/home_widget.dart';
import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  ExampleWidgetState createState() => ExampleWidgetState();
}

class ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Spacer(),
              _ButtonRouteWidget(
                name: 'CardStackWidget example',
                widget: CardChangeWidget(),
              ),
              Spacer(),
              _ButtonRouteWidget(
                name: 'Real page example',
                widget: HomeWidget(),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonRouteWidget extends StatelessWidget {
  final String name;

  final Widget widget;

  const _ButtonRouteWidget({
    required this.name,
    required this.widget,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(name),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget,
            ),
          );
        },
      ),
    );
  }
}
