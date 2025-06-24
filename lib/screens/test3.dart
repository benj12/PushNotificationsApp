import 'package:flutter/material.dart';

class Test3Screen extends StatelessWidget {
  const Test3Screen({super.key});
  final String title = "Test3";
  final String virtueDefinition = "This is test3";
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
