import 'package:flutter/material.dart';

class Teams extends StatefulWidget {
  const Teams({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(150, 200, 200, 200),
            borderRadius: BorderRadius.circular(16.0)),
        child: widget.tournament['teams'].isEmpty
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Teams Added Yet",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: widget.tournament['teams'].length,
                  itemBuilder: (context, index) {
                    final team = widget.tournament['teams'][index];
                    return TeamCard(
                      teamLogo: team['logo'],
                      teamName: team['name'],
                      city: team['city'],
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key,
      required this.teamLogo,
      required this.teamName,
      required this.city});

  final String teamLogo;
  final String teamName;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  teamLogo,
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
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    teamName.length <= 15
                        ? teamName
                        : teamName.substring(0, 15),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 107, 89, 161),
                        fontSize: 17)),
                Text(
                  city.length <= 15 ? city : city.substring(0, 15),
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),
      ),
    );
  }
}
