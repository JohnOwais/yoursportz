import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/teams/edit_team.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails(
      {super.key,
      required this.phone,
      required this.teamId,
      required this.teamLogo,
      required this.teamName,
      required this.city});

  final String phone;
  final String teamId;
  final String teamLogo;
  final String teamName;
  final String city;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  List<Map<String, dynamic>> players = [];
  var filterText = "";
  var isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final body = jsonEncode(<String, dynamic>{'team_name': widget.teamName});
      final response = await http.post(
          Uri.parse(
              "https://yoursportzbackend.azurewebsites.net/api/team/get_all_players/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          players = jsonData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 240, 245),
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                      child: Image.network(
                    widget.teamLogo,
                    height: 35,
                    width: 35,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/app_logo.png',
                        height: 35,
                      );
                    },
                  ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.teamName.length <= 15
                          ? widget.teamName
                          : widget.teamName.substring(0, 15),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(widget.city,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              const Spacer(),
              isLoading
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contest) => EditTeam(
                                    phone: widget.phone,
                                    teamId: widget.teamId,
                                    teamLogo: widget.teamLogo,
                                    teamName: widget.teamName,
                                    teamCity: widget.city,
                                    teamPlayers: players)));
                      },
                      child: const Row(
                        children: [
                          Text("Edit",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                          SizedBox(width: 4),
                          Icon(Icons.edit_note, color: Colors.black),
                        ],
                      ))
            ],
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: isLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return player['name']
                              .toString()
                              .toLowerCase()
                              .contains(filterText.toLowerCase())
                          ? Player(
                              dp: player['dp'],
                              name: player['name'],
                              city: player['city'],
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ));
  }
}

class Player extends StatefulWidget {
  const Player({
    super.key,
    required this.dp,
    required this.name,
    required this.city,
  });

  final String dp;
  final String name;
  final String city;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  widget.dp,
                  height: 50,
                  width: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/dp.png',
                      height: 50,
                      width: 50,
                    );
                  },
                ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.city,
                    style: const TextStyle(fontSize: 13, color: Colors.grey))
              ],
            ),
          ],
        ));
  }
}
