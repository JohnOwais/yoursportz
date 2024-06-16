// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late Map<String, dynamic> liveMatch;
late IO.Socket socket;
var matchStarted = false;
var matchStatus = "pause";

class ScorerView extends StatefulWidget {
  const ScorerView({
    super.key,
    required this.match,
  });

  final Map<String, dynamic> match;

  @override
  State<ScorerView> createState() => _ScorerViewState();
}

class _ScorerViewState extends State<ScorerView> {
  var half = "";
  var timeRemaining = "00:00";
  var teamAGoals = 0;
  var teamBGoals = 0;
  var selectedTeam = "";
  late int teamAballPossession;
  late int teamBballPossession;
  List cardStrings = [
    "Goal",
    "Yellow Card",
    "Red Card",
    "Foul",
    "Throw In",
    "Off Side",
    "Substitution",
    "Corner Kick",
    "Penalty Kick"
  ];
  var serverConnected = false;

  @override
  void initState() {
    setState(() {
      half = "First Half";
      teamAballPossession = 0;
      teamBballPossession = 0;
      timeRemaining = "00:00";
      teamAGoals = 0;
      teamBGoals = 0;
      if (widget.match['kickOff'] == widget.match['teamA']) {
        selectedTeam = "A";
      } else {
        selectedTeam = "B";
      }
      liveMatch = widget.match;
      final teamAPlayers =
          List<Map<String, dynamic>>.from(liveMatch['teamAplayers']);
      for (int i = 0; i < teamAPlayers.length; i++) {
        teamAPlayers[i]['name'] = '${i + 1} - ${teamAPlayers[i]['name']}';
      }
      final teamBPlayers =
          List<Map<String, dynamic>>.from(liveMatch['teamBplayers']);
      for (int i = 0; i < teamBPlayers.length; i++) {
        teamBPlayers[i]['name'] = '${i + 1} - ${teamBPlayers[i]['name']}';
      }
      final teamAsubstitutePlayers =
          List<Map<String, dynamic>>.from(liveMatch['teamAsubstitutePlayers']);
      for (int i = 0; i < teamAsubstitutePlayers.length; i++) {
        teamAsubstitutePlayers[i]['name'] =
            '${i + 1} - ${teamAsubstitutePlayers[i]['name']}';
      }
      final teamBsubstitutePlayers =
          List<Map<String, dynamic>>.from(liveMatch['teamBsubstitutePlayers']);
      for (int i = 0; i < teamBsubstitutePlayers.length; i++) {
        teamBsubstitutePlayers[i]['name'] =
            '${i + 1} - ${teamBsubstitutePlayers[i]['name']}';
      }
    });
    socket =
        IO.io("https://yoursportzbackend.azurewebsites.net/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();
    socket.emit('checkStatus', {'matchId': liveMatch['matchId']});
    socket.on('status', (data) {
      setState(() {
        matchStarted = data['status'];
        timeRemaining = data['time'];
        teamAballPossession = data['teamA'];
        teamBballPossession = data['teamB'];
        half = data['half'];
        teamAGoals = data['teamAGoals'];
        teamBGoals = data['teamBGoals'];
        serverConnected = true;
      });
    });
    socket.on('timer', (data) {
      setState(() {
        timeRemaining = data['time'];
        teamAballPossession = data['teamA'];
        teamBballPossession = data['teamB'];
        half = data['half'];
      });
      if (timeRemaining == "00:01") {
        showDialogBox();
      }
    });
    socket.on('updatedScore', (data) {
      setState(() {
        teamAGoals = data['teamAGoals'];
        teamBGoals = data['teamBGoals'];
      });
    });
    super.initState();
  }

  Future<void> showDialogBox() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      matchStarted = false;
      matchStatus = "pause";
    });
    if (half == "First Half") {
      showDialog(
          context: context,
          builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 32, 0, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_outlined, color: Colors.red),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Text("FIRST HALF OVER",
                                style: TextStyle(fontSize: 20)),
                          ),
                          Icon(Icons.timer_outlined, color: Colors.red),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                socket.emit('startSecondHalf',
                                    {'matchId': liveMatch['matchId']});
                                setState(() {
                                  matchStarted = true;
                                  matchStatus = "ongoing";
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: const Color(0xff554585)),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Text("Begin Second Half",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )));
    } else {
      showDialog(
          context: context,
          builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        color: const Color(0xff554585),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Match Result",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
                      child: teamAGoals == teamBGoals
                          ? const Text("MATCH  IS  DRAW",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                          : Column(
                              children: [
                                Text(
                                    teamAGoals > teamBGoals
                                        ? widget.match['teamA']
                                        : widget.match['teamB'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset(
                                        'assets/images/celebrate_left.png',
                                        height: 30),
                                    const Text("WON THE MATCH",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold)),
                                    Image.asset(
                                        'assets/images/celebrate_right.png',
                                        height: 30),
                                  ],
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              )));
      setState(() {
        serverConnected = false;
      });
      if (teamAGoals == teamBGoals) {
        callForPenaltyKick();
      }
    }
  }

  Future<void> callForPenaltyKick() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pop(context);
    showDialog(context: context, builder: ((context) => const PenaltyKick()));
  }

  @override
  void dispose() {
    if (matchStatus == "ongoing") {
      socket.emit('pauseTimer', {
        'isTrue': false,
        'matchId': liveMatch['matchId'],
        'selectedTeam': selectedTeam,
      });
      setState(() {
        matchStatus = "pause";
        matchStarted = false;
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Scorer"),
              const Spacer(),
              serverConnected
                  ? matchStarted
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // UNDO
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.undo,
                                          color: Colors.white, size: 15),
                                      SizedBox(width: 4),
                                      Text("UNDO",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                if (matchStatus == "ongoing") {
                                  socket.emit('pauseTimer', {
                                    'isTrue': false,
                                    'matchId': liveMatch['matchId'],
                                    'selectedTeam': selectedTeam,
                                  });
                                  setState(() {
                                    matchStatus = "pause";
                                  });
                                } else {
                                  socket.emit('pauseTimer', {
                                    'isTrue': true,
                                    'matchId': liveMatch['matchId'],
                                    'selectedTeam': selectedTeam,
                                  });
                                  setState(() {
                                    matchStatus = "ongoing";
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Icon(
                                          matchStatus == "ongoing"
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 15),
                                      const SizedBox(width: 4),
                                      Text(
                                          matchStatus == "ongoing"
                                              ? "PAUSE"
                                              : "CONTINUE",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            if (half == "First Half") {
                              socket.emit('matchStarted', {
                                'isTrue': true,
                                'matchId': liveMatch['matchId'],
                                'selectedTeam': selectedTeam
                              });
                            } else {
                              socket.emit('startSecondHalf', {
                                'matchId': liveMatch['matchId'],
                                'selectedTeam': selectedTeam
                              });
                            }
                            setState(() {
                              matchStarted = true;
                              matchStatus = "ongoing";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Icon(Icons.play_arrow,
                                      color: Colors.white, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                      half == "First Half"
                                          ? "BEGIN MATCH"
                                          : "BEGIN SECOND HALF",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        )
                  : const SizedBox(),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(half,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.blueGrey)),
                          )),
                    ],
                  ),
                ),
                Text("$teamAGoals - $teamBGoals",
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            child: Text(timeRemaining,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.blueGrey)),
                          )),
                    ],
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Card(
                color: Colors.cyan,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                    child: Image.network(
                                  widget.match['teamALogo'],
                                  height: 50,
                                  width: 50,
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
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/app_logo.png',
                                      height: 50,
                                    );
                                  },
                                ))),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Text("Ball Possession"),
                                )),
                            CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                    child: Image.network(
                                  widget.match['teamBLogo'],
                                  height: 50,
                                  width: 50,
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
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/app_logo.png',
                                      height: 50,
                                    );
                                  },
                                ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Team A:   ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: selectedTeam == "A"
                                              ? FontWeight.bold
                                              : null)),
                                  Text(
                                      matchStarted &&
                                              (teamAballPossession +
                                                      teamBballPossession !=
                                                  0)
                                          ? "${(teamAballPossession / (teamAballPossession + teamBballPossession) * 100).toStringAsFixed(0)}%"
                                          : "0%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: selectedTeam == "A"
                                              ? FontWeight.bold
                                              : null))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Team B:   ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: selectedTeam == "B"
                                              ? FontWeight.bold
                                              : null)),
                                  Text(
                                      matchStarted &&
                                              (teamAballPossession +
                                                      teamBballPossession !=
                                                  0)
                                          ? "${(teamBballPossession / (teamAballPossession + teamBballPossession) * 100).toStringAsFixed(0)}%"
                                          : "0%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: selectedTeam == "B"
                                              ? FontWeight.bold
                                              : null))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return ActionCard(index: index, label: cardStrings[index]);
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text("Ball Possession Controller",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTeam = "A";
                                });
                                if (matchStatus == "ongoing") {
                                  socket.emit('ballPossession', {
                                    'matchId': liveMatch['matchId'],
                                    'selectedTeam': "A"
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedTeam == "A"
                                      ? const Color.fromARGB(255, 220, 240, 255)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selectedTeam == "A"
                                          ? Colors.blue
                                          : Colors.white,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                              child: Image.network(
                                            widget.match['teamALogo'],
                                            height: 50,
                                            width: 50,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child:
                                                      CircularProgressIndicator(
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
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/app_logo.png',
                                                height: 50,
                                              );
                                            },
                                          ))),
                                      Text("Team A",
                                          style: TextStyle(
                                              color: selectedTeam == "A"
                                                  ? Colors.black
                                                  : Colors.blueGrey,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                          widget.match['teamA'].length <= 15
                                              ? widget.match['teamA']
                                              : "${widget.match['teamA'].substring(0, 15)}...",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: selectedTeam == "A"
                                                  ? Colors.black
                                                  : Colors.blueGrey,
                                              fontSize: 15)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTeam = "B";
                                });
                                if (matchStatus == "ongoing") {
                                  socket.emit('ballPossession', {
                                    'matchId': liveMatch['matchId'],
                                    'selectedTeam': "B"
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedTeam == "B"
                                      ? const Color.fromARGB(255, 220, 240, 255)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selectedTeam == "B"
                                          ? Colors.blue
                                          : Colors.white,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                              child: Image.network(
                                            widget.match['teamBLogo'],
                                            height: 50,
                                            width: 50,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child:
                                                      CircularProgressIndicator(
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
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/app_logo.png',
                                                height: 50,
                                              );
                                            },
                                          ))),
                                      Text("Team B",
                                          style: TextStyle(
                                              color: selectedTeam == "B"
                                                  ? Colors.black
                                                  : Colors.blueGrey,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                          widget.match['teamB'].length <= 15
                                              ? widget.match['teamB']
                                              : "${widget.match['teamB'].substring(0, 15)}...",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: selectedTeam == "B"
                                                  ? Colors.black
                                                  : Colors.blueGrey,
                                              fontSize: 15)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ]),
        ));
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.index, required this.label});

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Goal':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Yellow Card':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Red Card':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Foul':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Throw In':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Off Side':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Substitution':
            showDialog(
                context: context,
                builder: ((context) =>
                    Substitution(index: index, card: label)));
            break;
          case 'Corner Kick':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
          case 'Penalty Kick':
            showDialog(
                context: context,
                builder: ((context) => Action(index: index, card: label)));
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
            child: Column(
          children: [
            Image.asset('assets/images/icon$index.png', height: 70, width: 70),
            Text(label, style: const TextStyle(color: Colors.blueGrey))
          ],
        )),
      ),
    );
  }
}

class PenaltyKick extends StatefulWidget {
  const PenaltyKick({super.key});

  @override
  State<PenaltyKick> createState() => _PenaltyKickState();
}

class _PenaltyKickState extends State<PenaltyKick> {
  List<Widget> selectedTeamAplayers = [];
  List<Widget> selectedTeamBplayers = [];
  var teamAplayers = [];
  var teamBplayers = [];
  var isValid = true;

  @override
  void initState() {
    setState(() {
      teamAplayers = List.from(liveMatch['teamAplayers']);
      teamBplayers = List.from(liveMatch['teamBplayers']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Penalty Kick", style: TextStyle(fontSize: 20)),
          ),
          const Divider(),
          isValid
              ? const SizedBox()
              : Container(
                  color: Colors.red,
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("Select 5 Players From Each Team",
                              style: TextStyle(color: Colors.white)),
                        )
                      ]),
                ),
          Column(
            children: [
              selectedTeamAplayers.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Players from - ${liveMatch['teamA']}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedTeamAplayers),
              ),
              selectedTeamAplayers.length < 5
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              hint: Text(liveMatch['teamA']),
                              value: null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  isValid = true;
                                  selectedTeamAplayers.add(Row(
                                    children: [
                                      Expanded(
                                        child: Text(newValue![1] == " "
                                            ? newValue.substring(4)
                                            : newValue.substring(5)),
                                      ),
                                    ],
                                  ));
                                  teamAplayers.removeWhere(
                                      (player) => player['name'] == newValue);
                                });
                              },
                              items: teamAplayers.map<DropdownMenuItem<String>>(
                                  (dynamic player) {
                                return DropdownMenuItem<String>(
                                  value: player['name'] as String,
                                  child: Text(player['name'].length <= 10
                                      ? player['name']
                                      : player['name']
                                          .toString()
                                          .substring(0, 10)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: 16),
              selectedTeamBplayers.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Players from - ${liveMatch['teamB']}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: selectedTeamBplayers),
              ),
              selectedTeamBplayers.length < 5
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              hint: Text(liveMatch['teamB']),
                              value: null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  isValid = true;
                                  selectedTeamBplayers.add(Row(
                                    children: [
                                      Expanded(
                                        child: Text(newValue![1] == " "
                                            ? newValue.substring(4)
                                            : newValue.substring(5)),
                                      ),
                                    ],
                                  ));
                                  teamBplayers.removeWhere(
                                      (player) => player['name'] == newValue);
                                });
                              },
                              items: teamBplayers.map<DropdownMenuItem<String>>(
                                  (dynamic player) {
                                return DropdownMenuItem<String>(
                                  value: player['name'] as String,
                                  child: Text(player['name'].length <= 10
                                      ? player['name']
                                      : player['name']
                                          .toString()
                                          .substring(0, 10)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: 16),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTeamAplayers.length < 5 ||
                        selectedTeamBplayers.length < 5) {
                      setState(() {
                        isValid = false;
                      });
                    } else {
                      Navigator.pop(context);
                      socket.emit('penaltyKick', {
                        'matchId': liveMatch['matchId'],
                        'data': {
                          'teamAplayers': selectedTeamAplayers,
                          'teamBplayers': selectedTeamBplayers,
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Row(
                            children: [
                              Text("Five players choosen from each team",
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.done_all, color: Colors.white)
                            ],
                          ),
                          backgroundColor: Colors.green));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff554585)),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Text("Done",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}

class Action extends StatefulWidget {
  const Action({super.key, required this.index, required this.card});

  final int index;
  final String card;

  @override
  State<Action> createState() => _ActionState();
}

class _ActionState extends State<Action> {
  String? teamSelected;
  String? selectedPlayer;
  String? selectedAssistant;
  String? goalArea;
  String? corner;
  String goalStatus = "";
  String? selectedReferee;
  var players = liveMatch['teamAplayers'];
  var referees = liveMatch['referee'];
  var showPlayers = false;
  var message = "";

  @override
  void initState() {
    referees.removeWhere((referee) => referee['phone'] == "null");
    super.initState();
  }

  void switchPlayers(String team) {
    if (team == liveMatch['teamA']) {
      setState(() {
        players = liveMatch['teamAplayers'];
      });
    } else {
      setState(() {
        players = liveMatch['teamBplayers'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(widget.card, style: const TextStyle(fontSize: 20)),
          ),
          const Divider(),
          message == ""
              ? const SizedBox()
              : Container(
                  color: Colors.red,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(message,
                              style: const TextStyle(color: Colors.white)),
                        )
                      ]),
                ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Select Team'),
                    value: teamSelected,
                    onChanged: (String? newValue) {
                      setState(() {
                        teamSelected = newValue!;
                        selectedPlayer = null;
                        selectedAssistant = null;
                        switchPlayers(teamSelected == liveMatch['teamA']
                            ? liveMatch['teamA']
                            : liveMatch['teamB']);
                        showPlayers = true;
                      });
                    },
                    items: <String>[liveMatch['teamA'], liveMatch['teamB']]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          showPlayers
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: const Text('Select Player'),
                          value: selectedPlayer,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPlayer = newValue!;
                            });
                          },
                          items: players
                              .map<DropdownMenuItem<String>>((dynamic player) {
                            return DropdownMenuItem<String>(
                              value: player['name'] as String,
                              child: Text(player['name'] as String),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          showPlayers && widget.index == 0
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text('Assist By'),
                              value: selectedAssistant,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedAssistant = newValue!;
                                });
                              },
                              items: players.map<DropdownMenuItem<String>>(
                                  (dynamic player) {
                                return DropdownMenuItem<String>(
                                  value: player['name'] as String,
                                  child: Text(player['name'] as String),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: goalArea != null
                                    ? Colors.white
                                    : Colors.grey[200],
                                elevation: goalArea != null ? 0 : null),
                            onPressed: () {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                        backgroundColor: Colors.green,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/bg.jpg'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 30, 0, 30),
                                              child: Column(children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Corner Arc";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Penalty Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Goal Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Penalty Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Corner Arc";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Left Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Center Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Right Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Left Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Center Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Right Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Left Halfway Line";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Center Circle";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Right Halfway Line";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Right Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Center Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Left Midfield";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Right Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Center Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Left Defence";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Corner Arc";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Penalty Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Goal Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Penalty Area";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                goalArea =
                                                                    "Corner Arc";
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Area()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ))));
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    goalArea != null
                                        ? goalArea!
                                        : "Select Goal Area",
                                    style: TextStyle(
                                        color: goalArea != null
                                            ? Colors.black
                                            : const Color(0xff554585),
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                goalStatus = "missed";
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                          goalStatus == "missed"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: Colors.white,
                                          size: 15),
                                      const SizedBox(width: 4),
                                      const Text("MISSED",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                goalStatus = "saved";
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                          goalStatus == "saved"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: Colors.white,
                                          size: 15),
                                      const SizedBox(width: 4),
                                      const Text("SAVED",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                goalStatus = "goal";
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                          goalStatus == "goal"
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: Colors.white,
                                          size: 15),
                                      const SizedBox(width: 4),
                                      const Text("GOAL",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          showPlayers && widget.index == 7
              ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: corner != null
                                ? Colors.white
                                : Colors.grey[200],
                            elevation: corner != null ? 0 : null),
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                    backgroundColor: Colors.green,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/bg.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 30, 0, 30),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          corner =
                                                              "Left Corner";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Corner()),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          corner =
                                                              "Right Corner";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Corner()),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          corner =
                                                              "Right Corner";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Corner()),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          corner =
                                                              "Left Corner";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Corner()),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ))));
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                corner != null ? corner! : "Select Corner",
                                style: TextStyle(
                                    color: corner != null
                                        ? Colors.black
                                        : const Color(0xff554585),
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          widget.index == 7 && referees.isEmpty
              ? const SizedBox(height: 16)
              : const SizedBox(),
          showPlayers && referees.isNotEmpty && widget.index != 0
              ? referees.length == 1
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              const Text("Referee: ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 17)),
                              Text(referees[0]['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text('Select Referee'),
                              value: selectedReferee,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedReferee = newValue!;
                                });
                              },
                              items: referees.map<DropdownMenuItem<String>>(
                                  (dynamic referee) {
                                return DropdownMenuItem<String>(
                                  value: referee['name'] as String,
                                  child: Text(referee['name'] as String),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
              : const SizedBox(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (matchStarted && matchStatus == "ongoing") {
                      if (widget.index == 0) {
                        if (selectedPlayer != null &&
                            selectedAssistant != null &&
                            goalArea != null &&
                            goalStatus != "") {
                          socket.emit('updateScore', {
                            'id': widget.index,
                            'matchId': liveMatch['matchId'],
                            'data': {
                              'team': teamSelected,
                              'goalScorer': selectedPlayer,
                              'assistBy': selectedAssistant,
                              'goalArea': goalArea,
                              'goalStatus': goalStatus,
                            }
                          });
                        } else {
                          setState(() {
                            message = "All Fields Are Mandatory";
                          });
                          await Future.delayed(const Duration(seconds: 3));
                          setState(() {
                            message = "";
                          });
                          return;
                        }
                      } else if (widget.index == 7) {
                        if (selectedPlayer != null &&
                            corner != null &&
                            (referees.length == 2
                                ? selectedReferee != null
                                : true)) {
                          socket.emit('updateScore', {
                            'id': widget.index,
                            'matchId': liveMatch['matchId'],
                            'data': {
                              'team': teamSelected,
                              'player': selectedPlayer,
                              'corner': corner,
                              'referee': referees.isNotEmpty
                                  ? referees.length == 1
                                      ? referees[0]['name']
                                      : selectedReferee
                                  : "default"
                            }
                          });
                        } else {
                          setState(() {
                            message = "All Fields Are Mandatory";
                          });
                          await Future.delayed(const Duration(seconds: 3));
                          setState(() {
                            message = "";
                          });
                          return;
                        }
                      } else {
                        if (selectedPlayer != null &&
                            (referees.length == 2
                                ? selectedReferee != null
                                : true)) {
                          socket.emit('updateScore', {
                            'id': widget.index,
                            'matchId': liveMatch['matchId'],
                            'data': {
                              'team': teamSelected,
                              'player': selectedPlayer,
                              'referee': referees.isNotEmpty
                                  ? referees.length == 1
                                      ? referees[0]['name']
                                      : selectedReferee
                                  : "default"
                            }
                          });
                        } else {
                          setState(() {
                            message = "All Fields Are Mandatory";
                          });
                          await Future.delayed(const Duration(seconds: 3));
                          setState(() {
                            message = "";
                          });
                          return;
                        }
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.card,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      widget.index == 0
                                          ? goalStatus == "goal"
                                              ? " scored by "
                                              : goalStatus == "saved"
                                                  ? " tried by "
                                                  : " missed by "
                                          : " given to ",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text(
                                      selectedPlayer![1] == " "
                                          ? selectedPlayer!.substring(4)
                                          : selectedPlayer!.substring(5),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.index == 0 ? "of " : "from ",
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  Text(teamSelected!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              widget.index == 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("from ",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(goalArea!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          backgroundColor: goalStatus == "goal" ||
                                  widget.index == 4 ||
                                  widget.index == 5 ||
                                  widget.index == 7 ||
                                  widget.index == 8
                              ? Colors.green
                              : Colors.red,
                          duration: const Duration(seconds: 5)));
                    } else {
                      setState(() {
                        message = "Match Not Started Yet";
                      });
                      await Future.delayed(const Duration(seconds: 3));
                      setState(() {
                        message = "";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff554585)),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Text("Done",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}

class Area extends StatelessWidget {
  const Area({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.yellowAccent)),
        child: const Center(
            child: Text("", style: TextStyle(color: Colors.transparent))),
      ),
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.yellowAccent)),
      child: const Center(
          child: Text("", style: TextStyle(color: Colors.transparent))),
    );
  }
}

class Substitution extends StatefulWidget {
  const Substitution({super.key, required this.index, required this.card});

  final int index;
  final String card;

  @override
  State<Substitution> createState() => _SubstitutionState();
}

class _SubstitutionState extends State<Substitution> {
  String? teamSelected;
  String? selectedPlayer;
  String? selectedReplacement;
  var players = liveMatch['teamAplayers'];
  var substitutions = liveMatch['teamAsubstitutePlayers'];
  var showPlayers = false;
  var message = "";

  void switchPlayers(String team) {
    if (team == liveMatch['teamA']) {
      setState(() {
        players = liveMatch['teamAplayers'];
        substitutions = liveMatch['teamAsubstitutePlayers'];
      });
    } else {
      setState(() {
        players = liveMatch['teamBplayers'];
        substitutions = liveMatch['teamBsubstitutePlayers'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(widget.card, style: const TextStyle(fontSize: 20)),
          ),
          const Divider(),
          message == ""
              ? const SizedBox()
              : Container(
                  color: Colors.red,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(message,
                              style: const TextStyle(color: Colors.white)),
                        )
                      ]),
                ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    hint: const Text('Select Team'),
                    value: teamSelected,
                    onChanged: (String? newValue) {
                      setState(() {
                        teamSelected = newValue!;
                        selectedPlayer = null;
                        selectedReplacement = null;
                        switchPlayers(teamSelected == liveMatch['teamA']
                            ? liveMatch['teamA']
                            : liveMatch['teamB']);
                        showPlayers = true;
                      });
                    },
                    items: <String>[liveMatch['teamA'], liveMatch['teamB']]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          showPlayers
              ? substitutions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                      child: Text("No Substitute Player",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text('Replace'),
                              value: selectedPlayer,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPlayer = newValue!;
                                });
                              },
                              items: players.map<DropdownMenuItem<String>>(
                                  (dynamic player) {
                                return DropdownMenuItem<String>(
                                  value: player['name'] as String,
                                  child: Text(player['name'].length <= 10
                                      ? player['name']
                                      : player['name']
                                          .toString()
                                          .substring(0, 10)),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              hint: const Text('Replacement'),
                              value: selectedReplacement,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedReplacement = newValue!;
                                });
                              },
                              items: substitutions
                                  .map<DropdownMenuItem<String>>(
                                      (dynamic substitution) {
                                return DropdownMenuItem<String>(
                                  value: substitution['name'] as String,
                                  child: Text(substitution['name'].length <= 10
                                      ? substitution['name']
                                      : substitution['name']
                                          .toString()
                                          .substring(0, 10)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
              : const SizedBox(),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (matchStarted && matchStatus == "ongoing") {
                      if (selectedPlayer != null &&
                          selectedReplacement != null) {
                        socket.emit('updateScore', {
                          'id': widget.index,
                          'matchId': liveMatch['matchId'],
                          'data': {
                            'team': teamSelected,
                            'replace': selectedPlayer,
                            'replacement': selectedReplacement,
                          }
                        });
                      } else {
                        setState(() {
                          message = "All Fields Are Mandatory";
                        });
                        await Future.delayed(const Duration(seconds: 3));
                        setState(() {
                          message = "";
                        });
                        return;
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      selectedPlayer![1] == " "
                                          ? selectedPlayer!.substring(4)
                                          : selectedPlayer!.substring(5),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                  const Text(" replaced by ",
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                      selectedReplacement![1] == " "
                                          ? selectedReplacement!.substring(4)
                                          : selectedReplacement!.substring(5),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("from ",
                                      style: TextStyle(color: Colors.white)),
                                  Text(teamSelected!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 5)));
                    } else {
                      setState(() async {
                        setState(() {
                          message = "Match Not Started Yet";
                        });
                        await Future.delayed(const Duration(seconds: 3));
                        setState(() {
                          message = "";
                        });
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff554585)),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Text("Done",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}
