// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/ongoing_tournaments.dart';
import 'package:http/http.dart' as http;

class TournamentRules extends StatefulWidget {
  const TournamentRules(
      {super.key,
      required this.phone,
      required this.tournamentId,
      required this.tournamentType});

  final String phone;
  final String tournamentId;
  final String tournamentType;

  @override
  State<TournamentRules> createState() => _TournamentRulesState();
}

class _TournamentRulesState extends State<TournamentRules> {
  var extraTime = false;
  var penaltyKicks = false;
  var goldenGoal = false;
  var isLoading = false;

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
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final body = jsonEncode(<String, dynamic>{
                              'tournamentId': widget.tournamentId,
                              'tournamentType': widget.tournamentType,
                              'tournamentRules': {
                                'extraTime': extraTime,
                                'penaltyKicks': penaltyKicks,
                                'goldenGoal': goldenGoal
                              }
                            });
                            final response = await http.post(
                                Uri.parse(
                                    "https://yoursportzbackend.azurewebsites.net/api/tournament/add-rules/"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                                body: body);
                            final Map<String, dynamic> responseData =
                                jsonDecode(response.body);
                            if (responseData['message'] == "success") {
                              setState(() {
                                isLoading = true;
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => OngoingTournaments(
                                          phone: widget.phone))));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Row(
                                        children: [
                                          Text(
                                              "Tournament Rules Added Successfully",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          SizedBox(width: 8),
                                          Icon(Icons.done_all,
                                              color: Colors.white)
                                        ],
                                      ),
                                      backgroundColor: Colors.green));
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Server Error. Failed to add rules !!!",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3)));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xff554585)),
                          child: isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Transform.scale(
                                    scale: 0.5,
                                    child: const CircularProgressIndicator(
                                        color: Colors.white),
                                  ))
                              : const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text("Done",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
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
