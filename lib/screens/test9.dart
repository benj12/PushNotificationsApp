import 'package:flutter/material.dart';

class Test9Screen extends StatelessWidget {
  const Test9Screen({super.key});
  final String title = "Test9";
  final String virtueDefinition = "This is test9";
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
