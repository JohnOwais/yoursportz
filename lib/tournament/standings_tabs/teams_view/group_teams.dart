// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/ongoing_tournaments.dart';

class GroupTeams extends StatefulWidget {
  const GroupTeams(
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
  State<GroupTeams> createState() => _GroupTeamsState();
}

class _GroupTeamsState extends State<GroupTeams> {
  List<Map<String, dynamic>> teams = [];
  List<List<Map<String, dynamic>>> groupedTeams = [[]];
  var currentSelection = 1;
  var selectedGroup = "Group 1";
  var filterText = "";
  late double teamsPerGroup;
  var isLoading = false;

  @override
  void initState() {
    teamsPerGroup =
        int.parse(widget.numberOfTeams) / int.parse(widget.numberOfGroups);
    teams = List.from(widget.teams);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text('Group Teams'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 70,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filterText = value;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(32)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 240, 240, 245),
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Type team name",
                        hintStyle:
                            const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(selectedGroup,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      groupedTeams[currentSelection - 1].length < teamsPerGroup
                          ? const EdgeInsets.fromLTRB(4, 0, 4, 8)
                          : const EdgeInsets.fromLTRB(4, 0, 4, 65),
                  child: ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return team['name']
                              .toString()
                              .toLowerCase()
                              .contains(filterText.toLowerCase())
                          ? TeamCard(
                              teamLogo: team['logo'],
                              teamName: team['name'],
                              city: team['city'],
                              addTeam: () {
                                if (groupedTeams[currentSelection - 1].length <
                                    teamsPerGroup.toInt()) {
                                  setState(() {
                                    groupedTeams[currentSelection - 1]
                                        .add(team);
                                    teams.removeAt(index);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Can't add more teams",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              })
                          : const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
          groupedTeams[currentSelection - 1].length >= teamsPerGroup.toInt()
              ? Column(
                  children: [
                    const Spacer(),
                    Container(
                      color: const Color.fromARGB(255, 240, 240, 245),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (currentSelection <
                                      int.parse(widget.numberOfGroups)) {
                                    setState(() {
                                      groupedTeams.add([]);
                                      selectedGroup =
                                          "Group ${++currentSelection}";
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final body = jsonEncode(<String, dynamic>{
                                      'tournamentId': widget.tournamentId,
                                      'groupedTeams': groupedTeams
                                    });
                                    final response = await http.post(
                                        Uri.parse(
                                            "https://yoursportzbackend.azurewebsites.net/api/tournament/group-teams/"),
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                        },
                                        body: body);
                                    final Map<String, dynamic> responseData =
                                        jsonDecode(response.body);
                                    if (responseData['message'] == "success") {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OngoingTournaments(
                                                      phone: widget.phone)));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Row(
                                                children: [
                                                  Text(
                                                      "Teams Grouped Successfully",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.done_all,
                                                      color: Colors.white)
                                                ],
                                              ),
                                              backgroundColor: Colors.green));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Server Error. Failed to group teams !!!",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3)));
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                          child:
                                              const CircularProgressIndicator(
                                                  color: Colors.white),
                                        ))
                                    : Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                            currentSelection <
                                                    int.parse(
                                                        widget.numberOfGroups)
                                                ? 'Next'
                                                : 'Save Changes',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key,
      required this.teamLogo,
      required this.teamName,
      required this.city,
      required this.addTeam});

  final String teamLogo;
  final String teamName;
  final String city;
  final Function() addTeam;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  teamLogo,
                  height: 50,
                  width: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                      height: 50,
                    );
                  },
                ))),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    teamName.length <= 15
                        ? teamName
                        : teamName.substring(0, 15),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 107, 89, 161),
                        fontSize: 17)),
                Text(
                  city.length <= 15 ? city : city.substring(0, 15),
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                addTeam();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xff554585)),
              child: const Text('ADD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
