import 'package:flutter/material.dart';

class Test1Screen extends StatelessWidget {
  const Test1Screen({super.key});

  final String title = "Test1";
  final String virtueDefinition = "This is test1";
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
