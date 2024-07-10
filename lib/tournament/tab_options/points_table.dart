import 'package:flutter/material.dart';

class PointsTable extends StatefulWidget {
  const PointsTable({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<PointsTable> createState() => _PointsTableState();
}

class _PointsTableState extends State<PointsTable> {
  var selectedTab = "Points Table";
  var selectedGroup = "Group A";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
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
                                ? const Color.fromARGB(255, 107, 89, 161)
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
                                      : const Color.fromARGB(255, 107, 89, 161),
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
                                ? const Color.fromARGB(255, 107, 89, 161)
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
                                ? const Color.fromARGB(255, 107, 89, 161)
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color.fromARGB(150, 200, 200, 200),
                borderRadius: BorderRadius.circular(16.0)),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "#",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Team Name",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "M",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "W",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "L",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "D",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Points",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 51, 52),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Team(label: "1"),
                Team(label: "2"),
                Team(label: "3"),
                Team(label: "4"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Team extends StatelessWidget {
  const Team({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
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
                  'assets/images/app_icon.png',
                  height: 50,
                  width: 50,
                ))),
            const SizedBox(width: 20),
            const Text(
              "Hanover FC",
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
            const Spacer(),
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
      ),
    );
  }
}
