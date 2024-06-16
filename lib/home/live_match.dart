// ignore_for_file: empty_catches, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late IO.Socket socket;
var teamAGoals = 0;
var teamBGoals = 0;
List<Map<String, dynamic>> overviewStats = [];
List<String> commentaryStats = [];

class LiveMatch extends StatefulWidget {
  const LiveMatch({super.key, required this.match});

  final Map<String, dynamic> match;

  @override
  State<LiveMatch> createState() => _LiveMatchState();
}

class _LiveMatchState extends State<LiveMatch> {
  var selectedOption = "Overview";
  var showStats = false;
  final overviewScrollController = ScrollController();
  final commentaryScrollController = ScrollController();

  @override
  void initState() {
    setState(() {
      teamAGoals = widget.match['teamAgoals'];
      teamBGoals = widget.match['teamBgoals'];
      overviewStats = [];
      commentaryStats = [];
      showStats = true;
    });
    socket =
        IO.io("https://yoursportzbackend.azurewebsites.net/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();
    showMatchStats();
    socket.on('matchStats', (data) {
      setState(() {
        teamAGoals = data['teamAGoals'];
        teamBGoals = data['teamBGoals'];
        overviewStats = List<Map<String, dynamic>>.from(data['overviewEvents']);
        commentaryStats = List<String>.from(data['commentaryEvents']);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        overviewScrollController
            .jumpTo(overviewScrollController.position.maxScrollExtent);
      });
    });
    super.initState();
  }

  void showMatchStats() async {
    if (showStats) {
      socket.emit('getMatchStats', {'matchId': widget.match['matchId']});
      await Future.delayed(const Duration(seconds: 2));
      try {
        commentaryScrollController
            .jumpTo(commentaryScrollController.position.maxScrollExtent);
      } catch (e) {}
      await Future.delayed(const Duration(seconds: 3));
      showMatchStats();
    }
  }

  @override
  void dispose() {
    setState(() {
      showStats = false;
    });
    overviewScrollController.dispose();
    commentaryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text("Game Summary"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                          widget.match['teamALogo'],
                          height: 70,
                          width: 70,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                              height: 70,
                            );
                          },
                        ))),
                    Text(
                        widget.match['teamA'].length <= 12
                            ? widget.match['teamA']
                            : widget.match['teamA'].toString().substring(0, 12),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))
                  ],
                ),
                Text("$teamAGoals - $teamBGoals",
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Column(
                  children: [
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                            child: Image.network(
                          widget.match['teamBLogo'],
                          height: 70,
                          width: 70,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                              height: 70,
                            );
                          },
                        ))),
                    Text(
                        widget.match['teamB'].length <= 12
                            ? widget.match['teamB']
                            : widget.match['teamB'].toString().substring(0, 12),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: selectedOption == "Overview"
                            ? Colors.blue
                            : Colors.white),
                    onPressed: () async {
                      setState(() {
                        selectedOption = "Overview";
                      });
                      await Future.delayed(const Duration(seconds: 1));
                      overviewScrollController.jumpTo(
                          overviewScrollController.position.maxScrollExtent);
                    },
                    child: Text("Overview",
                        style: TextStyle(
                            color: selectedOption == "Overview"
                                ? Colors.white
                                : Colors.blue))),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        backgroundColor: selectedOption == "Commentary"
                            ? Colors.blue
                            : Colors.white),
                    onPressed: () async {
                      setState(() {
                        selectedOption = "Commentary";
                      });
                      await Future.delayed(const Duration(seconds: 1));
                      commentaryScrollController.jumpTo(
                          commentaryScrollController.position.maxScrollExtent);
                    },
                    child: Text("Commentary",
                        style: TextStyle(
                            color: selectedOption == "Commentary"
                                ? Colors.white
                                : Colors.blue))),
              ),
            ],
          ),
          selectedOption == "Overview"
              ? Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        controller: overviewScrollController,
                        reverse: true,
                        itemCount: overviewStats.length,
                        itemBuilder: (context, index) {
                          final overview = overviewStats[index];
                          return OverviewCard(
                              overview: overview,
                              teamA: widget.match['teamA'],
                              teamB: widget.match['teamB']);
                        },
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        controller: commentaryScrollController,
                        reverse: true,
                        itemCount: commentaryStats.length,
                        itemBuilder: (context, index) {
                          final commentary = commentaryStats[index];
                          return CommentaryCard(commentary: commentary);
                        },
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class CommentaryCard extends StatelessWidget {
  const CommentaryCard({
    super.key,
    required this.commentary,
  });

  final String commentary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text("✤ $commentary", style: const TextStyle(fontSize: 15)),
    );
  }
}

class OverviewCard extends StatefulWidget {
  const OverviewCard(
      {super.key,
      required this.overview,
      required this.teamA,
      required this.teamB});

  final Map<String, dynamic> overview;
  final String teamA;
  final String teamB;

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.overview['teamName'] == widget.teamA
          ? const EdgeInsetsDirectional.fromSTEB(0, 8, 120, 8)
          : const EdgeInsetsDirectional.fromSTEB(120, 8, 0, 8),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: widget.overview['teamName'] == widget.teamA
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: widget.overview['teamName'] == widget.teamA
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/dp.png', height: 20),
                const SizedBox(width: 8),
                Text(widget.overview['playerName'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Text(widget.overview['eventString'],
                textAlign: widget.overview['teamName'] == widget.teamA
                    ? TextAlign.start
                    : TextAlign.end,
                style: const TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
