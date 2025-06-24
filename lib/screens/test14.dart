import 'package:flutter/material.dart';

class Test14Screen extends StatelessWidget {
  const Test14Screen({super.key});
  final String title = "Test14";
  final String virtueDefinition = "This is test14";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          virtueDefinition,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
