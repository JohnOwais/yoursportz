import 'package:flutter/material.dart';

class ShareInviteTournament extends StatefulWidget {
  const ShareInviteTournament(
      {super.key, required this.link, required this.type});

  final String link;
  final String type;

  @override
  State<ShareInviteTournament> createState() => _ShareInviteTournamentState();
}

class _ShareInviteTournamentState extends State<ShareInviteTournament> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        title:
            Text(widget.type == "share" ? 'Share Tournament' : 'Invite Teams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                          Text(
                              widget.type == "share"
                                  ? "Share Tournament Link"
                                  : "Invite Tournament Link",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(widget.link),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.type == "share"
                                  ? "Share Via QR Code"
                                  : "Invite Via QR Code",
                              style: const TextStyle(
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
          ],
        ),
      ),
    );
  }
}
