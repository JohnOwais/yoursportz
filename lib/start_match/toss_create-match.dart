// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Toss extends StatefulWidget {
  const Toss(
      {super.key,
      required this.team1,
      required this.team2,
      required this.team1players,
      required this.team2players,
      required this.team1substitutePlayers,
      required this.team2substitutePlayers,
      required this.team1Logo,
      required this.team2Logo,
      required this.scorer,
      required this.streamer,
      required this.referee,
      required this.linesman,
      required this.ground,
      required this.setKickoff});

  final String team1;
  final String team2;
  final List<Map<String, dynamic>> team1players;
  final List<Map<String, dynamic>> team2players;
  final List<Map<String, dynamic>> team1substitutePlayers;
  final List<Map<String, dynamic>> team2substitutePlayers;
  final String team1Logo;
  final String team2Logo;
  final List<Map<String, dynamic>> scorer;
  final List<Map<String, dynamic>> streamer;
  final List<Map<String, dynamic>> referee;
  final List<Map<String, dynamic>> linesman;
  final Map ground;
  final Function(bool, String, String, String) setKickoff;

  @override
  State<Toss> createState() => _TossState();
}

class _TossState extends State<Toss> {
  var userPhone = "";
  var caller = "";
  var tossWon = "";
  var kickOff = "";
  var isLoading = false;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void getUserId() async {
    var currentUser = await Hive.openBox('CurrentUser');
    setState(() {
      userPhone = currentUser.get('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text("Toss"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Who is the caller?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    caller = widget.team1;
                    tossWon = "";
                    kickOff = "";
                  });
                },
                child: Card(
                    color: caller == widget.team1 ? Colors.blue : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.team1Logo,
                                height: 80,
                                width: 80,
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                    width: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Text(
                              widget.team1.length <= 15
                                  ? widget.team1
                                  : widget.team1.substring(0, 15),
                              style: TextStyle(
                                  color: caller == widget.team1
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    caller = widget.team2;
                    tossWon = "";
                    kickOff = "";
                  });
                },
                child: Card(
                    color: caller == widget.team2 ? Colors.blue : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.team2Logo,
                                height: 80,
                                width: 80,
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                    width: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Text(
                              widget.team2.length <= 15
                                  ? widget.team2
                                  : widget.team2.substring(0, 15),
                              style: TextStyle(
                                  color: caller == widget.team2
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              )
            ]),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
              child: Text("Who won the toss?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              GestureDetector(
                onTap: () {
                  if (caller == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the caller first",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  }
                  setState(() {
                    tossWon = widget.team1;
                    kickOff = "";
                  });
                },
                child: Card(
                    color: tossWon == widget.team1 ? Colors.blue : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.team1Logo,
                                height: 80,
                                width: 80,
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                    width: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Text(
                              widget.team1.length <= 15
                                  ? widget.team1
                                  : widget.team1.substring(0, 15),
                              style: TextStyle(
                                  color: tossWon == widget.team1
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (caller == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the caller first",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  }
                  setState(() {
                    tossWon = widget.team2;
                    kickOff = "";
                  });
                },
                child: Card(
                    color: tossWon == widget.team2 ? Colors.blue : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.team2Logo,
                                height: 80,
                                width: 80,
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
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/app_logo.png',
                                    height: 80,
                                    width: 80,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Text(
                              widget.team2.length <= 15
                                  ? widget.team2
                                  : widget.team2.substring(0, 15),
                              style: TextStyle(
                                  color: tossWon == widget.team2
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              )
            ]),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
              child: Text("Winner of the toss elected to?",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              GestureDetector(
                onTap: () {
                  if (caller == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the caller first",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  } else if (tossWon == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the team who won the toss",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  }
                  if (tossWon == widget.team1) {
                    setState(() {
                      kickOff = widget.team1;
                    });
                  } else {
                    setState(() {
                      kickOff = widget.team2;
                    });
                  }
                },
                child: Card(
                    color: (tossWon == widget.team1 &&
                                kickOff == widget.team1) ||
                            (tossWon == widget.team2 && kickOff == widget.team2)
                        ? Colors.blue
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.asset(
                                'assets/images/kickOff.jpg',
                                height: 80,
                                width: 80,
                              ))),
                          const SizedBox(height: 8),
                          Text("Kick-Off",
                              style: TextStyle(
                                  color: (tossWon == widget.team1 &&
                                              kickOff == widget.team1) ||
                                          (tossWon == widget.team2 &&
                                              kickOff == widget.team2)
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (caller == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the caller first",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  } else if (tossWon == "") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select the team who won the toss",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ));
                    return;
                  }
                  if (tossWon == widget.team1) {
                    setState(() {
                      kickOff = widget.team2;
                    });
                  } else {
                    setState(() {
                      kickOff = widget.team1;
                    });
                  }
                },
                child: Card(
                    color: (tossWon == widget.team1 &&
                                kickOff == widget.team2) ||
                            (tossWon == widget.team2 && kickOff == widget.team1)
                        ? Colors.blue
                        : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.asset(
                                'assets/images/defender.jpg',
                                height: 80,
                                width: 80,
                              ))),
                          const SizedBox(height: 8),
                          Text("Defence",
                              style: TextStyle(
                                  color: (tossWon == widget.team1 &&
                                              kickOff == widget.team2) ||
                                          (tossWon == widget.team2 &&
                                              kickOff == widget.team1)
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    )),
              )
            ]),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (caller == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please select the caller first",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      } else if (tossWon == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Please select the team who won the toss",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      } else if (kickOff == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Please select either Kick-Off or Defence",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      final body = jsonEncode(<String, dynamic>{
                        'phone': userPhone,
                        'teamA': widget.team1,
                        'teamB': widget.team2,
                        'teamAplayers': widget.team1players,
                        'teamBplayers': widget.team2players,
                        'teamAsubstitutePlayers': widget.team1substitutePlayers,
                        'teamBsubstitutePlayers': widget.team2substitutePlayers,
                        'teamALogo': widget.team1Logo,
                        'teamBLogo': widget.team2Logo,
                        'scorer': widget.scorer,
                        'streamer': widget.streamer,
                        'referee': widget.referee,
                        'linesman': widget.linesman,
                        'ground': widget.ground,
                        'caller': caller,
                        'tossWon': tossWon,
                        'kickOff': kickOff
                      });
                      final initialResponse = await http.post(
                          Uri.parse(
                              "https://yoursportzbackend.azurewebsites.net/api/match/create/"),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: body);
                      final Map<String, dynamic> responseData =
                          jsonDecode(initialResponse.body);
                      if (responseData['message'] == "success") {
                        widget.setKickoff(true, caller, tossWon, kickOff);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: SingleChildScrollView(
                                    child: Dialog(
                                        surfaceTintColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(children: [
                                            Image.asset(
                                                'assets/images/success_team.png',
                                                height: 70,
                                                width: 70),
                                            const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                  "Match Created Successfully",
                                                  style:
                                                      TextStyle(fontSize: 17)),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  4, 8, 4, 8),
                                              child: Text(
                                                  "Match officials have been assigned and notified. Buckle up, because this match is about to take us on a rollercoaster ride of excitement.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  backgroundColor:
                                                      const Color(0xff554585)),
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12, 0, 12, 0),
                                                child: Text(
                                                    "Let's Begin The Match",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ]),
                                        )),
                                  ),
                                ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Failed to upload data to server !!!",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ));
                      }
                      setState(() {
                        isLoading = false;
                      });
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
                            child: Text("Let's Start",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
