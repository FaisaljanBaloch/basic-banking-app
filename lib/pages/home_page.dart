import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: const Center(
        child: Text(
          "Welcome to Basic Banking App by Faisal Jan. This App was created as a task during an GRIP internship at The Sparks Foundation.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
