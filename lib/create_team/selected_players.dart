// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/home/home_screen.dart';
import 'package:yoursportz/start_match/start_match.dart';

class SelectedPlayers extends StatefulWidget {
  const SelectedPlayers(
      {super.key,
      required this.selectedPlayers,
      required this.ground,
      required this.teamName,
      required this.city,
      required this.phone,
      required this.imageUrl,
      required this.addBack,
      required this.source});

  final List<Map<String, dynamic>> selectedPlayers;
  final Map ground;
  final String teamName;
  final String city;
  final String phone;
  final String imageUrl;
  final Function(Map<String, dynamic>) addBack;
  final String source;

  @override
  State<SelectedPlayers> createState() => _SelectedPlayersState();
}

class _SelectedPlayersState extends State<SelectedPlayers> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool allPlayersHavePosition = widget.selectedPlayers.every((player) {
      return player['position'] != null && player['position'].isNotEmpty;
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  widget.imageUrl,
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
            Text(widget.teamName.length <= 15
                ? widget.teamName
                : widget.teamName.substring(0, 15))
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: widget.selectedPlayers.length,
                itemBuilder: (BuildContext context, int index) {
                  final player = widget.selectedPlayers[index];
                  return Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.network(
                                  player['dp'],
                                  height: 50,
                                  width: 50,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/dp.png',
                                      height: 50,
                                      width: 50,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (widget.selectedPlayers.length == 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Team must have atleast 5 players",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Remove Player"),
                                          content: Text(
                                              "Sure to remove ${player['name']}?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No")),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    widget.addBack(player);
                                                    widget.selectedPlayers
                                                        .remove(player);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Yes",
                                                    style: TextStyle(
                                                        color: Colors.red))),
                                          ],
                                        ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.close_outlined,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const SizedBox(width: 16)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text(
                            player['name'],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  size: 13, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                player['city'],
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  hint: const Text("Player Position"),
                                  value: player['position'],
                                  onChanged: (String? value) {
                                    setState(() {
                                      player['position'] = value;
                                    });
                                  },
                                  items: <String>[
                                    'Goalkeeper',
                                    'Right Back',
                                    'Center Back',
                                    'Left Back',
                                    'Right Midfielder',
                                    'Center Midfielder',
                                    'Left Midfielder',
                                    'Right Winger',
                                    'Center Forward',
                                    'Left Winger',
                                    'Center Player'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: const TextStyle(fontSize: 13)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {});
                        if (!allPlayersHavePosition) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please select position for every player",
                                      style: TextStyle(color: Colors.white)),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.orange));
                          return;
                        }
                        setState(() {
                          isLoading = true;
                        });
                        final body = jsonEncode(<String, dynamic>{
                          'team_name': widget.teamName,
                          'players': widget.selectedPlayers
                        });
                        final response = await http.put(
                            Uri.parse(
                                "https://yoursportzbackend.azurewebsites.net/api/team/add_players/"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: body);
                        final Map<String, dynamic> responseData =
                            jsonDecode(response.body);
                        if (responseData['message'] == "success") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(phone: widget.phone)),
                              (route) => false);
                          if (widget.source == "match") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartMatch(
                                        phone: widget.phone,
                                        ground: widget.ground,
                                        team: widget.teamName,
                                        imageUrl: widget.imageUrl)));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => Center(
                                      child: SingleChildScrollView(
                                        child: Dialog(
                                            surfaceTintColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(children: [
                                                Image.asset(
                                                    'assets/images/success_team.png',
                                                    height: 70,
                                                    width: 70),
                                                const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                      "Team Created Successfully",
                                                      style: TextStyle(
                                                          fontSize: 17)),
                                                ),
                                                const SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xff554585)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 0, 12, 0),
                                                    child: Text("Done",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ),
                                              ]),
                                            )),
                                      ),
                                    ));
                          }
                        }
                        setState(() {
                          isLoading = false;
                        });
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
                          : const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text("Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
