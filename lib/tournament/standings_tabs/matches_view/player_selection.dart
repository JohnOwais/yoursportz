// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/ongoing_tournaments.dart';

class PlayerSelection extends StatefulWidget {
  const PlayerSelection(
      {super.key,
      required this.phone,
      required this.type,
      required this.tournamentId,
      required this.group,
      required this.date,
      required this.time,
      required this.teamA,
      required this.teamB,
      required this.scorer});

  final String phone;
  final String type;
  final String tournamentId;
  final String group;
  final String date;
  final String time;
  final Map<String, dynamic> teamA;
  final Map<String, dynamic> teamB;
  final Map<String, dynamic> scorer;

  @override
  State<PlayerSelection> createState() => _PlayerSelectionState();
}

class _PlayerSelectionState extends State<PlayerSelection> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 245),
      appBar: AppBar(
        title: const Text("Player Selection"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
            child: Column(children: [
              Expanded(
                child: ListView.builder(
                    itemCount: widget.teamA['players'].length,
                    itemBuilder: (context, index) {
                      final player = widget.teamA['players'][index];
                      return Player(player: player);
                    }),
              )
            ]),
          ),
          Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final body = jsonEncode(<String, dynamic>{
                            'tournamentId': widget.tournamentId,
                            'date': widget.date,
                            'time': widget.time,
                            'homeTeam': widget.teamA,
                            'opponentTeam': widget.teamB,
                            'scorer': widget.scorer
                          });
                          final response = await http.post(
                              Uri.parse(
                                  "https://yoursportzbackend.azurewebsites.net/api/tournament/create-match/"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: body);
                          final Map<String, dynamic> responseData =
                              jsonDecode(response.body);
                          if (responseData['message'] == "success") {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OngoingTournaments(
                                        phone: widget.phone)));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Row(
                                      children: [
                                        Text("Match Scheduled Successfully",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(width: 8),
                                        Icon(Icons.done_all,
                                            color: Colors.white)
                                      ],
                                    ),
                                    backgroundColor: Colors.green));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Server error. Failed to schedule match !!!",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color(0xff554585)),
                        child: isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(4),
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white),
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                    widget.type == "start"
                                        ? "Start Match"
                                        : "Schedule Match",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.player,
  });

  final Map<String, dynamic> player;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                child:
                    Text(player['name'], style: const TextStyle(fontSize: 17)),
              ),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.grey, size: 15),
                  Text(player['city'],
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ));
  }
}
