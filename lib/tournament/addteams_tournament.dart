import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/namecard_tournament.dart';

class AddteamsTournament extends StatefulWidget {
  final String phone;
  const AddteamsTournament({super.key, required this.phone});

  @override
  State<AddteamsTournament> createState() => _AddteamsTournamentState();
}

class _AddteamsTournamentState extends State<AddteamsTournament> {
  var hanoverFc1 = false;
  var hanoverFc2 = false;
  var hanoverFc3 = false;
  var hanoverFc4 = false;
  var hanoverFc5 = false;
  var hanoverFc6 = false;
  var hanoverFc7 = false;
  // var imagePath = "null"; late File imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        title: const Text('Group B'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 70),
              child: Column(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hanoverFc1 = !hanoverFc1;
                          });
                        },
                        child: TeamCard(
                          hanoverFc: hanoverFc1,
                          icon: Icons.check_box_rounded,
                        ),
                      ),
                      TeamCard(
                        hanoverFc: hanoverFc3,
                        icon: Icons.check_box_rounded,
                      ),
                      TeamCard(
                        hanoverFc: hanoverFc4,
                        icon: Icons.check_box_rounded,
                      ),
                      TeamCard(hanoverFc: hanoverFc5, icon: Icons.add_rounded),
                      TeamCard(hanoverFc: hanoverFc6, icon: Icons.add_rounded),
                      TeamCard(hanoverFc: hanoverFc7, icon: Icons.add_rounded),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Container(
                color: const Color.fromARGB(255, 240, 240, 245),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff554585),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const NamecardTournament(
                                              phone: '919149764646'))));
                            },
                            child: const Text("Next",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.hanoverFc,
    required this.icon,
  });

  final bool hanoverFc;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: hanoverFc ? const Color.fromARGB(255, 107, 89, 161) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 70,
                  width: 70,
                ))),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hanover FC",
                    style: TextStyle(
                        color: hanoverFc
                            ? Colors.white
                            : const Color.fromARGB(255, 107, 89, 161),
                        fontSize: 17)),
                const Text(
                  "Location",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            const Spacer(),
            Icon(hanoverFc ? Icons.check_circle : Icons.check_box_outline_blank,
                color: hanoverFc
                    ? Colors.green
                    : const Color.fromARGB(255, 107, 89, 161)),
          ],
        ),
      ),
    );
  }
}
