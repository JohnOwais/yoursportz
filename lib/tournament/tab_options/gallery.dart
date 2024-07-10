import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final List<String> imagePaths = [
    'assets/images/ad1.jpg',
    'assets/images/ad2.jpg',
    'assets/images/ad3.jpg',
    'assets/images/ad2.jpg',
    'assets/images/ad3.jpg',
    'assets/images/ad1.jpg',
    'assets/images/ad3.jpg',
    'assets/images/ad1.jpg',
    'assets/images/ad2.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(150, 200, 200, 200),
            borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(imagePaths[index]);
            },
          ),
        ),
      ),
    );
  }
}
