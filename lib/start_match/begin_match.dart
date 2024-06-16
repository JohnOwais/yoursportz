import 'package:flutter/material.dart';
import 'package:yoursportz/start_match/toss_create-match.dart';

class BeginMatch extends StatefulWidget {
  const BeginMatch(
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
      required this.ground});

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

  @override
  State<BeginMatch> createState() => _BeginMatchState();
}

class _BeginMatchState extends State<BeginMatch>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Map<String, dynamic> goalKeeper1;
  late List<Widget> defenders1 = [];
  late List<Widget> midfielders1 = [];
  late List<Widget> centerForwards1 = [];
  late List<Widget> centerPlayers1 = [];
  late Map<String, dynamic> goalKeeper2;
  late List<Widget> defenders2 = [];
  late List<Widget> midfielders2 = [];
  late List<Widget> centerForwards2 = [];
  late List<Widget> centerPlayers2 = [];
  var toss = false;
  var caller = "";
  var tossWon = "";
  var kickOff = "";

  @override
  void initState() {
    for (var item in widget.team1players) {
      if (item['position'] == 'Goalkeeper') {
        goalKeeper1 = item;
      } else if (item['position'] == 'Right Back' ||
          item['position'] == 'Center Back' ||
          item['position'] == 'Left Back') {
        Player player = Player(dp: item['dp'], name: item['name']);
        defenders1.add(player);
      } else if (item['position'] == 'Right Midfielder' ||
          item['position'] == 'Center Midfielder' ||
          item['position'] == 'Left Midfielder') {
        Player player = Player(dp: item['dp'], name: item['name']);
        midfielders1.add(player);
      } else if (item['position'] == 'Right Winger' ||
          item['position'] == 'Center Forward' ||
          item['position'] == 'Left Winger') {
        Player player = Player(dp: item['dp'], name: item['name']);
        centerForwards1.add(player);
      } else if (item['position'] == 'Center Player') {
        Player player = Player(dp: item['dp'], name: item['name']);
        centerPlayers1.add(player);
      }
    }
    for (var item in widget.team2players) {
      if (item['position'] == 'Goalkeeper') {
        goalKeeper2 = item;
      } else if (item['position'] == 'Right Back' ||
          item['position'] == 'Center Back' ||
          item['position'] == 'Left Back') {
        Player player = Player(dp: item['dp'], name: item['name']);
        defenders2.add(player);
      } else if (item['position'] == 'Right Midfielder' ||
          item['position'] == 'Center Midfielder' ||
          item['position'] == 'Left Midfielder') {
        Player player = Player(dp: item['dp'], name: item['name']);
        midfielders2.add(player);
      } else if (item['position'] == 'Right Winger' ||
          item['position'] == 'Center Forward' ||
          item['position'] == 'Left Winger') {
        Player player = Player(dp: item['dp'], name: item['name']);
        centerForwards2.add(player);
      } else if (item['position'] == 'Center Player') {
        Player player = Player(dp: item['dp'], name: item['name']);
        centerPlayers2.add(player);
      }
    }
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    startTossButtonAnimation();
    super.initState();
  }

  Future<void> startTossButtonAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Begin Match"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Player(dp: goalKeeper1['dp'], name: goalKeeper1['name'])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: defenders1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: midfielders1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: centerForwards1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: centerPlayers1,
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: centerPlayers2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: centerForwards2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: midfielders2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: defenders2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Player(dp: goalKeeper2['dp'], name: goalKeeper2['name'])
                    ],
                  ),
                ],
              ))
            ]),
          ),
          toss
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: animation.value,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => Toss(
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
                                              scorer: widget.scorer,
                                              streamer: widget.streamer,
                                              referee: widget.referee,
                                              linesman: widget.linesman,
                                              ground: widget.ground,
                                              setKickoff: (bool tossDone,
                                                  String callerTeam,
                                                  String tossWonTeam,
                                                  String kickOffTeam) {
                                                setState(() {
                                                  toss = tossDone;
                                                  caller = callerTeam;
                                                  tossWon = tossWonTeam;
                                                  kickOff = kickOffTeam;
                                                });
                                              }))));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    backgroundColor: const Color(0xff554585)),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 28, 0, 28),
                                  child: Text("Toss",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key, required this.dp, required this.name});

  final String dp;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            child: ClipOval(
                child: Image.network(
              dp,
              height: 30,
              width: 30,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
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
                  height: 25,
                  width: 25,
                );
              },
            ))),
        const SizedBox(height: 4),
        Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(150, 100, 100, 100),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                  name.length <= 5 ? "  $name  " : " ${name.substring(0, 5)}..",
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )),
      ],
    );
  }
}
