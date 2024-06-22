import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/addteam_tournament.dart';

class TournamentRules extends StatefulWidget {
  const TournamentRules({super.key, required String phone});

  @override
  State<TournamentRules> createState() => _TournamentRulesState();
}

class _TournamentRulesState extends State<TournamentRules> {
  var extraTime = false;
  var penaltyKicks = false;
  var goldenGoal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 245),
      appBar: AppBar(
        title: const Text('Match Rules'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 65),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          extraTime = !extraTime;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: extraTime
                              ? const Color.fromARGB(255, 107, 89, 161)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                Icon(
                                    extraTime
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: extraTime
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 107, 89, 161)),
                              ],
                            ),
                            Icon(Icons.timer,
                                size: 100,
                                color: extraTime
                                    ? Colors.white
                                    : const Color.fromARGB(255, 107, 89, 161)),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('Extra Time',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: extraTime
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 107, 89, 161))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          penaltyKicks = !penaltyKicks;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: penaltyKicks
                              ? const Color.fromARGB(255, 107, 89, 161)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                Icon(
                                    penaltyKicks
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: penaltyKicks
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 107, 89, 161)),
                              ],
                            ),
                            Icon(Icons.sports_gymnastics,
                                size: 100,
                                color: penaltyKicks
                                    ? Colors.white
                                    : const Color.fromARGB(255, 107, 89, 161)),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('Penalty Kicks',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: penaltyKicks
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 107, 89, 161))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          goldenGoal = !goldenGoal;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: goldenGoal
                              ? const Color.fromARGB(255, 107, 89, 161)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                Icon(
                                    goldenGoal
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: goldenGoal
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 107, 89, 161)),
                              ],
                            ),
                            Icon(Icons.sports_soccer,
                                size: 100,
                                color: goldenGoal
                                    ? Colors.white
                                    : const Color.fromARGB(255, 107, 89, 161)),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('Golden Goal',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: goldenGoal
                                          ? Colors.white
                                          : const Color.fromARGB(
                                              255, 107, 89, 161))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Container(
                color: const Color.fromARGB(255, 235, 235, 245),
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
                                        const AddteamTournament(
                                            phone: '919149764646'))));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xff554585)),
                          child: const Text('Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
