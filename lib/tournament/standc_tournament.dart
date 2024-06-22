import 'package:flutter/material.dart';

class StandcTournament extends StatefulWidget {
  const StandcTournament({super.key, required this.phone});
  final String phone;

  @override
  State<StandcTournament> createState() => _StandcTournamentState();
}

class _StandcTournamentState extends State<StandcTournament> {
  var about = true;
  var selectedTab = "Points Table";
  var selectedGroup = "Group A";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Standings"), backgroundColor: Colors.white),
        body: SingleChildScrollView(
          child: Stack(children: [
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  "assets/images/ellipse.png",
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                            child: Image.asset(
                          'assets/images/ellipse.png',
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
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  "Standings",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Group B",
                                          style: TextStyle(
                                              color: selectedGroup == "Group B"
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Group C",
                                          style: TextStyle(
                                              color: selectedGroup == "Group C"
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
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 600,
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 200, 200, 200)),
                  child: const Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "#",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 50),
                          Text(
                            "Team Name",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 50),
                          Text(
                            "M",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "W",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "L",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "D",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 50),
                          Text(
                            "Points",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 52),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      HanOver(label: "1"),
                      SizedBox(height: 10),
                      HanOver(label: "2"),
                      SizedBox(height: 10),
                      HanOver(label: "3"),
                      SizedBox(height: 10),
                      HanOver(label: "4"),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ));
  }
}

class HanOver extends StatelessWidget {
  const HanOver({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), color: Colors.white),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
                color: Color.fromARGB(255, 51, 51, 52),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
              radius: 15,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                  child: Image.asset(
                'assets/images/temp.jpg',
                height: 50,
                width: 50,
              ))),
          const SizedBox(width: 20),
          const Text(
            "Munich FC",
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 52),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 40),
          const Text(
            "0",
            style: TextStyle(
                color: Color.fromARGB(255, 51, 51, 52),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              "0",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 52),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              "0",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 52),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: Text(
              "0",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 52),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 50),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "0",
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 52),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
