import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/scorer/scorer_view.dart';

class FetchMatches extends StatefulWidget {
  const FetchMatches({super.key, required this.phone});

  final String phone;

  @override
  State<FetchMatches> createState() => _FetchMatchesState();
}

class _FetchMatchesState extends State<FetchMatches> {
  List<Map<String, dynamic>> matches = [];
  var filterText = "";
  var matchesLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final body = jsonEncode(<String, dynamic>{'phone': widget.phone});
      final response = await http.post(
          Uri.parse(
              "https://yoursportzbackend.azurewebsites.net/api/match/matches-by-scorer/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          matches = jsonData.cast<Map<String, dynamic>>();
          matchesLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Upcoming Matches"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(children: [
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
                  fillColor: const Color.fromARGB(255, 240, 240, 245),
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search team name",
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal)),
            ),
          ),
        ),
        matchesLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
                child: matches.isEmpty
                    ? const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Matches Available",
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 8),
                          Text("You are not assined as scorer for any match.",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListView.builder(
                            itemCount: matches.length,
                            itemBuilder: (context, index) {
                              final match = matches[index];
                              return match['teamA']
                                          .toString()
                                          .toLowerCase()
                                          .contains(filterText.toLowerCase()) ||
                                      match['teamB']
                                          .toString()
                                          .toLowerCase()
                                          .contains(filterText.toLowerCase())
                                  ? MatchDetails(match: match)
                                  : const SizedBox();
                            }),
                      ))
      ]),
    );
  }
}

class MatchDetails extends StatefulWidget {
  const MatchDetails({
    super.key,
    required this.match,
  });

  final Map<String, dynamic> match;

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScorerView(match: widget.match)));
        },
        child: Card(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                                child: Image.network(
                              widget.match['teamALogo'],
                              height: 40,
                              width: 40,
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/app_logo.png',
                                  height: 40,
                                );
                              },
                            ))),
                        const Text("Team A",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Text(
                            widget.match['teamA'].length <= 15
                                ? widget.match['teamA']
                                : "${widget.match['teamA'].substring(0, 15)}...",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.blueGrey, fontSize: 13)),
                      )
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/vs.png',
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                                child: Image.network(
                              widget.match['teamBLogo'],
                              height: 40,
                              width: 40,
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/app_logo.png',
                                  height: 40,
                                );
                              },
                            ))),
                        const Text("Team B",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20)
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Text(
                            widget.match['teamB'].length <= 15
                                ? widget.match['teamB']
                                : "${widget.match['teamB'].substring(0, 15)}...",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.blueGrey, fontSize: 13)),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
