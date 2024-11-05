import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      home: child,
    );
  }
}
