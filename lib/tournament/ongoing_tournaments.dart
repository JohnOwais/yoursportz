// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/add_teams_groups.dart';
import 'package:yoursportz/tournament/add_teams_tournament.dart';
import 'package:yoursportz/tournament/create_tournament.dart';
import 'package:yoursportz/tournament/share_invite.dart';
import 'package:yoursportz/tournament/standings.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/tournament_type.dart';

class OngoingTournaments extends StatefulWidget {
  const OngoingTournaments({
    super.key,
    required this.phone,
  });

  final String phone;

  @override
  State<OngoingTournaments> createState() => _OngoingTournamentsState();
}

class _OngoingTournamentsState extends State<OngoingTournaments> {
  var filterText = "";
  var isLoading = true;
  List<Map<String, dynamic>> tournaments = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final body = jsonEncode(<String, dynamic>{
        'phone': widget.phone,
      });
      final response = await http.post(
          Uri.parse(
              "https://yoursportzbackend.azurewebsites.net/api/tournament/get-by-phone/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<List<Map<String, dynamic>>> allTournaments = (jsonData as List)
            .sublist(0, 2)
            .map((e) => (e as List).cast<Map<String, dynamic>>())
            .toList();
        List<Map<String, dynamic>> firstList = allTournaments[0];
        for (var tournament in firstList) {
          tournament['status'] = 'ongoing';
        }
        List<Map<String, dynamic>> secondList = allTournaments[1];
        for (var tournament in secondList) {
          tournament['status'] = 'upcoming';
        }
        setState(() {
          tournaments.addAll(allTournaments[0]);
          tournaments.addAll(allTournaments[1]);
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        appBar: AppBar(
          title: const Text("Tournaments"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Stack(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : tournaments.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No Tournaments",
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 8),
                              Text(
                                  "You don't have any ongoing or upcoming tournament. To start a tournament, please create one.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(32)),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          255, 240, 240, 245),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      prefixIcon: const Icon(Icons.search),
                                      hintText: "Type tournament name",
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                              ),
                            ),
                            Container(
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ListView.builder(
                                    itemCount: tournaments.length,
                                    itemBuilder: (context, index) {
                                      return tournaments[index]
                                                  ['tournamentName']
                                              .toString()
                                              .toLowerCase()
                                              .contains(
                                                  filterText.toLowerCase())
                                          ? tournaments[index]['status'] ==
                                                  "ongoing"
                                              ? OngoingTournamentCard(
                                                  tournament:
                                                      tournaments[index])
                                              : UpcomingTournamentCard(
                                                  phone: widget.phone,
                                                  tournament:
                                                      tournaments[index])
                                          : const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
            Column(
              children: [
                const Spacer(),
                Container(
                  color: const Color.fromARGB(255, 235, 235, 240),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const CreateTournament(
                                          phone: '919149764646',
                                        ))));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xff554585)),
                          child: const Text("Create Tournament",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class UpcomingTournamentCard extends StatelessWidget {
  const UpcomingTournamentCard(
      {super.key, required this.phone, required this.tournament});

  final String phone;
  final Map<String, dynamic> tournament;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tournament['tournamentType'] == "null") {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => SelectTournamentType(
                      phone: phone,
                      tournamentId: tournament['tournamentId']))));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Standings(tournament: tournament))));
        }
      },
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner_tournament.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        tournament['tournamentName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            tournament['groundNames'][0],
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white, width: 0.5)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: Text("Upcoming",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tournament['city'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: Text(
                                  "${tournament['startDate']}   -   ${tournament['endDate']}",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        ShareInviteTournament(
                                            link: tournament['invite'],
                                            type: "invite"))));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xff554585)),
                          child: const Text("Invite",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => AddTeamsToTournament(
                                        phone: phone,
                                        tournamentId:
                                            tournament['tournamentId']))));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 235, 235, 245)),
                          child: const Text("Add Teams",
                              style: TextStyle(
                                  color: Color(0xff554585),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (tournament['teams'].isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "No teams added to tournament yet."),
                                      backgroundColor: Colors.red));
                            } else if (tournament['teams'].length <
                                int.parse(tournament['numberOfTeams'])) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Require atleast ${tournament['numberOfTeams']} teams for grouping."),
                                  backgroundColor: Colors.red));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => AddTeamsToGroups(
                                          phone: phone,
                                          tournamentId:
                                              tournament['tournamentId'],
                                          teams: tournament['teams']
                                              .cast<Map<String, dynamic>>(),
                                          numberOfTeams:
                                              tournament['numberOfTeams'],
                                          numberOfGroups:
                                              tournament['numberOfGroups']))));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.cyan),
                          child: const Text("Group Teams",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OngoingTournamentCard extends StatelessWidget {
  const OngoingTournamentCard({
    super.key,
    required this.tournament,
  });

  final Map<String, dynamic> tournament;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => Standings(tournament: tournament))));
      },
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner_tournament.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        tournament['tournamentName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            tournament['groundNames'][0],
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white, width: 0.5)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: Text("Ongoing",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament['city'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                            "${tournament['startDate']}   -   ${tournament['endDate']}",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ShareInviteTournament(
                                    link: tournament['share'],
                                    type: "share"))));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xff554585)),
                      child: const Text("Share",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
