import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      home: child,
    );
  }
}

