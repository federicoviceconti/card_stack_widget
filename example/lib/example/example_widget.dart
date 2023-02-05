import 'package:example/example/card_change_widget.dart';
import 'package:example/example/home_widget.dart';
import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(),
              Spacer(),
              ButtonRouteWidget(
                name: 'CardStackWidget example',
                widget: CardChangeWidget(),
              ),
              Spacer(),
              ButtonRouteWidget(
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

class ButtonRouteWidget extends StatelessWidget {
  final String name;

  final Widget widget;

  const ButtonRouteWidget({
    Key? key,
    required this.name,
    required this.widget,
  }) : super(key: key);

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
