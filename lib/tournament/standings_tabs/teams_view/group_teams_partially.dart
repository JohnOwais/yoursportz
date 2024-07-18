import 'package:flutter/material.dart';

class GroupTeamsPartially extends StatefulWidget {
  const GroupTeamsPartially(
      {super.key,
      required this.phone,
      required this.tournamentId,
      required this.teams,
      required this.numberOfTeams,
      required this.numberOfGroups});

  final String phone;
  final String tournamentId;
  final List<Map<String, dynamic>> teams;
  final String numberOfTeams;
  final String numberOfGroups;

  @override
  State<GroupTeamsPartially> createState() => _GroupTeamsPartiallyState();
}

class _GroupTeamsPartiallyState extends State<GroupTeamsPartially> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text('Partial Team Grouping'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Partial Grouping",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text("Feature Currently Unavailable",
              style: TextStyle(color: Colors.grey))
        ]),
      ),
    );
  }
}
