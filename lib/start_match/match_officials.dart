import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/start_match/begin_match.dart';

class MatchOfficials extends StatefulWidget {
  const MatchOfficials(
      {super.key,
      required this.team1,
      required this.team2,
      required this.team1players,
      required this.team2players,
      required this.team1substitutePlayers,
      required this.team2substitutePlayers,
      required this.team1Logo,
      required this.team2Logo,
      required this.ground});

  final String team1;
  final String team2;
  final List<Map<String, dynamic>> team1players;
  final List<Map<String, dynamic>> team2players;
  final List<Map<String, dynamic>> team1substitutePlayers;
  final List<Map<String, dynamic>> team2substitutePlayers;
  final String team1Logo;
  final String team2Logo;
  final Map ground;

  @override
  State<MatchOfficials> createState() => _MatchOfficialsState();
}

class _MatchOfficialsState extends State<MatchOfficials> {
  List<Map<String, dynamic>> scorer = List.filled(2, {'phone': 'null'});
  List<Map<String, dynamic>> streamer = List.filled(4, {'phone': 'null'});
  List<Map<String, dynamic>> referee = List.filled(2, {'phone': 'null'});
  List<Map<String, dynamic>> linesman = List.filled(4, {'phone': 'null'});
  List<Map<String, dynamic>> users = [];
  var userLoading = true;
  var scorerSelection = false;
  List selectedOfficials = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await http.get(Uri.parse(
          'https://yoursportzbackend.azurewebsites.net/api/user/all/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          users = jsonData.cast<Map<String, dynamic>>();
          userLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        appBar: AppBar(
          title: const Text("Match Officials"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: userLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Scorer",
                                          style: TextStyle(fontSize: 20)),
                                      Text(
                                          "*Minimum one scorer should be selected.",
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Scorer(
                                          scorer: scorer,
                                          users: users,
                                          index: 0,
                                          setScorer: (int i) {
                                            setState(() {
                                              scorer[0] = users[i];
                                              scorerSelection = true;
                                            });
                                          },
                                          selectedOfficials: selectedOfficials,
                                          official: "Scorer"),
                                      Scorer(
                                          scorer: scorer,
                                          users: users,
                                          index: 1,
                                          setScorer: (int i) {
                                            setState(() {
                                              scorer[1] = users[i];
                                              scorerSelection = true;
                                            });
                                          },
                                          selectedOfficials: selectedOfficials,
                                          official: "Scorer")
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("Select Live Streamers",
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Streamer(
                                              streamer: streamer,
                                              users: users,
                                              index: 0,
                                              setStreamer: (int i) {
                                                setState(() {
                                                  streamer[0] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Streamer"),
                                          Streamer(
                                              streamer: streamer,
                                              users: users,
                                              index: 1,
                                              setStreamer: (int i) {
                                                setState(() {
                                                  streamer[1] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Streamer")
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Streamer(
                                              streamer: streamer,
                                              users: users,
                                              index: 2,
                                              setStreamer: (int i) {
                                                setState(() {
                                                  streamer[2] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Streamer"),
                                          Streamer(
                                              streamer: streamer,
                                              users: users,
                                              index: 3,
                                              setStreamer: (int i) {
                                                setState(() {
                                                  streamer[3] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Streamer")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("Select Referee",
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Referee(
                                          referee: referee,
                                          users: users,
                                          index: 0,
                                          setReferee: (int i) {
                                            setState(() {
                                              referee[0] = users[i];
                                            });
                                          },
                                          selectedOfficials: selectedOfficials,
                                          official: "Referee"),
                                      Referee(
                                          referee: referee,
                                          users: users,
                                          index: 1,
                                          setReferee: (int i) {
                                            setState(() {
                                              referee[1] = users[i];
                                            });
                                          },
                                          selectedOfficials: selectedOfficials,
                                          official: "Referee")
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text("Select Linesman",
                                      style: TextStyle(fontSize: 20)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Linesman(
                                              linesman: linesman,
                                              users: users,
                                              index: 0,
                                              setLinesman: (int i) {
                                                setState(() {
                                                  linesman[0] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Linesman"),
                                          Linesman(
                                              linesman: linesman,
                                              users: users,
                                              index: 1,
                                              setLinesman: (int i) {
                                                setState(() {
                                                  linesman[1] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Linesman")
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Linesman(
                                              linesman: linesman,
                                              users: users,
                                              index: 2,
                                              setLinesman: (int i) {
                                                setState(() {
                                                  linesman[2] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Linesman"),
                                          Linesman(
                                              linesman: linesman,
                                              users: users,
                                              index: 3,
                                              setLinesman: (int i) {
                                                setState(() {
                                                  linesman[3] = users[i];
                                                });
                                              },
                                              selectedOfficials:
                                                  selectedOfficials,
                                              official: "Linesman")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Spacer(),
                      SubmitMatchOfficials(
                          widget: widget,
                          scorer: scorer,
                          streamer: streamer,
                          referee: referee,
                          linesman: linesman,
                          canProceed: scorerSelection),
                    ],
                  )
                ],
              ));
  }
}

class Linesman extends StatefulWidget {
  const Linesman(
      {super.key,
      required this.linesman,
      required this.users,
      required this.index,
      required this.setLinesman,
      required this.selectedOfficials,
      required this.official});

  final List<Map<String, dynamic>> linesman;
  final List<Map<String, dynamic>> users;
  final int index;
  final Function(int) setLinesman;
  final List selectedOfficials;
  final String official;

  @override
  State<Linesman> createState() => _LinesmanState();
}

class _LinesmanState extends State<Linesman> {
  var userSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Text(
                                userSelected
                                    ? widget.linesman[widget.index]['name']
                                                .length <=
                                            10
                                        ? widget.linesman[widget.index]['name']
                                        : widget.linesman[widget.index]['name']
                                            .toString()
                                            .substring(0, 10)
                                    : "Linesman",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  size: 12, color: Colors.grey),
                              Text(
                                  userSelected
                                      ? widget.linesman[widget.index]['city']
                                                  .length <=
                                              10
                                          ? widget.linesman[widget.index]
                                              ['city']
                                          : widget.linesman[widget.index]
                                                  ['city']
                                              .toString()
                                              .substring(0, 10)
                                      : "City",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          )
                        ]),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          userSelected
                              ? widget.linesman[widget.index]['dp']
                              : "",
                          height: 35,
                          width: 35,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                              'assets/images/linesman_icon.png',
                              height: 35,
                              width: 35,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String filterText = '';
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: Colors.grey[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                  "Select ${widget.official}",
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  filterText = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 0),
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  hintText:
                                                      "Search for the user",
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: widget.users.length,
                                                itemBuilder: (context, index) {
                                                  final user =
                                                      widget.users[index];
                                                  return user['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(filterText
                                                                  .toLowerCase()) &&
                                                          !widget
                                                              .selectedOfficials
                                                              .contains(
                                                                  user['phone'])
                                                      ? User(
                                                          dp: user['dp'],
                                                          name: user['name'],
                                                          phone: user['phone'],
                                                          city: user['city'],
                                                          index: index,
                                                          select: (int i) {
                                                            widget
                                                                .selectedOfficials
                                                                .add(user[
                                                                    'phone']);
                                                            if (userSelected) {
                                                              widget
                                                                  .selectedOfficials
                                                                  .remove(widget
                                                                              .linesman[
                                                                          widget
                                                                              .index]
                                                                      [
                                                                      'phone']);
                                                            }
                                                            widget
                                                                .setLinesman(i);
                                                            setState(() {
                                                              userSelected =
                                                                  true;
                                                            });
                                                          })
                                                      : const SizedBox();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(4)),
                            minimumSize:
                                WidgetStateProperty.all<Size>(const Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 135, 120, 180)),
                          ),
                          child: Text(
                              userSelected
                                  ? "Change Linesman"
                                  : "Select Linesman",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class Referee extends StatefulWidget {
  const Referee(
      {super.key,
      required this.referee,
      required this.users,
      required this.index,
      required this.setReferee,
      required this.selectedOfficials,
      required this.official});

  final List<Map<String, dynamic>> referee;
  final List<Map<String, dynamic>> users;
  final int index;
  final Function(int) setReferee;
  final List selectedOfficials;
  final String official;

  @override
  State<Referee> createState() => _RefereeState();
}

class _RefereeState extends State<Referee> {
  var userSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Text(
                                userSelected
                                    ? widget.referee[widget.index]['name']
                                                .length <=
                                            10
                                        ? widget.referee[widget.index]['name']
                                        : widget.referee[widget.index]['name']
                                            .toString()
                                            .substring(0, 10)
                                    : "Referee",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  size: 12, color: Colors.grey),
                              Text(
                                  userSelected
                                      ? widget.referee[widget.index]['city']
                                                  .length <=
                                              10
                                          ? widget.referee[widget.index]['city']
                                          : widget.referee[widget.index]['city']
                                              .toString()
                                              .substring(0, 10)
                                      : "City",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          )
                        ]),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          userSelected
                              ? widget.referee[widget.index]['dp']
                              : "",
                          height: 35,
                          width: 35,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                              'assets/images/referee_icon.png',
                              height: 35,
                              width: 35,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String filterText = '';
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: Colors.grey[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                  "Select ${widget.official}",
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  filterText = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 0),
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  hintText:
                                                      "Search for the user",
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: widget.users.length,
                                                itemBuilder: (context, index) {
                                                  final user =
                                                      widget.users[index];
                                                  return user['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(filterText
                                                                  .toLowerCase()) &&
                                                          !widget
                                                              .selectedOfficials
                                                              .contains(
                                                                  user['phone'])
                                                      ? User(
                                                          dp: user['dp'],
                                                          name: user['name'],
                                                          phone: user['phone'],
                                                          city: user['city'],
                                                          index: index,
                                                          select: (int i) {
                                                            widget
                                                                .selectedOfficials
                                                                .add(user[
                                                                    'phone']);
                                                            if (userSelected) {
                                                              widget
                                                                  .selectedOfficials
                                                                  .remove(widget
                                                                              .referee[
                                                                          widget
                                                                              .index]
                                                                      [
                                                                      'phone']);
                                                            }
                                                            widget
                                                                .setReferee(i);
                                                            setState(() {
                                                              userSelected =
                                                                  true;
                                                            });
                                                          })
                                                      : const SizedBox();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(4)),
                            minimumSize:
                                WidgetStateProperty.all<Size>(const Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 135, 120, 180)),
                          ),
                          child: Text(
                              userSelected
                                  ? "Change Referee"
                                  : "Select Referee",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class Streamer extends StatefulWidget {
  const Streamer(
      {super.key,
      required this.streamer,
      required this.users,
      required this.index,
      required this.setStreamer,
      required this.selectedOfficials,
      required this.official});

  final List<Map<String, dynamic>> streamer;
  final List<Map<String, dynamic>> users;
  final int index;
  final Function(int) setStreamer;
  final List selectedOfficials;
  final String official;

  @override
  State<Streamer> createState() => _StreamerState();
}

class _StreamerState extends State<Streamer> {
  var userSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Text(
                                userSelected
                                    ? widget.streamer[widget.index]['name']
                                                .length <=
                                            10
                                        ? widget.streamer[widget.index]['name']
                                        : widget.streamer[widget.index]['name']
                                            .toString()
                                            .substring(0, 10)
                                    : "Streamer",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  size: 12, color: Colors.grey),
                              Text(
                                  userSelected
                                      ? widget.streamer[widget.index]['city']
                                                  .length <=
                                              10
                                          ? widget.streamer[widget.index]
                                              ['city']
                                          : widget.streamer[widget.index]
                                                  ['city']
                                              .toString()
                                              .substring(0, 10)
                                      : "City",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          )
                        ]),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          userSelected
                              ? widget.streamer[widget.index]['dp']
                              : "",
                          height: 35,
                          width: 35,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                              'assets/images/streamer_icon.png',
                              height: 35,
                              width: 35,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String filterText = '';
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: Colors.grey[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                  "Select ${widget.official}",
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  filterText = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 0),
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  hintText:
                                                      "Search for the user",
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: widget.users.length,
                                                itemBuilder: (context, index) {
                                                  final user =
                                                      widget.users[index];
                                                  return user['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(filterText
                                                                  .toLowerCase()) &&
                                                          !widget
                                                              .selectedOfficials
                                                              .contains(
                                                                  user['phone'])
                                                      ? User(
                                                          dp: user['dp'],
                                                          name: user['name'],
                                                          phone: user['phone'],
                                                          city: user['city'],
                                                          index: index,
                                                          select: (int i) {
                                                            widget
                                                                .selectedOfficials
                                                                .add(user[
                                                                    'phone']);
                                                            if (userSelected) {
                                                              widget
                                                                  .selectedOfficials
                                                                  .remove(widget
                                                                              .streamer[
                                                                          widget
                                                                              .index]
                                                                      [
                                                                      'phone']);
                                                            }
                                                            widget
                                                                .setStreamer(i);
                                                            setState(() {
                                                              userSelected =
                                                                  true;
                                                            });
                                                          })
                                                      : const SizedBox();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(4)),
                            minimumSize:
                                WidgetStateProperty.all<Size>(const Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 135, 120, 180)),
                          ),
                          child: Text(
                              userSelected
                                  ? "Change Streamer"
                                  : "Select Streamer",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class Scorer extends StatefulWidget {
  const Scorer(
      {super.key,
      required this.scorer,
      required this.users,
      required this.index,
      required this.setScorer,
      required this.selectedOfficials,
      required this.official});

  final List<Map<String, dynamic>> scorer;
  final List<Map<String, dynamic>> users;
  final int index;
  final Function(int) setScorer;
  final List selectedOfficials;
  final String official;

  @override
  State<Scorer> createState() => _ScorerState();
}

class _ScorerState extends State<Scorer> {
  var userSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Text(
                                userSelected
                                    ? widget.scorer[widget.index]['name']
                                                .length <=
                                            10
                                        ? widget.scorer[widget.index]['name']
                                        : widget.scorer[widget.index]['name']
                                            .toString()
                                            .substring(0, 10)
                                    : "Scorer",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  size: 12, color: Colors.grey),
                              Text(
                                  userSelected
                                      ? widget.scorer[widget.index]['city']
                                                  .length <=
                                              10
                                          ? widget.scorer[widget.index]['city']
                                          : widget.scorer[widget.index]['city']
                                              .toString()
                                              .substring(0, 10)
                                      : "City",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          )
                        ]),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                          userSelected ? widget.scorer[widget.index]['dp'] : "",
                          height: 35,
                          width: 35,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                              'assets/images/scorer_icon.png',
                              height: 35,
                              width: 35,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String filterText = '';
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      backgroundColor: Colors.grey[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                  "Select ${widget.official}",
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                            ),
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  filterText = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32)),
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 0),
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  hintText:
                                                      "Search for the user",
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: widget.users.length,
                                                itemBuilder: (context, index) {
                                                  final user =
                                                      widget.users[index];
                                                  return user['name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(filterText
                                                                  .toLowerCase()) &&
                                                          !widget
                                                              .selectedOfficials
                                                              .contains(
                                                                  user['phone'])
                                                      ? User(
                                                          dp: user['dp'],
                                                          name: user['name'],
                                                          phone: user['phone'],
                                                          city: user['city'],
                                                          index: index,
                                                          select: (int i) {
                                                            widget
                                                                .selectedOfficials
                                                                .add(user[
                                                                    'phone']);
                                                            if (userSelected) {
                                                              widget
                                                                  .selectedOfficials
                                                                  .remove(widget
                                                                              .scorer[
                                                                          widget
                                                                              .index]
                                                                      [
                                                                      'phone']);
                                                            }
                                                            widget.setScorer(i);
                                                            setState(() {
                                                              userSelected =
                                                                  true;
                                                            });
                                                          })
                                                      : const SizedBox();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(4)),
                            minimumSize:
                                WidgetStateProperty.all<Size>(const Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 135, 120, 180)),
                          ),
                          child: Text(
                              userSelected ? "Change Scorer" : "Select Scorer",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class SubmitMatchOfficials extends StatelessWidget {
  const SubmitMatchOfficials(
      {super.key,
      required this.widget,
      required this.scorer,
      required this.streamer,
      required this.referee,
      required this.linesman,
      required this.canProceed});

  final MatchOfficials widget;
  final List<Map<String, dynamic>> scorer;
  final List<Map<String, dynamic>> streamer;
  final List<Map<String, dynamic>> referee;
  final List<Map<String, dynamic>> linesman;
  final bool canProceed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  if (canProceed) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BeginMatch(
                                team1: widget.team1,
                                team2: widget.team2,
                                team1players: widget.team1players,
                                team2players: widget.team2players,
                                team1substitutePlayers:
                                    widget.team1substitutePlayers,
                                team2substitutePlayers:
                                    widget.team2substitutePlayers,
                                team1Logo: widget.team1Logo,
                                team2Logo: widget.team2Logo,
                                scorer: scorer,
                                streamer: streamer,
                                referee: referee,
                                linesman: linesman,
                                ground: widget.ground)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Select atleast one scorer to proceed",
                            style: TextStyle(color: Colors.white)),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red));
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xff554585)),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Start Match",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )),
          ),
        ],
      ),
    );
  }
}

class User extends StatefulWidget {
  const User(
      {super.key,
      required this.dp,
      required this.name,
      required this.phone,
      required this.city,
      required this.index,
      required this.select});

  final String dp;
  final String name;
  final String phone;
  final String city;
  final int index;
  final Function(int) select;

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  widget.dp,
                  height: 40,
                  width: 40,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
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
                      'assets/images/dp.png',
                      height: 40,
                      width: 40,
                    );
                  },
                ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                Text(widget.city,
                    style: const TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.select(widget.index);
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.cyan),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text("SELECT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8)
          ],
        ));
  }
}
