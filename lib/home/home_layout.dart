import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/home/live_match.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  List highlights = ['h1', 'h2', 'h3', 'h1', 'h2'];
  List<Map<String, dynamic>> liveMatches = [];
  List<Map<String, dynamic>> ongoingMatches = [];
  var matchesLoaded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        liveMatches = [
          {'id': '', 'image': 'assets/images/ad1.jpg'},
          {'id': '', 'image': 'assets/images/ad2.jpg'},
          {'id': '', 'image': 'assets/images/ad3.jpg'},
        ];
      });
      final response = await http.get(Uri.parse(
          'https://yoursportzbackend.azurewebsites.net/api/match/all-matches/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          ongoingMatches = jsonData.cast<Map<String, dynamic>>();
          matchesLoaded = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 2,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
              ),
              items: liveMatches.map((match) {
                return GestureDetector(
                  onTap: () {
                    // Link with the live stream page using below ID:
                    match['image'];
                  },
                  child: Image.asset(
                    match['image'],
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Highlights",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 70,
                            width: 70,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/story_ring.png",
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/${highlights[index]}.png",
                                      height: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            ongoingMatches.isEmpty
                ? Column(children: [
                    const SizedBox(height: 100),
                    matchesLoaded
                        ? const Text("No Ongoing Matches")
                        : const CircularProgressIndicator()
                  ])
                : ListView.builder(
                    itemCount: ongoingMatches.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final ongoingMatch = ongoingMatches[index];
                      return ongoingMatchCard(context, ongoingMatch);
                    })
          ],
        ),
      ),
    );
  }

  Widget ongoingMatchCard(
      BuildContext context, Map<String, dynamic> ongoingMatch) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset("assets/images/img_post.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xffFFCBC2),
                          border: Border.all(
                              width: 0.5, color: const Color(0xffFF3B3B)),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Live",
                        style:
                            TextStyle(color: Color(0xffFF3B3B), fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                    child: Image.network(
                                  ongoingMatch['teamALogo'],
                                  height: 100,
                                  width: 100,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/app_logo.png',
                                      height: 100,
                                    );
                                  },
                                ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ongoingMatch['teamA'].toString().length <= 12
                                  ? ongoingMatch['teamA']
                                  : ongoingMatch['teamA']
                                      .toString()
                                      .substring(0, 12),
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                "${ongoingMatch['teamAgoals'] ?? "0"} - ${ongoingMatch['teamBgoals'] ?? "0"}",
                                style: const TextStyle(
                                    fontSize: 46,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                    child: Image.network(
                                  ongoingMatch['teamBLogo'],
                                  height: 100,
                                  width: 100,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/app_logo.png',
                                      height: 100,
                                    );
                                  },
                                ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              ongoingMatch['teamB'].toString().length <= 12
                                  ? ongoingMatch['teamB']
                                  : ongoingMatch['teamB']
                                      .toString()
                                      .substring(0, 12),
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Premier League - Regular Season",
                          style: TextStyle(
                              color: Color(0xffFFF389),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ongoingMatch['tossWon'] == ongoingMatch['teamA']
                              ? "${ongoingMatch['teamA'].toString().length <= 12 ? ongoingMatch['teamA'] : ongoingMatch['teamA'].toString().substring(0, 12)} won the toss and elected to ${ongoingMatch['kickOff'] == ongoingMatch['teamA'] ? "Kick-Off" : "Defence"}"
                              : "${ongoingMatch['teamB'].toString().length <= 12 ? ongoingMatch['teamB'] : ongoingMatch['teamB'].toString().substring(0, 12)} won the toss and elected to ${ongoingMatch['kickOff'] == ongoingMatch['teamB'] ? "Kick-Off" : "Defence"}",
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${ongoingMatch['groundName'].toString().length <= 15 ? ongoingMatch['groundName'] : ongoingMatch['groundName'].toString().substring(0, 15)} - ${ongoingMatch['groundLocation'].toString().length <= 10 ? ongoingMatch['groundLocation'] : ongoingMatch['groundLocation'].toString().substring(0, 10)}",
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LiveMatch(match: ongoingMatch)));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.1,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: const Color(0xff007AFF),
                                    borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: const Text(
                                  "View Match",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF2F2F2),
                                  borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.center,
                              child: const Text(
                                "View Info",
                                style: TextStyle(
                                    color: Color(0xff575757), fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Image.asset("assets/images/ic_emoji_4.png", height: 16),
                      Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Image.asset("assets/images/ic_emoji_2.png",
                              height: 16)),
                      Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: Image.asset("assets/images/ic_emoji_3.png",
                              height: 16)),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "120 Likes",
                    style: TextStyle(fontSize: 13, color: Color(0xff7A7A7A)),
                  )
                ],
              ),
              const Text(
                "1 Comment",
                style: TextStyle(fontSize: 13, color: Color(0xff7A7A7A)),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ReactionButton<String>(
                    onReactionChanged: (Reaction<String>? reaction) {
                      debugPrint('Selected value: ${reaction?.value}');
                    },
                    reactions: <Reaction<String>>[
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_4.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_5.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_6.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_7.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_1.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'like',
                        icon: Image.asset("assets/images/ic_emoji_2.png",
                            height: 20),
                      ),
                      Reaction<String>(
                        value: 'love',
                        icon: Image.asset("assets/images/ic_emoji_3.png",
                            height: 20),
                      ),
                    ],
                    itemAnimationDuration: const Duration(seconds: 1),
                    itemSize: const Size(20, 20),
                    selectedReaction: Reaction<String>(
                      value: 'like_fill',
                      icon: Image.asset(
                        "assets/images/ic_like.png",
                        height: 25,
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/like.png",
                          height: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          "Like",
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff7A7A7A)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/ic_comment.png",
                    height: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "Comment",
                    style: TextStyle(fontSize: 15, color: Color(0xff7A7A7A)),
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/ic_share.png",
                    height: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "Share",
                    style: TextStyle(fontSize: 15, color: Color(0xff7A7A7A)),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 8,
          color: const Color.fromARGB(255, 240, 240, 245),
        )
      ],
    );
  }
}
