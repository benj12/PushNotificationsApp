import 'package:flutter/material.dart';

class Test8Screen extends StatelessWidget {
  const Test8Screen({super.key});
  final String title = "Test8";
  final String virtueDefinition = "This is test8";
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
