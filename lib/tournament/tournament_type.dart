import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/tournament_rules.dart';

class SelectTournamentType extends StatefulWidget {
  const SelectTournamentType(
      {super.key, required this.phone, required this.tournamentId});

  final String phone;
  final String tournamentId;

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
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(children: [
            TournamentOption(
                phone: widget.phone,
                title: "Round Robbin",
                icon: Icons.restart_alt,
                tournamentId: widget.tournamentId),
            TournamentOption(
                phone: widget.phone,
                title: "League Matches",
                icon: Icons.sports_soccer,
                tournamentId: widget.tournamentId),
            TournamentOption(
                phone: widget.phone,
                title: "Knockout",
                icon: Icons.sports_mma,
                tournamentId: widget.tournamentId),
            TournamentOption(
                phone: widget.phone,
                title: "Semi-Final",
                icon: Icons.emoji_events,
                tournamentId: widget.tournamentId),
            TournamentOption(
                phone: widget.phone,
                title: "Final",
                icon: Icons.celebration,
                tournamentId: widget.tournamentId),
          ]),
        )
      ]),
    );
  }
}

class TournamentOption extends StatelessWidget {
  const TournamentOption(
      {super.key,
      required this.phone,
      required this.title,
      required this.icon,
      required this.tournamentId});

  final String phone;
  final String title;
  final IconData icon;
  final String tournamentId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentRules(
                    phone: phone,
                    tournamentId: tournamentId,
                    tournamentType: title)));
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
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
