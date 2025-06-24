import 'package:flutter/material.dart';

class Test4Screen extends StatelessWidget {
  const Test4Screen({super.key});
  final String title = "Test4";
  final String virtueDefinition = "This is test4";
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
