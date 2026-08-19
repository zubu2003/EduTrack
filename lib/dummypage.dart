import 'package:flutter/material.dart';
class Dummypage extends StatelessWidget {
  const Dummypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("dummy"),),
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          color: Colors.purpleAccent,
        ),
      ),
    );

  }
}
