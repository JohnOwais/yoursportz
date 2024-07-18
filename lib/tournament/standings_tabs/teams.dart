import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/standings_tabs/teams_view/group_teams.dart';
import 'package:yoursportz/tournament/standings_tabs/teams_view/add_teams_tournament.dart';
import 'package:yoursportz/tournament/standings_tabs/teams_view/group_teams_partially.dart';

class Teams extends StatefulWidget {
  const Teams({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(150, 200, 200, 200),
            borderRadius: BorderRadius.circular(16.0)),
        child: widget.tournament['teams'].isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No Teams Added",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 16),
                      child: Text("Please add teams first to get started",
                          style: TextStyle(color: Colors.black54)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AddTeamsToTournament(
                                    phone: widget.tournament['phone'],
                                    tournamentId:
                                        widget.tournament['tournamentId']))));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xff554585)),
                      child: const Text("Add Teams",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 70),
                    child: ListView.builder(
                      itemCount: widget.tournament['teams'].length,
                      itemBuilder: (context, index) {
                        final team = widget.tournament['teams'][index];
                        return TeamCard(
                          teamLogo: team['logo'],
                          teamName: team['name'],
                          city: team['city'],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            AddTeamsToTournament(
                                                phone:
                                                    widget.tournament['phone'],
                                                tournamentId: widget.tournament[
                                                    'tournamentId']))));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 235, 235, 245)),
                              child: const Text("Add More Teams",
                                  style: TextStyle(
                                      color: Color(0xff554585),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.tournament['teams'].isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "No teams added to tournament yet."),
                                          backgroundColor: Colors.red));
                                } else if (widget.tournament['teams'].length <
                                    int.parse(
                                        widget.tournament['numberOfTeams'])) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              GroupTeamsPartially(
                                                  phone: widget
                                                      .tournament['phone'],
                                                  tournamentId:
                                                      widget.tournament[
                                                          'tournamentId'],
                                                  teams: widget
                                                      .tournament['teams']
                                                      .cast<
                                                          Map<String,
                                                              dynamic>>(),
                                                  numberOfTeams:
                                                      widget.tournament[
                                                          'numberOfTeams'],
                                                  numberOfGroups:
                                                      widget.tournament[
                                                          'numberOfGroups']))));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => GroupTeams(
                                              phone: widget.tournament['phone'],
                                              tournamentId: widget
                                                  .tournament['tournamentId'],
                                              teams: widget.tournament['teams']
                                                  .cast<Map<String, dynamic>>(),
                                              numberOfTeams: widget
                                                  .tournament['numberOfTeams'],
                                              numberOfGroups: widget.tournament[
                                                  'numberOfGroups']))));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: const Color(0xff554585)),
                              child: const Text("Grouping",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ]),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key,
      required this.teamLogo,
      required this.teamName,
      required this.city});

  final String teamLogo;
  final String teamName;
  final String city;

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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),
      ),
    );
  }
}
