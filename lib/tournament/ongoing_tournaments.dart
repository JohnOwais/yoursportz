import 'package:flutter/material.dart';

class OngoingTournaments extends StatefulWidget {
  const OngoingTournaments({super.key, required this.phone});

  final String phone;

  @override
  State<OngoingTournaments> createState() => _OngoingTournamentsState();
}

class _OngoingTournamentsState extends State<OngoingTournaments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text("Tournaments"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: []),
      ),
    );
  }
}
