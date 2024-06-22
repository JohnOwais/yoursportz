import 'package:flutter/material.dart';

class InviteTournament extends StatefulWidget {
  const InviteTournament({super.key, required this.phone});
  final String phone;
  @override
  State<InviteTournament> createState() => _InviteTournamentState();
}

class _InviteTournamentState extends State<InviteTournament> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        title: const Text('Invite Teams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Share Tournament Link",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(
                              'https://hgdsfgasdhfgasdhfgasdjfkh/fgjdsgfasdhfghds/fgjhasdfhjgfdasjhgfasjfg'),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Add Via QR Code",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Image.asset(
                            "assets/images/qr.jpg",
                            height: 50,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("Add Manually",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
