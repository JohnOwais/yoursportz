import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/stand_tournament.dart';

class NamecardTournament extends StatefulWidget {
  const NamecardTournament({super.key, required String phone});

  @override
  State<NamecardTournament> createState() => _NamecardTournamentState();
}

class _NamecardTournamentState extends State<NamecardTournament> {
  var selectedTab = "Points Table";
  var selectedGroup = "Group A";
  var selectedMatchType = "Live";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 233, 243, 248),
        ),
        body: SingleChildScrollView(
            child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(26, 70, 68, 68)),
          child: Stack(children: [
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  "assets/images/tournament_bg.png",
                  fit: BoxFit.cover,
                )),
            Column(children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                          child: Image.asset(
                        'assets/images/tournament_bg.png',
                        height: 70,
                        width: 70,
                      ))),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tournament Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text(
                              "Location",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Date",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text("About",
                                    style: TextStyle(
                                        color: selectedTab == "About"
                                            ? Colors.white
                                            : Colors.grey[700])),
                              ))),
                      const SizedBox(width: 20),
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
                      const SizedBox(width: 20),
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
                      const SizedBox(width: 20),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
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
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Live",
                                          style: TextStyle(
                                            color: selectedMatchType == "Live"
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
                                      color: selectedMatchType == "Upcoming"
                                          ? const Color.fromARGB(
                                              255, 107, 89, 161)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Upcoming",
                                            style: TextStyle(
                                                color: selectedMatchType ==
                                                        "Upcoming"
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                        255, 107, 89, 161),
                                                fontWeight: FontWeight.bold)),
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
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Past",
                                            style: TextStyle(
                                                color:
                                                    selectedMatchType == "Past"
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 107, 89, 161),
                                                fontWeight: FontWeight.bold)),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(150, 200, 200, 200),
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            color: selectedGroup == "Group A"
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
                                                "Group A",
                                                style: TextStyle(
                                                  color: selectedGroup ==
                                                          "Group A"
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
                                        selectedGroup = "Group B";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedGroup == "Group B"
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
                                              Text("Group B",
                                                  style: TextStyle(
                                                      color: selectedGroup ==
                                                              "Group B"
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
                                        selectedGroup = "Group C";
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: selectedGroup == "Group C"
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
                                              Text("Group C",
                                                  style: TextStyle(
                                                      color: selectedGroup ==
                                                              "Group C"
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(26, 70, 68, 68),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Text("Match Name"),
                                      const Spacer(),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 244, 224, 224),
                                              borderRadius:
                                                  BorderRadius.circular(32)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Group B",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 245, 11, 11)),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.transparent,
                                            child: ClipOval(
                                                child: Image.asset(
                                              'assets/images/h1.png',
                                              height: 100,
                                              width: 100,
                                            ))),
                                        Image.asset(
                                          'assets/images/versus.png',
                                          height: 100,
                                          width: 100,
                                        ),
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.transparent,
                                            child: ClipOval(
                                                child: Image.asset(
                                              'assets/images/h2.png',
                                              height: 100,
                                              width: 100,
                                            ))),
                                      ]),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color.fromARGB(
                                          255, 107, 89, 161)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Match Venue ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                " Match Date And Time",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          const StandTournament(
                                                              phone:
                                                                  '919149764646'))));
                                            },
                                            child: const Text(
                                              "Share",
                                              style: TextStyle(
                                                  color: Colors.black54),
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
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ]),
        )));
  }
}
