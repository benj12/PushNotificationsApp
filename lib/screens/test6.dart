import 'package:flutter/material.dart';

class Test6Screen extends StatelessWidget {
  const Test6Screen({super.key});
  final String title = "Test6";
  final String virtueDefinition = "This is test6";
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
