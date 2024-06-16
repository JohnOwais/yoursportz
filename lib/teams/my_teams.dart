// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/teams/team_details.dart';
import 'package:yoursportz/create_team/create_team.dart';

class MyTeams extends StatefulWidget {
  const MyTeams({super.key, required this.phone});

  final String phone;

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  var filterText = "";
  List<Map<String, dynamic>> teams = [];
  var isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final body =
          jsonEncode(<String, dynamic>{'phone': widget.phone, 'count': 0});
      final response = await http.post(
          Uri.parse(
              "https://yoursportzbackend.azurewebsites.net/api/team/get-teams/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          teams = jsonData.cast<Map<String, dynamic>>();
        });
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text("My Teams"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: teams.isNotEmpty || isLoading
          ? Column(
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Type team name",
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                isLoading
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];
                              if (team['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(filterText.toLowerCase())) {
                                return Team(team: team);
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      )
              ],
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Team Created", style: TextStyle(fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
                  child: Text(
                      "You don't own any team yet.\nCreate your first team to get started.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CreateTeam(
                                phone: widget.phone,
                                ground: const {},
                                source: "home"))));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff554585)),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("Create Team",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )),
    );
  }
}

class Team extends StatelessWidget {
  const Team({
    super.key,
    required this.team,
  });

  final Map<String, dynamic> team;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamDetails(
                    phone: team['phone'],
                    teamId: team['teamId'],
                    teamLogo: team['logo'],
                    teamName: team['name'],
                    city: team['city'])));
      },
      child: Card(
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
                    team['name'],
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    team['city'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
