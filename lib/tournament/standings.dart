import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/standings_tabs/about.dart';
import 'package:yoursportz/tournament/standings_tabs/gallery.dart';
import 'package:yoursportz/tournament/standings_tabs/matches.dart';
import 'package:yoursportz/tournament/standings_tabs/points_table.dart';
import 'package:yoursportz/tournament/standings_tabs/teams.dart';

class Standings extends StatefulWidget {
  const Standings({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Standings> createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  var selectedTab = "About";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Standings"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/tournament_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                        child: Image.network(
                      widget.tournament['logoUrl'],
                      height: 60,
                      width: 60,
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
                          height: 60,
                        );
                      },
                    ))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tournament['tournamentName'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.tournament['city'],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = "About";
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: selectedTab == "About"
                                    ? const Color.fromARGB(255, 107, 89, 161)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Text("About",
                                  style: TextStyle(
                                      color: selectedTab == "About"
                                          ? Colors.white
                                          : Colors.grey[700])),
                            ))),
                    const SizedBox(width: 8),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = "Teams";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedTab == "Teams"
                                  ? const Color.fromARGB(255, 107, 89, 161)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              "Teams",
                              style: TextStyle(
                                  color: selectedTab == "Teams"
                                      ? Colors.white
                                      : Colors.grey[700]),
                            ),
                          ),
                        )),
                    const SizedBox(width: 8),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = "Matches";
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectedTab == "Matches"
                                  ? const Color.fromARGB(255, 107, 89, 161)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              "Matches",
                              style: TextStyle(
                                  color: selectedTab == "Matches"
                                      ? Colors.white
                                      : Colors.grey[700]),
                            ),
                          ),
                        )),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = "Points Table";
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: selectedTab == "Points Table"
                                  ? const Color.fromARGB(255, 107, 89, 161)
                                  : Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              "Points Table",
                              style: TextStyle(
                                  color: selectedTab == "Points Table"
                                      ? Colors.white
                                      : Colors.grey[700]),
                            ),
                          )),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = "Gallery";
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: selectedTab == "Gallery"
                                  ? const Color.fromARGB(255, 107, 89, 161)
                                  : Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              "Gallery",
                              style: TextStyle(
                                  color: selectedTab == "Gallery"
                                      ? Colors.white
                                      : Colors.grey[700]),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedTab == "About")
              About(tournament: widget.tournament)
            else if (selectedTab == "Teams")
              Expanded(child: Teams(tournament: widget.tournament))
            else if (selectedTab == "Matches")
              Expanded(child: Matches(tournament: widget.tournament))
            else if (selectedTab == "Points Table")
              PointsTable(tournament: widget.tournament)
            else if (selectedTab == "Gallery")
              Expanded(child: Gallery(tournament: widget.tournament))
          ]),
        ]));
  }
}
