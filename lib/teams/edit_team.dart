// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/teams/my_teams.dart';

class EditTeam extends StatefulWidget {
  const EditTeam(
      {super.key,
      required this.phone,
      required this.teamId,
      required this.teamLogo,
      required this.teamName,
      required this.teamCity,
      required this.teamPlayers});

  final String phone;
  final String teamId;
  final String teamLogo;
  final String teamName;
  final String teamCity;
  final List<Map<String, dynamic>> teamPlayers;

  @override
  State<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  List<Map<String, dynamic>> updatedTeamPlayers = [];
  final scrollController = ScrollController();
  var imageUrl = "null";
  late File imageFile;
  var imagePath = "null";
  var isLoading = false;
  var nameValid = true;
  var cityValid = true;

  @override
  void initState() {
    setState(() {
      nameController.text = widget.teamName;
      cityController.text = widget.teamCity;
      updatedTeamPlayers = widget.teamPlayers;
    });
    super.initState();
  }

  void getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedImage = await cropImageFile(pickedFile);
      setState(() {
        imageFile = File(croppedImage.path);
        imagePath = croppedImage.path;
      });
    }
  }

  Future<CroppedFile> cropImageFile(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: const Color(0xff554585),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
      ],
    );
    return croppedFile!;
  }

  @override
  Widget build(BuildContext context) {
    bool allPlayersHavePosition = updatedTeamPlayers.every((player) {
      return player['position'] != null && player['position'].isNotEmpty;
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        title: const Text("Edit Team"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                          child: imagePath == "null"
                              ? Image.network(
                                  widget.teamLogo,
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
                                        padding: const EdgeInsets.all(32),
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
                                      'assets/images/team_logo.png',
                                      height: 100,
                                    );
                                  },
                                )
                              : Image.file(imageFile,
                                  height: 100, width: 100))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85, 85, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ClipOval(child: Icon(Icons.camera_alt))),
                    ),
                  )
                ],
              ),
            ),
            InputText(
                controller: nameController,
                hint: "Team name",
                valid: nameValid,
                error: "Can't be less than 3 characters",
                validCharacters: 3,
                updateValid: (bool isValid) {
                  setState(() {
                    nameValid = isValid;
                  });
                }),
            InputText(
                controller: cityController,
                hint: "City",
                valid: cityValid,
                error: "Please enter a valid city",
                validCharacters: 1,
                updateValid: (bool isValid) {
                  setState(() {
                    cityValid = isValid;
                  });
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 64),
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: updatedTeamPlayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final player = updatedTeamPlayers[index];
                    return Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                  child: Image.network(
                                    player['dp'],
                                    height: 50,
                                    width: 50,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32),
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
                                        'assets/images/dp.png',
                                        height: 50,
                                        width: 50,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Remove Player"),
                                            content: Text(
                                                "Sure to remove ${player['name']}?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      updatedTeamPlayers
                                                          .remove(player);
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes",
                                                      style: TextStyle(
                                                          color: Colors.red))),
                                            ],
                                          ));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.close_outlined,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              const SizedBox(width: 16)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            child: Text(
                              player['name'].toString().length <= 15
                                  ? player['name']
                                  : player['name'].toString().substring(0, 15),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin,
                                    size: 13, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  player['city'].toString().length <= 12
                                      ? player['city']
                                      : player['city']
                                          .toString()
                                          .substring(0, 12),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: const Text("Player Position"),
                                    value: player['position'],
                                    onChanged: (String? value) {
                                      setState(() {
                                        player['position'] = value;
                                      });
                                    },
                                    items: <String>[
                                      'Goalkeeper',
                                      'Right Back',
                                      'Center Back',
                                      'Left Back',
                                      'Right Midfielder',
                                      'Center Midfielder',
                                      'Left Midfielder',
                                      'Right Winger',
                                      'Center Forward',
                                      'Left Winger',
                                      'Center Player'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
          Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddPlayer(
                                      addPlayer: (Map<String, dynamic> player) {
                                    setState(() {
                                      updatedTeamPlayers.add(player);
                                    });
                                    scrollController.animateTo(
                                      scrollController.position.maxScrollExtent,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeOut,
                                    );
                                  }));
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.white),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Text("Add Player",
                              style: TextStyle(
                                  color: Color(0xff554585),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          nameController.text = nameController.text.trim();
                          cityController.text = cityController.text.trim();
                          if (nameController.text.length < 3) {
                            setState(() {
                              nameValid = false;
                            });
                          } else if (cityController.text.isEmpty) {
                            setState(() {
                              cityValid = false;
                            });
                          } else if (updatedTeamPlayers.length < 5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Team must have minimum five players atleast",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red));
                          } else if (!allPlayersHavePosition) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select position for every player",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.orange));
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            if (nameController.text.toLowerCase() !=
                                widget.teamName.toLowerCase()) {
                              final body1 = jsonEncode(<String, dynamic>{
                                'name': nameController.text.toLowerCase()
                              });
                              final initialResponse = await http.post(
                                  Uri.parse(
                                      "https://yoursportzbackend.azurewebsites.net/api/team/check/"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: body1);
                              final Map<String, dynamic> checkResponseData =
                                  jsonDecode(initialResponse.body);
                              if (checkResponseData['message'] != "success") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Row(
                                    children: [
                                      Text("\"${nameController.text}\"",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      const Text(" already exist !!!",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  backgroundColor: Colors.orange,
                                  duration: const Duration(seconds: 3),
                                ));
                                setState(() {
                                  isLoading = false;
                                });
                                return;
                              }
                            }
                            String cleanedImageUrl = "null";
                            if (imagePath != "null") {
                              var request = http.MultipartRequest(
                                  'POST',
                                  Uri.parse(
                                      'https://yoursportzbackend.azurewebsites.net/api/upload/'));
                              request.files.add(
                                  await http.MultipartFile.fromPath(
                                      'file', imagePath));
                              var response = await request.send();
                              imageUrl = await response.stream.bytesToString();
                              cleanedImageUrl = imageUrl.replaceAll('"', '');
                            } else {
                              cleanedImageUrl = widget.teamLogo;
                            }
                            final body = jsonEncode(<String, dynamic>{
                              'teamId': widget.teamId,
                              'logo': cleanedImageUrl,
                              'name': nameController.text,
                              'city': cityController.text,
                              'players': updatedTeamPlayers
                            });
                            final response = await http.put(
                                Uri.parse(
                                    "https://yoursportzbackend.azurewebsites.net/api/team/update-team/"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                                body: body);
                            final Map<String, dynamic> responseData =
                                jsonDecode(response.body);
                            if (responseData['message'] == "success") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Row(
                                        children: [
                                          Text("Team Updated Successfully",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          SizedBox(width: 8),
                                          Icon(Icons.done_all,
                                              color: Colors.white)
                                        ],
                                      ),
                                      backgroundColor: Colors.green));
                              setState(() {
                                isLoading = false;
                              });
                              await Future.delayed(const Duration(seconds: 3));
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyTeams(phone: widget.phone)));
                            } else {
                              setState(() {
                                isLoading = false;
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
                                child: Text("Save Changes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required this.controller,
      required this.hint,
      required this.valid,
      required this.error,
      required this.validCharacters,
      required this.updateValid});

  final TextEditingController controller;
  final String hint;
  final bool valid;
  final String error;
  final int validCharacters;
  final Function(bool) updateValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          if (value.length >= validCharacters) {
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
            hintStyle: const TextStyle(fontWeight: FontWeight.normal),
            errorText: valid ? null : error),
      ),
    );
  }
}

class AddPlayer extends StatefulWidget {
  const AddPlayer({super.key, required this.addPlayer});

  final Function(Map<String, dynamic>) addPlayer;

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
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
            InputText2(
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
            InputText2(
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
            InputText2(
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
                              widget.addPlayer({
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

class InputText2 extends StatelessWidget {
  const InputText2(
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
