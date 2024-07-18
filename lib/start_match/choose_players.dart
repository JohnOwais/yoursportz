import 'package:flutter/material.dart';
import 'package:yoursportz/start_match/match_officials.dart';

class ChoosePlayers extends StatefulWidget {
  const ChoosePlayers(
      {super.key,
      required this.team1,
      required this.team2,
      required this.team1players,
      required this.team2players,
      required this.totalPlayers,
      required this.team1Logo,
      required this.team2Logo,
      required this.ground});

  final String team1;
  final String team2;
  final List<Map<String, dynamic>> team1players;
  final List<Map<String, dynamic>> team2players;
  final String totalPlayers;
  final String team1Logo;
  final String team2Logo;
  final Map ground;

  @override
  State<ChoosePlayers> createState() => _ChoosePlayersState();
}

class _ChoosePlayersState extends State<ChoosePlayers> {
  late List<Map<String, dynamic>> firstTeamPlayers;
  late List<Map<String, dynamic>> secondTeamPlayers;
  var firstTeamSubstitutePlayers = <Map<String, dynamic>>[];
  var secondTeamSubstitutePlayers = <Map<String, dynamic>>[];
  var playersSelected = 0;
  var firstTeamPlayerSelection = false;
  var firstTeamGoalKeeper = false;
  var secondTeamGoalKeeper = false;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    firstTeamPlayers = List<Map<String, dynamic>>.from(widget.team1players);
    secondTeamPlayers = List<Map<String, dynamic>>.from(widget.team2players);
    for (var player in firstTeamPlayers) {
      player['selected'] = false;
    }
    for (var player in secondTeamPlayers) {
      player['selected'] = false;
    }
    super.initState();
  }

  void navigate2secondTeam() {
    setState(() {
      firstTeamPlayerSelection = true;
      playersSelected = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select ${widget.totalPlayers} Players for:",
                style: const TextStyle(fontSize: 18)),
            Text(firstTeamPlayerSelection ? widget.team2 : widget.team1,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: controller,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: firstTeamPlayerSelection
                    ? secondTeamPlayers.length
                    : firstTeamPlayers.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (!firstTeamPlayerSelection) {
                        if (firstTeamGoalKeeper &&
                            firstTeamPlayers[index]['position'] ==
                                "Goalkeeper" &&
                            !firstTeamPlayers[index]['selected']) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Can't choose multiple Goalkeepers",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3)));
                          return;
                        }
                      } else {
                        if (secondTeamGoalKeeper &&
                            secondTeamPlayers[index]['position'] ==
                                "Goalkeeper" &&
                            !secondTeamPlayers[index]['selected']) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Can't choose multiple Goalkeepers",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3)));
                          return;
                        }
                      }
                      if (firstTeamPlayerSelection
                          ? secondTeamPlayers[index]['selected'] ||
                              playersSelected < int.parse(widget.totalPlayers)
                          : firstTeamPlayers[index]['selected'] ||
                              playersSelected <
                                  int.parse(widget.totalPlayers)) {
                        setState(() {
                          firstTeamPlayerSelection
                              ? secondTeamPlayers[index]['selected'] =
                                  !secondTeamPlayers[index]['selected']
                              : firstTeamPlayers[index]['selected'] =
                                  !firstTeamPlayers[index]['selected'];
                          if (firstTeamPlayerSelection
                              ? secondTeamPlayers[index]['selected']
                              : firstTeamPlayers[index]['selected']) {
                            playersSelected++;
                            if (!firstTeamPlayerSelection) {
                              if (firstTeamPlayers[index]['position'] ==
                                  "Goalkeeper") firstTeamGoalKeeper = true;
                            } else {
                              if (secondTeamPlayers[index]['position'] ==
                                  "Goalkeeper") secondTeamGoalKeeper = true;
                            }
                          } else {
                            if (!firstTeamPlayerSelection) {
                              if (firstTeamPlayers[index]['position'] ==
                                  "Goalkeeper") firstTeamGoalKeeper = false;
                            } else {
                              if (secondTeamPlayers[index]['position'] ==
                                  "Goalkeeper") secondTeamGoalKeeper = false;
                            }

                            playersSelected--;
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Can't add more players",
                              style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.orange,
                        ));
                      }
                    },
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                  child: Image.network(
                                    firstTeamPlayerSelection
                                        ? secondTeamPlayers[index]['dp'] ?? ""
                                        : firstTeamPlayers[index]['dp'] ?? "",
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
                                          padding: const EdgeInsets.all(20),
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
                                        'assets/images/dp.png',
                                        height: 50,
                                        width: 50,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Spacer(),
                              firstTeamPlayerSelection
                                  ? (secondTeamPlayers[index]['selected']
                                      ? const Icon(Icons.check_box,
                                          color: Color(0xff554585))
                                      : const Icon(
                                          Icons.check_box_outline_blank,
                                          color: Color(0xff554585)))
                                  : (firstTeamPlayers[index]['selected']
                                      ? const Icon(Icons.check_box,
                                          color: Color(0xff554585))
                                      : const Icon(
                                          Icons.check_box_outline_blank,
                                          color: Color(0xff554585))),
                              const SizedBox(width: 16)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Text(
                              firstTeamPlayerSelection
                                  ? secondTeamPlayers[index]['name']
                                  : firstTeamPlayers[index]['name'],
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    size: 13, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  firstTeamPlayerSelection
                                      ? secondTeamPlayers[index]['city']
                                      : firstTeamPlayers[index]['city'],
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: const Text("Player Position"),
                                    value: firstTeamPlayerSelection
                                        ? secondTeamPlayers[index]['position']
                                        : firstTeamPlayers[index]['position'],
                                    onChanged: (String? value) {
                                      setState(() {
                                        if (!firstTeamPlayerSelection) {
                                          if (firstTeamPlayers[index]
                                                      ['position'] ==
                                                  "Goalkeeper" &&
                                              value != "Goalkeeper") {
                                            firstTeamGoalKeeper = false;
                                          }
                                          if (!firstTeamGoalKeeper ||
                                              value != "Goalkeeper") {
                                            if (value == "Goalkeeper") {
                                              firstTeamGoalKeeper = true;
                                            }
                                            firstTeamPlayers[index]
                                                ['position'] = value;
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Can't choose multiple Goalkeepers",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 3)));
                                          }
                                        } else {
                                          if (secondTeamPlayers[index]
                                                      ['position'] ==
                                                  "Goalkeeper" &&
                                              value != "Goalkeeper") {
                                            secondTeamGoalKeeper = false;
                                          }
                                          if (!secondTeamGoalKeeper ||
                                              value != "Goalkeeper") {
                                            if (value == "Goalkeeper") {
                                              secondTeamGoalKeeper = true;
                                            }
                                            secondTeamPlayers[index]
                                                ['position'] = value;
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Can't choose multiple Goalkeepers",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 3)));
                                          }
                                        }
                                      });
                                    },
                                    items: <String>[
                                      'Goalkeeper',
                                      'Right Back',
                                      'Center Back',
                                      'Left Back',
                                      'Right Midfielder',
                                      'Center Midfielder',
                                      'Left Midfielder',
                                      'Right Winger',
                                      'Center Forward',
                                      'Left Winger',
                                      'Center Player'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            playersSelected == int.parse(widget.totalPlayers)
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!firstTeamPlayerSelection) {
                                if (!firstTeamGoalKeeper) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Goalkeeper is mandatory and not selected yet",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3)));
                                  return;
                                }
                                firstTeamSubstitutePlayers = [];
                                for (var player in firstTeamPlayers) {
                                  if (!player['selected']) {
                                    firstTeamSubstitutePlayers
                                        .add(Map<String, dynamic>.from(player));
                                  }
                                }
                                final totalSubstitutePLayers =
                                    widget.totalPlayers == '11' ? 3 : 2;
                                var substitutePlayersSelected = 0;
                                if (totalSubstitutePLayers <=
                                    firstTeamSubstitutePlayers.length) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => Center(
                                            child: Dialog(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 235, 235, 240),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return Column(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 24, 0, 16),
                                                      child: Text(
                                                          "Select $totalSubstitutePLayers Substitute Players",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    const Divider(
                                                      height: 0,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                          ),
                                                          itemCount:
                                                              firstTeamSubstitutePlayers
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final player =
                                                                firstTeamSubstitutePlayers[
                                                                    index];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                if (firstTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'] ||
                                                                    substitutePlayersSelected <
                                                                        totalSubstitutePLayers) {
                                                                  setState(() {
                                                                    firstTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'] = !firstTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'];
                                                                    if (firstTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected']) {
                                                                      substitutePlayersSelected++;
                                                                    } else {
                                                                      substitutePlayersSelected--;
                                                                    }
                                                                  });
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Card(
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius:
                                                                              35,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.network(
                                                                              firstTeamSubstitutePlayers[index]['dp'],
                                                                              height: 50,
                                                                              width: 50,
                                                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                if (loadingProgress == null) {
                                                                                  return child;
                                                                                }
                                                                                return Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(32),
                                                                                    child: CircularProgressIndicator(
                                                                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/images/dp.png',
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        (firstTeamSubstitutePlayers[index]['selected']
                                                                            ? const Icon(Icons.check_box,
                                                                                color: Color(0xff554585))
                                                                            : const Icon(Icons.check_box_outline_blank, color: Color(0xff554585))),
                                                                        const SizedBox(
                                                                            width:
                                                                                16)
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          12,
                                                                          0,
                                                                          12,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        firstTeamSubstitutePlayers[index]['name'].length <=
                                                                                12
                                                                            ? firstTeamSubstitutePlayers[index][
                                                                                'name']
                                                                            : firstTeamSubstitutePlayers[index]['name'].toString().substring(0,
                                                                                12),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.location_pin,
                                                                              size: 13,
                                                                              color: Colors.grey),
                                                                          const SizedBox(
                                                                              width: 4),
                                                                          Text(
                                                                            firstTeamSubstitutePlayers[index]['city'].length <= 10
                                                                                ? firstTeamSubstitutePlayers[index]['city']
                                                                                : firstTeamSubstitutePlayers[index]['city'].toString().substring(0, 10),
                                                                            style:
                                                                                const TextStyle(fontSize: 13, color: Colors.grey),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          8),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.play_arrow,
                                                                              size: 15),
                                                                          Text(
                                                                            player['position'],
                                                                            style:
                                                                                const TextStyle(fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    substitutePlayersSelected ==
                                                            totalSubstitutePLayers
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      navigate2secondTeam();
                                                                      controller
                                                                          .animateTo(
                                                                        0,
                                                                        duration:
                                                                            const Duration(milliseconds: 500),
                                                                        curve: Curves
                                                                            .easeInOut,
                                                                      );
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xff554585)),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child: Text(
                                                                          "Done",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ]);
                                                })),
                                          )));
                                } else {
                                  setState(() {
                                    firstTeamPlayerSelection = true;
                                    playersSelected = 0;
                                  });
                                  controller.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              } else {
                                if (!secondTeamGoalKeeper) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Goalkeeper is mandatory and not selected yet",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3)));
                                  return;
                                }
                                secondTeamSubstitutePlayers = [];
                                for (var player in secondTeamPlayers) {
                                  if (!player['selected']) {
                                    secondTeamSubstitutePlayers
                                        .add(Map<String, dynamic>.from(player));
                                  }
                                }
                                final totalSubstitutePLayers =
                                    widget.totalPlayers == '11' ? 3 : 2;
                                var substitutePlayersSelected = 0;
                                if (totalSubstitutePLayers <=
                                    secondTeamSubstitutePlayers.length) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => Center(
                                            child: Dialog(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 235, 235, 240),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return Column(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          0, 24, 0, 16),
                                                      child: Text(
                                                          "Select $totalSubstitutePLayers Substitute Players",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    const Divider(
                                                      height: 0,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: GridView.builder(
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                          ),
                                                          itemCount:
                                                              secondTeamSubstitutePlayers
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final player =
                                                                secondTeamSubstitutePlayers[
                                                                    index];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                if (secondTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'] ||
                                                                    substitutePlayersSelected <
                                                                        totalSubstitutePLayers) {
                                                                  setState(() {
                                                                    secondTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'] = !secondTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected'];
                                                                    if (secondTeamSubstitutePlayers[
                                                                            index]
                                                                        [
                                                                        'selected']) {
                                                                      substitutePlayersSelected++;
                                                                    } else {
                                                                      substitutePlayersSelected--;
                                                                    }
                                                                  });
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Card(
                                                                color: Colors
                                                                    .white,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                          radius:
                                                                              35,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          child:
                                                                              ClipOval(
                                                                            child:
                                                                                Image.network(
                                                                              secondTeamSubstitutePlayers[index]['dp'],
                                                                              height: 50,
                                                                              width: 50,
                                                                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                                                if (loadingProgress == null) {
                                                                                  return child;
                                                                                }
                                                                                return Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(32),
                                                                                    child: CircularProgressIndicator(
                                                                                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                return Image.asset(
                                                                                  'assets/images/dp.png',
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        (secondTeamSubstitutePlayers[index]['selected']
                                                                            ? const Icon(Icons.check_box,
                                                                                color: Color(0xff554585))
                                                                            : const Icon(Icons.check_box_outline_blank, color: Color(0xff554585))),
                                                                        const SizedBox(
                                                                            width:
                                                                                16)
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          12,
                                                                          0,
                                                                          12,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        secondTeamSubstitutePlayers[index]['name'].length <=
                                                                                12
                                                                            ? secondTeamSubstitutePlayers[index][
                                                                                'name']
                                                                            : secondTeamSubstitutePlayers[index]['name'].toString().substring(0,
                                                                                12),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.location_pin,
                                                                              size: 13,
                                                                              color: Colors.grey),
                                                                          const SizedBox(
                                                                              width: 4),
                                                                          Text(
                                                                            secondTeamSubstitutePlayers[index]['city'].length <= 10
                                                                                ? secondTeamSubstitutePlayers[index]['city']
                                                                                : secondTeamSubstitutePlayers[index]['city'].toString().substring(0, 10),
                                                                            style:
                                                                                const TextStyle(fontSize: 13, color: Colors.grey),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          8),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.play_arrow,
                                                                              size: 15),
                                                                          Text(
                                                                            player['position'],
                                                                            style:
                                                                                const TextStyle(fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    substitutePlayersSelected ==
                                                            totalSubstitutePLayers
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      firstTeamPlayers.removeWhere((player) =>
                                                                          player[
                                                                              'selected'] ==
                                                                          false);
                                                                      secondTeamPlayers.removeWhere((player) =>
                                                                          player[
                                                                              'selected'] ==
                                                                          false);
                                                                      firstTeamSubstitutePlayers.removeWhere((player) =>
                                                                          player[
                                                                              'selected'] ==
                                                                          false);
                                                                      secondTeamSubstitutePlayers.removeWhere((player) =>
                                                                          player[
                                                                              'selected'] ==
                                                                          false);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => MatchOfficials(
                                                                                team1: widget.team1,
                                                                                team2: widget.team2,
                                                                                team1players: firstTeamPlayers,
                                                                                team2players: secondTeamPlayers,
                                                                                team1substitutePlayers: firstTeamSubstitutePlayers,
                                                                                team2substitutePlayers: secondTeamSubstitutePlayers,
                                                                                team1Logo: widget.team1Logo,
                                                                                team2Logo: widget.team2Logo,
                                                                                ground: widget.ground),
                                                                          ));
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            backgroundColor:
                                                                                const Color(0xff554585)),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              12),
                                                                      child: Text(
                                                                          "Select Match Officials",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ]);
                                                })),
                                          )));
                                } else {
                                  firstTeamPlayers.removeWhere(
                                      (player) => player['selected'] == false);
                                  secondTeamPlayers.removeWhere(
                                      (player) => player['selected'] == false);
                                  firstTeamSubstitutePlayers.removeWhere(
                                      (player) => player['selected'] == false);
                                  secondTeamSubstitutePlayers.removeWhere(
                                      (player) => player['selected'] == false);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MatchOfficials(
                                              team1: widget.team1,
                                              team2: widget.team2,
                                              team1players: firstTeamPlayers,
                                              team2players: secondTeamPlayers,
                                              team1substitutePlayers:
                                                  firstTeamSubstitutePlayers,
                                              team2substitutePlayers:
                                                  secondTeamSubstitutePlayers,
                                              team1Logo: widget.team1Logo,
                                              team2Logo: widget.team2Logo,
                                              ground: widget.ground)));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: const Color(0xff554585)),
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text("Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
