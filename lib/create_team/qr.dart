import 'package:flutter/material.dart';

class QrCode extends StatefulWidget {
  const QrCode(
      {super.key,
      required this.teamName,
      required this.city,
      required this.phone,
      required this.imageUrl});

  final String teamName;
  final String city;
  final String phone;
  final String imageUrl;

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                      child: Image.network(
                    widget.imageUrl,
                    height: 100,
                    width: 100,
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
              const SizedBox(height: 8),
              Text(widget.teamName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
              Text(widget.city, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              Image.asset('assets/images/qr.jpg', height: 200),
              const SizedBox(height: 30),
              const Text(
                  "Ask players to scan this QR Code\nto add themselves directly in team name",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xff554585)),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text("Share This Code",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
