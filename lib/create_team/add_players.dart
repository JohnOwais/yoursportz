// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:yoursportz/create_team/selected_players.dart';

List<Map<String, dynamic>> selectedPlayers = [];

class AddPlayers extends StatefulWidget {
  const AddPlayers(
      {super.key,
      required this.ground,
      required this.teamName,
      required this.city,
      required this.phone,
      required this.imageUrl,
      required this.source,
      required this.token,
      required this.selfAdd});

  final Map ground;
  final String teamName;
  final String city;
  final String phone;
  final String imageUrl;
  final String source;
  final String token;
  final bool selfAdd;

  @override
  State<AddPlayers> createState() => _AddPlayersState();
}

class _AddPlayersState extends State<AddPlayers> {
  List<Map<String, dynamic>> players = [];
  var filterText = "";
  var userLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectedPlayers.clear();
      final response = await http.get(Uri.parse(
          'https://yoursportzbackend.azurewebsites.net/api/user/all/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          players = jsonData.cast<Map<String, dynamic>>();
          userLoading = false;
        });
      }
    });
    super.initState();
  }

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
                      'assets/images/app_logo.png',
                      height: 35,
                    );
                  },
                ))),
            Text(widget.teamName.length <= 15
                ? widget.teamName
                : widget.teamName.substring(0, 15)),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
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
                    fillColor: const Color.fromARGB(255, 240, 240, 245),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search for the players",
                    hintStyle: const TextStyle(fontWeight: FontWeight.normal)),
              ),
            ),
          ),
          filterText.isEmpty
              ? Expanded(
                  child: Center(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 16),
                      child: Text(
                        "Now create multiple players and add them to your team instantly to build your team",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => const AddExtraPlayer());
                        },
                        child: const Text("Add Player",
                            style: TextStyle(color: Colors.white))),
                  ],
                )))
              : userLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            final player = players[index];
                            final willAddSelf = widget.selfAdd
                                ? true
                                : widget.phone != player['phone'];
                            return player['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(filterText.toLowerCase()) &&
                                    willAddSelf
                                ? Player(
                                    dp: player['dp'],
                                    name: player['name'],
                                    phone: player['phone'],
                                    city: player['city'],
                                    index: index,
                                    remove: (i) {
                                      setState(() {
                                        players.removeAt(i);
                                      });
                                    })
                                : const SizedBox();
                          },
                        ),
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share(
                          'Download YourSportz on the App Store and Google Play to stay connected with your local football arena! 📲⚽\n\n👉 iOS App: https://www.apple.com/in/search/YourSportz \n\n👉 Android App: https://play.google.com/store/apps/details?id=com.eternachat.app');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => InvitePlayers(
                      //             teamName: widget.teamName,
                      //             city: widget.city,
                      //             phone: widget.phone,
                      //             imageUrl: widget.imageUrl,
                      //             token: widget.token)));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Invite Players",
                          style: TextStyle(
                              color: Color(0xff554585),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedPlayers.length < 5) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Plesae add atleast 5 players",
                              style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.orange,
                        ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SelectedPlayers(
                                    selectedPlayers: selectedPlayers,
                                    ground: widget.ground,
                                    teamName: widget.teamName,
                                    city: widget.city,
                                    phone: widget.phone,
                                    imageUrl: widget.imageUrl,
                                    source: widget.source))));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: const Color(0xff554585)),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AddExtraPlayer extends StatefulWidget {
  const AddExtraPlayer({
    super.key,
  });

  @override
  State<AddExtraPlayer> createState() => _AddExtraPlayerState();
}

class _AddExtraPlayerState extends State<AddExtraPlayer> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final userController = TextEditingController();
  var nameValid = true;
  var cityValid = true;
  var userValid = true;
  var isLoading = false;
  var usernameTaken = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Add Player", style: TextStyle(fontSize: 20)),
            ),
            InputText(
                controller: nameController,
                icon: Icons.person,
                hint: "Player Name",
                min: 3,
                max: 30,
                error: "Can't be less than 3 characters",
                valid: nameValid,
                updateValid: (bool isValid) {
                  setState(() {
                    nameValid = isValid;
                  });
                }),
            InputText(
                controller: cityController,
                icon: Icons.location_city,
                hint: "City",
                min: 1,
                max: 20,
                error: "Can't be empty",
                valid: cityValid,
                updateValid: (bool isValid) {
                  setState(() {
                    cityValid = isValid;
                  });
                }),
            InputText(
                controller: userController,
                icon: Icons.person_2_outlined,
                hint: "Username",
                min: 3,
                max: 10,
                error: "Can't be less than 3 characters",
                valid: userValid,
                updateValid: (bool isValid) {
                  setState(() {
                    userValid = isValid;
                  });
                }),
            usernameTaken
                ? const Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Text("Username already taken",
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          usernameTaken = false;
                        });
                        nameController.text = nameController.text.trim();
                        cityController.text = cityController.text.trim();
                        userController.text = userController.text.trim();
                        userController.text =
                            userController.text.replaceAll(" ", "");
                        if (nameController.text.length < 3) {
                          setState(() {
                            nameValid = false;
                          });
                        } else if (cityController.text.isEmpty) {
                          setState(() {
                            cityValid = false;
                          });
                        } else if (userController.text.length < 3) {
                          setState(() {
                            userValid = false;
                          });
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          final body = jsonEncode(
                              <String, dynamic>{'userId': userController.text});
                          final response = await http.post(
                              Uri.parse(
                                  "https://yoursportzbackend.azurewebsites.net/api/auth/check-user/"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: body);
                          final Map<String, dynamic> responseData =
                              jsonDecode(response.body);
                          if (responseData['message'] == "success") {
                            final body = jsonEncode(<String, dynamic>{
                              'phone': userController.text,
                              'name': nameController.text,
                              'city': cityController.text,
                            });
                            final response = await http.put(
                                Uri.parse(
                                    "https://yoursportzbackend.azurewebsites.net/api/auth/save/"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                                body: body);
                            final Map<String, dynamic> responseData =
                                jsonDecode(response.body);
                            if (responseData['message'] == "success") {
                              setState(() {
                                isLoading = false;
                              });
                              selectedPlayers.add({
                                'dp': "",
                                'phone': userController.text,
                                'name': nameController.text,
                                'city': cityController.text,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Player added to team successfully",
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                              ));
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              isLoading = false;
                              usernameTaken = true;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xff554585)),
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(
                                    color: Colors.white),
                              ))
                          : const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text("Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        )));
  }
}

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required this.controller,
      required this.icon,
      required this.hint,
      required this.min,
      required this.max,
      required this.error,
      required this.valid,
      required this.updateValid});

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final int min;
  final int max;
  final String error;
  final bool valid;
  final Function(bool) updateValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(max)],
        onChanged: (value) {
          if (value.length >= min) {
            updateValid(true);
          }
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            hintText: hint,
            prefixIcon: Icon(icon),
            errorText: valid ? null : error),
      ),
    );
  }
}

class Player extends StatefulWidget {
  const Player(
      {super.key,
      required this.dp,
      required this.name,
      required this.phone,
      required this.city,
      required this.index,
      required this.remove});

  final String dp;
  final String name;
  final String phone;
  final String city;
  final int index;
  final Function(int) remove;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Row(
          children: [
            CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                    child: Image.network(
                  widget.dp,
                  height: 50,
                  width: 50,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
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
                      'assets/images/dp.png',
                      height: 50,
                      width: 50,
                    );
                  },
                ))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.city,
                    style: const TextStyle(fontSize: 13, color: Colors.grey))
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedPlayers.add({
                    'dp': widget.dp,
                    'name': widget.name,
                    'phone': widget.phone,
                    'city': widget.city,
                  });
                  widget.remove(widget.index);
                });
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.cyan),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text("ADD",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8)
          ],
        ));
  }
}
