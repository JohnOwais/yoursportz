// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/ongoing_tournaments.dart';

class AddTeamsToTournament extends StatefulWidget {
  const AddTeamsToTournament(
      {super.key, required this.phone, required this.tournamentId});

  final String phone;
  final String tournamentId;

  @override
  State<AddTeamsToTournament> createState() => _AddTeamsToTournamentState();
}

class _AddTeamsToTournamentState extends State<AddTeamsToTournament> {
  List<Map<String, dynamic>> teams = [];
  var filterText = "";
  var teamsLoading = true;
  var isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await http.get(Uri.parse(
          "https://yoursportzbackend.azurewebsites.net/api/team/all/"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          teams = jsonData.cast<Map<String, dynamic>>();
          for (var team in teams) {
            team['selected'] = false;
          }
          teamsLoading = false;
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
        title: const Text("Add Teams to Tournament"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: teamsLoading
          ? const Expanded(child: Center(child: CircularProgressIndicator()))
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Column(
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
                                fillColor:
                                    const Color.fromARGB(255, 240, 240, 245),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                prefixIcon: const Icon(Icons.search),
                                hintText: "Type team name",
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];
                              return team['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains(filterText.toLowerCase()) &&
                                      team['selected'] == false
                                  ? Team(
                                      team: team,
                                      select: () {
                                        setState(() {
                                          team['selected'] = true;
                                        });
                                      })
                                  : const SizedBox();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              List<Map<String, dynamic>> selectedTeams = teams
                                  .where((team) => team['selected'] == true)
                                  .toList();
                              for (var team in selectedTeams) {
                                team.remove('selected');
                              }
                              if (selectedTeams.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "No teams added to tournament yet",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.orange,
                                        duration: Duration(seconds: 3)));
                                return;
                              }
                              setState(() {
                                isLoading = true;
                              });
                              final body = jsonEncode(<String, dynamic>{
                                'tournamentId': widget.tournamentId,
                                'teams': selectedTeams
                              });
                              final response = await http.post(
                                  Uri.parse(
                                      "https://yoursportzbackend.azurewebsites.net/api/tournament/add-teams/"),
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
                                            Text("Teams Added Successfully",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            SizedBox(width: 8),
                                            Icon(Icons.done_all,
                                                color: Colors.white)
                                          ],
                                        ),
                                        backgroundColor: Colors.green));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Server Error. Failed to add teams !!!",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3)));
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
                                    child: Text("Save Changes",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])
              ],
            ),
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key, required this.team, required this.select});

  final Map<String, dynamic> team;
  final Function() select;

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
                  team['logo'],
                  height: 50,
                  width: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team['name'].toString().length <= 15
                      ? team['name']
                      : team['name'].toString().substring(0, 15),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  team['city'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                select();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.cyan),
              child: const Text("ADD",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16)
          ],
        ));
  }
}
