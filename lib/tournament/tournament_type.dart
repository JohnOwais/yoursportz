import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/tournament_rules.dart';

class SelectTournamentType extends StatefulWidget {
  const SelectTournamentType({super.key, required String phone});

  @override
  State<SelectTournamentType> createState() => _SelectTournamentTypeState();
}

class _SelectTournamentTypeState extends State<SelectTournamentType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Round"),
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(
          "assets/images/round_bg.jpg",
          fit: BoxFit.cover,
        )),
        const Padding(
          padding: EdgeInsets.all(4),
          child: Column(children: [
            TournamentOption(
              title: "Round Robbin",
              icon: Icons.sports_soccer,
            ),
            TournamentOption(
              title: "Knockout",
              icon: Icons.sports_mma,
            ),
            TournamentOption(
              title: "Semi-Final",
              icon: Icons.emoji_events,
            ),
            TournamentOption(
              title: "Final",
              icon: Icons.celebration,
            ),
          ]),
        )
      ]),
    );
  }
}

class TournamentOption extends StatelessWidget {
  const TournamentOption({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      const TournamentRules(phone: '919149764646'))));
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(icon, size: 30),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios)
            ]),
          ),
        ),
      ),
    );
  }
}
