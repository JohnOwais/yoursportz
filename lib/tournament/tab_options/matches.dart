import 'package:flutter/material.dart';

class Matches extends StatefulWidget {
  const Matches({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  var selectedGroup = "Group A";
  var selectedMatchType = "Live";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(32)),
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
                                    ? const Color.fromARGB(255, 107, 89, 161)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(32)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    ? const Color.fromARGB(255, 107, 89, 161)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(32)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Upcoming",
                                      style: TextStyle(
                                          color: selectedMatchType == "Upcoming"
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
                                    ? const Color.fromARGB(255, 107, 89, 161)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(32)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Past",
                                      style: TextStyle(
                                          color: selectedMatchType == "Past"
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
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(150, 200, 200, 200),
                borderRadius: BorderRadius.circular(16.0)),
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
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Group A",
                                          style: TextStyle(
                                            color: selectedGroup == "Group A"
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
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Group B",
                                            style: TextStyle(
                                                color:
                                                    selectedGroup == "Group B"
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
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Group C",
                                            style: TextStyle(
                                                color:
                                                    selectedGroup == "Group C"
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(26, 70, 68, 68),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Text("Match Name"),
                                const Spacer(),
                                Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 250, 230, 230),
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Text(
                                        "Upcoming",
                                        style: TextStyle(color: Colors.orange),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                color: const Color.fromARGB(255, 107, 89, 161)),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          " Match Date And Time",
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
                                        style: TextStyle(color: Colors.black54),
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
        ],
      ),
    );
  }
}
