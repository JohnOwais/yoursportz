import 'package:flutter/material.dart';
import 'package:yoursportz/create_team/qr.dart';

class InvitePlayers extends StatefulWidget {
  const InvitePlayers(
      {super.key,
      required this.teamName,
      required this.city,
      required this.phone,
      required this.imageUrl,
      required this.token});

  final String teamName;
  final String city;
  final String phone;
  final String imageUrl;
  final String token;

  @override
  State<InvitePlayers> createState() => _InvitePlayersState();
}

class _InvitePlayersState extends State<InvitePlayers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 245),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  widget.imageUrl,
                  height: 35,
                  width: 35,
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
                      'assets/images/team.png',
                      height: 35,
                    );
                  },
                ))),
            Text(widget.teamName)
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Share this link with players",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(widget.token),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text("Copy",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text("Share",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              child:
                  Text("Or Scan the QR Code", style: TextStyle(fontSize: 20)),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Image.asset('assets/images/qr.jpg', height: 100),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Team QR Code",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Ask players to scan this QR Code",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QrCode(
                                                teamName: widget.teamName,
                                                city: widget.city,
                                                phone: widget.phone,
                                                imageUrl: widget.imageUrl)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.blue),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text("Share",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ])),
          ],
        ),
      ),
    );
  }
}
