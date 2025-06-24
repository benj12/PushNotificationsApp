import 'package:flutter/material.dart';

class Test2Screen extends StatelessWidget {
  const Test2Screen({super.key});
  final String title = "Test2";
  final String virtueDefinition = "This is test2";
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
