// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yoursportz/helper/time_slot.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/ongoing_tournaments.dart';
import 'package:yoursportz/tournament/standings_tabs/matches_view/player_selection.dart';

class ScheduleTournamentMatch extends StatefulWidget {
  const ScheduleTournamentMatch(
      {super.key, required this.tournament, required this.type});

  final Map<String, dynamic> tournament;
  final String type;

  @override
  State<ScheduleTournamentMatch> createState() =>
      _ScheduleTournamentMatchState();
}

class _ScheduleTournamentMatchState extends State<ScheduleTournamentMatch> {
  var selectedGroup;
  var selectedTime;
  var selectedHomeTeam;
  var selectedOpponentTeam;
  var scorer;
  var groupOptions = ['Group 1'];
  var selectedDate = "Select Date";
  DateTime initialdate = DateTime.now();
  final dateFormat = DateFormat('dd-MMM-yyyy');
  List<Map<String, dynamic>> users = [];
  var allowPlayerSelection = false;

  void success() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OngoingTournaments(phone: widget.tournament['phone'])));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          children: [
            Text("Match Created Successfully",
                style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.done_all, color: Colors.white)
          ],
        ),
        backgroundColor: Colors.green));
  }

  void failure() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Server Error. Failed to Create Match !!!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialdate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != initialdate) {
      setState(() {
        initialdate = picked;
        selectedDate = dateFormat.format(picked);
      });
    }
  }

  @override
  void initState() {
    for (int index = 2;
        index <= widget.tournament['groupedTeams'].length;
        index++) {
      groupOptions.add("Group $index");
    }
    if (widget.type == "start") {
      setState(() {
        selectedDate = dateFormat.format(DateTime.now());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await http.get(Uri.parse(
          'https://yoursportzbackend.azurewebsites.net/api/user/all/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          users = jsonData.cast<Map<String, dynamic>>();
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
            title: Text(
                widget.type == "start" ? "Start A Match" : "Schedule A Match")),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Column(children: [
                  Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                                child: Image.network(
                              widget.tournament['logoUrl'],
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
                                    padding: const EdgeInsets.all(24),
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/app_logo.png',
                                  height: 50,
                                );
                              },
                            ))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.tournament['tournamentName'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.tournament['city'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(text: "Group"),
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: const Text("Select Group"),
                                    icon: const SizedBox(),
                                    value: selectedGroup,
                                    underline: const SizedBox(),
                                    onChanged: (String? value) {
                                      if (selectedGroup != value) {
                                        setState(() {
                                          selectedGroup = value!;
                                          selectedHomeTeam = null;
                                          selectedOpponentTeam = null;
                                        });
                                      }
                                    },
                                    items: groupOptions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xff554585))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        widget.type == "schedule"
                            ? const Label(text: "Date")
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        widget.type == "schedule"
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectDate(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.date_range),
                                        const SizedBox(width: 12),
                                        Expanded(
                                            child: Text(selectedDate,
                                                style: TextStyle(
                                                    color: selectedDate ==
                                                            "Select Date"
                                                        ? Colors.black45
                                                        : null,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ],
                                    ),
                                  ),
                                ))
                            : const SizedBox(),
                        const SizedBox(height: 8),
                        const Label(text: "Time"),
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: const Text("Choose Start Time"),
                                    icon: const SizedBox(),
                                    value: selectedTime,
                                    underline: const SizedBox(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedTime = value!;
                                      });
                                    },
                                    items: timeSlots
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xff554585))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (selectedGroup == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select group first",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor: Colors.red));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SelectTeam(
                                              group: widget.tournament[
                                                  'groupedTeams'][int.parse(
                                                      selectedGroup.substring(
                                                          selectedGroup.length -
                                                              1)) -
                                                  1],
                                              selectTeam: (Map<String, dynamic>
                                                  selectedTeam) {
                                                if (selectedOpponentTeam !=
                                                        null &&
                                                    selectedOpponentTeam[
                                                            'name'] ==
                                                        selectedTeam['name']) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Team already selected as Opponent Team",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                } else {
                                                  setState(() {
                                                    selectedHomeTeam =
                                                        selectedTeam;
                                                    if (selectedOpponentTeam !=
                                                        null) {
                                                      if (selectedHomeTeam[
                                                                  'players']
                                                              .isNotEmpty &&
                                                          selectedOpponentTeam[
                                                                  'players']
                                                              .isNotEmpty) {
                                                        allowPlayerSelection =
                                                            true;
                                                      } else {
                                                        allowPlayerSelection =
                                                            false;
                                                      }
                                                    }
                                                  });
                                                }
                                              },
                                            ));
                                  }
                                },
                                child: selectedHomeTeam == null
                                    ? const Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Icon(Icons.add),
                                              SizedBox(height: 8),
                                              Text("Home Team"),
                                            ],
                                          ),
                                        ))
                                    : Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: ClipOval(
                                                      child: Image.network(
                                                    selectedHomeTeam['logo'],
                                                    height: 50,
                                                    width: 50,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
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
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/app_logo.png',
                                                        height: 50,
                                                      );
                                                    },
                                                  ))),
                                              const SizedBox(height: 8),
                                              Text(
                                                  selectedHomeTeam['name']
                                                              .length <=
                                                          15
                                                      ? selectedHomeTeam['name']
                                                      : selectedHomeTeam['name']
                                                          .substring(0, 15),
                                                  style: const TextStyle(
                                                      color: Color(0xff554585),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        )),
                              ),
                              const Text("v/s"),
                              GestureDetector(
                                onTap: () {
                                  if (selectedGroup == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select group first",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            backgroundColor: Colors.red));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SelectTeam(
                                              group: widget.tournament[
                                                  'groupedTeams'][int.parse(
                                                      selectedGroup.substring(
                                                          selectedGroup.length -
                                                              1)) -
                                                  1],
                                              selectTeam: (Map<String, dynamic>
                                                  selectedTeam) {
                                                if (selectedHomeTeam != null &&
                                                    selectedHomeTeam['name'] ==
                                                        selectedTeam['name']) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        "Team already selected as Home Team",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                } else {
                                                  setState(() {
                                                    selectedOpponentTeam =
                                                        selectedTeam;
                                                    if (selectedHomeTeam !=
                                                        null) {
                                                      if (selectedHomeTeam[
                                                                  'players']
                                                              .isNotEmpty &&
                                                          selectedOpponentTeam[
                                                                  'players']
                                                              .isNotEmpty) {
                                                        allowPlayerSelection =
                                                            true;
                                                      } else {
                                                        allowPlayerSelection =
                                                            false;
                                                      }
                                                    }
                                                  });
                                                }
                                              },
                                            ));
                                  }
                                },
                                child: selectedOpponentTeam == null
                                    ? const Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Icon(Icons.add),
                                              SizedBox(height: 8),
                                              Text("Opponent Team"),
                                            ],
                                          ),
                                        ))
                                    : Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: ClipOval(
                                                      child: Image.network(
                                                    selectedOpponentTeam[
                                                        'logo'],
                                                    height: 50,
                                                    width: 50,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
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
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/app_logo.png',
                                                        height: 50,
                                                      );
                                                    },
                                                  ))),
                                              const SizedBox(height: 8),
                                              Text(
                                                  selectedOpponentTeam['name']
                                                              .length <=
                                                          15
                                                      ? selectedOpponentTeam[
                                                          'name']
                                                      : selectedOpponentTeam[
                                                              'name']
                                                          .substring(0, 15),
                                                  style: const TextStyle(
                                                      color: Color(0xff554585),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        )),
                              ),
                            ]),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Column(children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedDate == "Select Date") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select date first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else if (selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select time first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else if (selectedHomeTeam == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select Home Team first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else if (selectedOpponentTeam == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select Opponent Team first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else if (selectedHomeTeam['players'].isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "No players in selected Home Team",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else if (selectedOpponentTeam['players'].isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "No players in selected Opponent Team",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red));
                          } else {
                            selectScorer(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color(0xff554585)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                              allowPlayerSelection
                                  ? "Select Scorer"
                                  : widget.type == "start"
                                      ? "Start Match"
                                      : "Schedule Match",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])
          ],
        ));
  }

  Future<dynamic> selectScorer(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        String filterText = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: const Color.fromARGB(255, 235, 235, 240),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Text("Select Scorer", style: TextStyle(fontSize: 20)),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          filterText = value;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search for the user",
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return user['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(filterText.toLowerCase())
                              ? User(
                                  dp: user['dp'],
                                  name: user['name'],
                                  phone: user['phone'],
                                  city: user['city'],
                                  index: index,
                                  select: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlayerSelection(
                                                    phone: widget
                                                        .tournament['phone'],
                                                    type: widget.type,
                                                    tournamentId:
                                                        widget.tournament[
                                                            'tournamentId'],
                                                    group: selectedGroup,
                                                    date: selectedDate,
                                                    time: selectedTime,
                                                    teamA: selectedHomeTeam,
                                                    teamB: selectedOpponentTeam,
                                                    scorer: user)));
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
  final Function() select;

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
                Text(
                    widget.name.length <= 12
                        ? widget.name
                        : widget.name.substring(0, 12),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                Text(
                    widget.city.length <= 12
                        ? widget.city
                        : widget.city.substring(0, 12),
                    style: const TextStyle(fontSize: 12, color: Colors.grey))
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  widget.select();
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

class SelectTeam extends StatefulWidget {
  const SelectTeam({super.key, required this.group, required this.selectTeam});

  final List<dynamic> group;
  final Function(Map<String, dynamic>) selectTeam;

  @override
  State<SelectTeam> createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  List<Map<String, dynamic>> teams = [];

  @override
  void initState() {
    setState(() {
      teams = widget.group.map((team) => team as Map<String, dynamic>).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Select Team",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
            const Divider(height: 0),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return Team(
                        team: team,
                        select: () {
                          widget.selectTeam(team);
                        });
                  }),
            )
          ]),
        ));
  }
}

class Team extends StatelessWidget {
  const Team({super.key, required this.team, required this.select});

  final Map<String, dynamic> team;
  final Function() select;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  team['logo'],
                  height: 50,
                  width: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                      'assets/images/app_logo.png',
                      height: 50,
                    );
                  },
                ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team['name'].toString().length <= 12
                      ? team['name']
                      : team['name'].toString().substring(0, 12),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  team['city'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  select();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.cyan),
                child: const Icon(
                  Icons.done_outline,
                  color: Colors.white,
                )),
            const SizedBox(width: 16)
          ],
        ));
  }
}

class Label extends StatelessWidget {
  const Label({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
    );
  }
}
