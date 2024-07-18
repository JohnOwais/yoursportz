import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/standings_tabs/matches_view/schedule_match.dart';

class Matches extends StatefulWidget {
  const Matches({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  var selectedMatchType = "Live";
  var selectedGroup = "Group A";
  List<Map<String, dynamic>> matches = [];

  @override
  Widget build(BuildContext context) {
    return matches.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(150, 200, 200, 200),
                  borderRadius: BorderRadius.circular(16.0)),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Matches Available",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(32, 8, 32, 16),
                        child: Text(
                            "You don't have played or scheduled any match yet. Start or schedule a match to get started.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.tournament['groupedTeams'].isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Group teams first to start a match",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScheduleTournamentMatch(
                                            tournament: widget.tournament,
                                            type: "start")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color(0xff554585)),
                        child: const Text("Start Match",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Text("OR"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.tournament['groupedTeams'].isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Group teams first to schedule a match",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ScheduleTournamentMatch(
                                            tournament: widget.tournament,
                                            type: "schedule")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 235, 235, 245)),
                        child: const Text("Schedule A Match",
                            style: TextStyle(
                                color: Color(0xff554585),
                                fontWeight: FontWeight.bold)),
                      )
                    ]),
              ),
            ),
          )
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMatchType = "Live";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedMatchType == "Live"
                                                ? const Color.fromARGB(
                                                    255, 107, 89, 161)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Live",
                                                style: TextStyle(
                                                  color: selectedMatchType ==
                                                          "Live"
                                                      ? Colors.white
                                                      : const Color.fromARGB(
                                                          255, 107, 89, 161),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMatchType = "Upcoming";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                selectedMatchType == "Upcoming"
                                                    ? const Color.fromARGB(
                                                        255, 107, 89, 161)
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Upcoming",
                                                  style: TextStyle(
                                                      color:
                                                          selectedMatchType ==
                                                                  "Upcoming"
                                                              ? Colors.white
                                                              : const Color
                                                                  .fromARGB(255,
                                                                  107, 89, 161),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMatchType = "Past";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedMatchType == "Past"
                                                ? const Color.fromARGB(
                                                    255, 107, 89, 161)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Past",
                                                  style: TextStyle(
                                                      color:
                                                          selectedMatchType ==
                                                                  "Past"
                                                              ? Colors.white
                                                              : const Color
                                                                  .fromARGB(255,
                                                                  107, 89, 161),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(150, 200, 200, 200),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedGroup = "Group A";
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: selectedGroup ==
                                                            "Group A"
                                                        ? const Color.fromARGB(
                                                            255, 107, 89, 161)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Group A",
                                                        style: TextStyle(
                                                          color:
                                                              selectedGroup ==
                                                                      "Group A"
                                                                  ? Colors.white
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      107,
                                                                      89,
                                                                      161),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedGroup = "Group B";
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: selectedGroup ==
                                                            "Group B"
                                                        ? const Color.fromARGB(
                                                            255, 107, 89, 161)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Group B",
                                                          style: TextStyle(
                                                              color: selectedGroup ==
                                                                      "Group B"
                                                                  ? Colors.white
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      107,
                                                                      89,
                                                                      161),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedGroup = "Group C";
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: selectedGroup ==
                                                            "Group C"
                                                        ? const Color.fromARGB(
                                                            255, 107, 89, 161)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Group C",
                                                          style: TextStyle(
                                                              color: selectedGroup ==
                                                                      "Group C"
                                                                  ? Colors.white
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      107,
                                                                      89,
                                                                      161),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return const MatchCard();
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const Spacer(),
                  Container(
                      color: const Color.fromARGB(200, 200, 200, 200),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.tournament['groupedTeams'].isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Group teams first to schedule a match",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScheduleTournamentMatch(
                                                  tournament: widget.tournament,
                                                  type: "schedule")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.white),
                              child: const Text("Schedule Match",
                                  style: TextStyle(
                                      color: Color(0xff554585),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.tournament['groupedTeams'].isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Group teams first to start a match",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScheduleTournamentMatch(
                                                  tournament: widget.tournament,
                                                  type: "start")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: const Color(0xff554585)),
                              child: const Text("Start Match",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ]),
                      )),
                ],
              )
            ],
          );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 235, 235, 245),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                "logo_url",
                                height: 80,
                                width: 80,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 4),
                          const Text("Team A", // 10 characters at max
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                      Image.asset(
                        'assets/images/versus.png',
                        height: 80,
                        width: 80,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                "logo_url",
                                height: 80,
                                width: 80,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 4),
                          const Text("Team B", // 10 characters at max
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                    ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 107, 89, 161)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ground Name",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Match Date And Time",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Share",
                            style: TextStyle(
                                color: Color.fromARGB(255, 107, 89, 161)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
