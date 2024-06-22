// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/create_tournament.dart';
import 'package:yoursportz/tournament/invite_tournament.dart';
import 'package:yoursportz/tournament/tournament_type.dart';

class OngoingTournaments extends StatefulWidget {
  const OngoingTournaments({super.key, required this.phone});

  final String phone;

  @override
  State<OngoingTournaments> createState() => _OngoingTournamentsState();
}

class _OngoingTournamentsState extends State<OngoingTournaments> {
  var filterText = "";
  var isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        appBar: AppBar(
          title: const Text("Tournaments"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Stack(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                    child: Column(
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
                                  fillColor:
                                      const Color.fromARGB(255, 240, 240, 245),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "Type tournament name",
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ListView(
                                children: const [Tournament(), Tournament()],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Column(
              children: [
                const Spacer(),
                Container(
                  color: const Color.fromARGB(255, 235, 235, 240),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const CreateTournament(
                                            phone: '919149764646'))));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xff554585)),
                          child: const Text("Create Tournament",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class Tournament extends StatelessWidget {
  const Tournament({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    const SelectTournamentType(phone: '919149764646'))));
      },
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/banner_tournament.png'),
                  fit: BoxFit.cover,
                ),
              ), // ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Tournament Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Ground Name',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 235, 235, 235),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: Text("Ongoing",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tournament Location",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text("Tournament Dates",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const InviteTournament(
                                    phone: '919149764646'))));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xff554585)),
                      child: const Text("Share",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
