import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yoursportz/create_team/create_team.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/start_match/choose_players.dart';
import 'package:yoursportz/start_match/match_officials.dart';

class StartMatch extends StatefulWidget {
  const StartMatch(
      {super.key,
      required this.phone,
      required this.ground,
      this.team,
      this.imageUrl,
      this.team2,
      this.imageUrl2});

  final String phone;
  final Map ground;
  final String? team;
  final String? imageUrl;
  final String? team2;
  final String? imageUrl2;

  @override
  State<StartMatch> createState() => _StartMatchState();
}

class _StartMatchState extends State<StartMatch> {
  var teamsSelected = false;
  var isLoading = false;
  List<Map<String, dynamic>> addedPlayersTeam1 = [];
  List<Map<String, dynamic>> addedPlayersTeam2 = [];
  String buttonString = "Select Players";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.team2 != null) {
        setState(() {
          isLoading = true;
        });
        final body1 = jsonEncode(<String, dynamic>{'team_name': widget.team});
        final body2 = jsonEncode(<String, dynamic>{'team_name': widget.team2});
        final response1 = await http.post(
            Uri.parse(
                "https://yoursportzbackend.azurewebsites.net/api/team/get_all_players/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body1);
        if (response1.statusCode == 200) {
          final jsonData = json.decode(response1.body);
          setState(() {
            addedPlayersTeam1 = jsonData.cast<Map<String, dynamic>>();
          });
        }
        final response2 = await http.post(
            Uri.parse(
                "https://yoursportzbackend.azurewebsites.net/api/team/get_all_players/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body2);
        if (response2.statusCode == 200) {
          final jsonData = json.decode(response2.body);
          addedPlayersTeam2 = jsonData.cast<Map<String, dynamic>>();
          setState(() {
            final totalPlayers = int.parse(widget.ground['players'][0]) < 5
                ? widget.ground['players'].toString().substring(0, 2)
                : widget.ground['players'][0];
            final homeTeamPlayers = addedPlayersTeam1.length.toString();
            final opponentTeamPlayers = addedPlayersTeam2.length.toString();
            if (totalPlayers == homeTeamPlayers &&
                totalPlayers == opponentTeamPlayers) {
              buttonString = "Select Match Officials";
            }
          });
        }
        setState(() {
          isLoading = false;
          teamsSelected = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Select Teams"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.team == null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectTeam(
                                    phone: widget.phone,
                                    ground: widget.ground,
                                    selection: "home")));
                      },
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.add,
                                    color: Colors.green, size: 30),
                              )),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Select Home Team",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectTeam(
                                    phone: widget.phone,
                                    ground: widget.ground,
                                    selection: "home")));
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.imageUrl!,
                                height: 36,
                                width: 36,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
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
                                    height: 36,
                                    width: 36,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(widget.team!,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ),
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(82),
                      child: CircularProgressIndicator(),
                    )
                  : teamsSelected
                      ? Padding(
                          padding: const EdgeInsets.all(76),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                onPressed: () async {
                                  final totalPlayers =
                                      int.parse(widget.ground['players'][0]) < 5
                                          ? widget.ground['players']
                                              .toString()
                                              .substring(0, 2)
                                          : widget.ground['players'][0];
                                  final homeTeamPlayers =
                                      addedPlayersTeam1.length.toString();
                                  final opponentTeamPlayers =
                                      addedPlayersTeam2.length.toString();
                                  if (totalPlayers == homeTeamPlayers &&
                                      totalPlayers == opponentTeamPlayers) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MatchOfficials(
                                                team1: widget.team!,
                                                team2: widget.team2!,
                                                team1players: addedPlayersTeam1,
                                                team2players: addedPlayersTeam2,
                                                team1substitutePlayers: const [],
                                                team2substitutePlayers: const [],
                                                team1Logo: widget.imageUrl!,
                                                team2Logo: widget.imageUrl2!,
                                                ground: widget.ground)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChoosePlayers(
                                                team1: widget.team!,
                                                team2: widget.team2!,
                                                team1players: addedPlayersTeam1,
                                                team2players: addedPlayersTeam2,
                                                team1Logo: widget.imageUrl!,
                                                team2Logo: widget.imageUrl2!,
                                                totalPlayers: totalPlayers,
                                                ground: widget.ground)));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: const Color(0xff554585)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(buttonString,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                            ],
                          ),
                        )
                      : const SizedBox(height: 200),
              widget.team2 == null
                  ? GestureDetector(
                      onTap: () {
                        if (widget.team == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Please select \"Home Team\" first",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectTeam(
                                      phone: widget.phone,
                                      ground: widget.ground,
                                      selection: "opponent",
                                      homeTeam: widget.team,
                                      homeImageUrl: widget.imageUrl)));
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32)),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.add,
                                    color: Colors.green, size: 30),
                              )),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Select Opponent Team",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onLongPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectTeam(
                                    phone: widget.phone,
                                    ground: widget.ground,
                                    selection: "opponent",
                                    homeTeam: widget.team,
                                    homeImageUrl: widget.imageUrl)));
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                  child: Image.network(
                                widget.imageUrl2!,
                                height: 36,
                                width: 36,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
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
                                    height: 36,
                                    width: 36,
                                  );
                                },
                              ))),
                          const SizedBox(height: 8),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(widget.team2!,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectTeam extends StatefulWidget {
  const SelectTeam(
      {super.key,
      required this.phone,
      required this.ground,
      required this.selection,
      this.homeTeam,
      this.homeImageUrl});

  final String phone;
  final Map ground;
  final String selection;
  final String? homeTeam;
  final String? homeImageUrl;

  @override
  State<SelectTeam> createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  var filterText = "";
  List<Map<String, dynamic>> teams = [];
  var isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final totalPlayers = int.parse(widget.ground['players'][0]) < 5
          ? widget.ground['players'].toString().substring(0, 2)
          : widget.ground['players'][0];
      final body = jsonEncode(
          <String, dynamic>{'phone': widget.phone, 'count': totalPlayers});
      if (widget.selection == "home") {
        final response = await http.post(
            Uri.parse(
                "https://yoursportzbackend.azurewebsites.net/api/team/get-teams/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          setState(() {
            teams = jsonData.cast<Map<String, dynamic>>();
          });
        }
      } else {
        final response = await http.post(
            Uri.parse(
                "https://yoursportzbackend.azurewebsites.net/api/team/get-opponent-teams/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          setState(() {
            teams = jsonData.cast<Map<String, dynamic>>();
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: widget.selection == "home"
            ? const Text("Select Home Team")
            : const Text("Select Opponent Team"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
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
                    fillColor: const Color.fromARGB(255, 240, 240, 245),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Type team name",
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
          ),
          isLoading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : teams.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListView.builder(
                          itemCount: teams.length,
                          itemBuilder: (context, index) {
                            final team = teams[index];
                            if (team['name']
                                .toString()
                                .toLowerCase()
                                .contains(filterText.toLowerCase())) {
                              return widget.selection == "home"
                                  ? Team(
                                      phone: widget.phone,
                                      ground: widget.ground,
                                      team: team,
                                      index: index,
                                      selection: widget.selection)
                                  : Team(
                                      phone: widget.phone,
                                      ground: widget.ground,
                                      team: team,
                                      index: index,
                                      selection: widget.selection,
                                      homeTeam: widget.homeTeam,
                                      homeImageUrl: widget.homeImageUrl,
                                    );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    )
                  : CreateNewTeam(
                      phone: widget.phone,
                      ground: widget.ground,
                    )
        ],
      ),
    );
  }
}

class Team extends StatelessWidget {
  const Team(
      {super.key,
      required this.phone,
      required this.ground,
      required this.team,
      required this.index,
      required this.selection,
      this.homeTeam,
      this.homeImageUrl});

  final String phone;
  final Map ground;
  final Map<String, dynamic> team;
  final int index;
  final String selection;
  final String? homeTeam;
  final String? homeImageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
        if (selection == "home") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartMatch(
                      phone: phone,
                      ground: ground,
                      team: team['name'],
                      imageUrl: team['logo'])));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartMatch(
                        phone: phone,
                        ground: ground,
                        team: homeTeam,
                        imageUrl: homeImageUrl,
                        team2: team['name'],
                        imageUrl2: team['logo'],
                      )));
        }
      },
      child: Card(
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
                          padding: const EdgeInsets.all(24),
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
                    team['name'],
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    team['city'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class CreateNewTeam extends StatefulWidget {
  const CreateNewTeam({super.key, required this.phone, required this.ground});

  final String phone;
  final Map ground;

  @override
  State<CreateNewTeam> createState() => _CreateNewTeamState();
}

class _CreateNewTeamState extends State<CreateNewTeam> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
            "Why haven't you played a match yet?\nCome on, go ahead and start one!",
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTeam(
                          phone: widget.phone,
                          ground: widget.ground,
                          source: "match")));
            },
            child: const Text("Create Your Team",
                style: TextStyle(color: Colors.grey)))
      ]),
    );
  }
}
