// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yoursportz/tournament/tournament_type.dart';

class CreateTournament extends StatefulWidget {
  const CreateTournament({super.key, required this.phone});

  final String phone;

  @override
  State<CreateTournament> createState() => _CreateTournamentState();
}

class _CreateTournamentState extends State<CreateTournament> {
  var imageUrl = "null";
  late File imageFile, bannerImageFile;
  var imagePath = "null", bannerImagePath = "null";
  final tournamentNameController = TextEditingController();
  final organizerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final groundController = TextEditingController();
  var numberOfTeams;
  var numberOfGroups;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  var gameTime;
  var firstHalf = "First half";
  final detailsController = TextEditingController();
  var tournamentNameValid = true;
  var organiserNameValid = true;
  var phoneValid = true;
  var cityValid = true;
  var groundValid = true;
  var startDate = "Start date";
  var endDate = "End date";
  var selectedCategory = "School";
  var isLoading = false;
  final DateFormat dateFormat = DateFormat('dd-MMM-yyy');
  var groupOptions = ['1'];

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

  void getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedImage = await cropBannerImageFile(pickedFile);
      setState(() {
        bannerImageFile = File(croppedImage.path);
        bannerImagePath = croppedImage.path;
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

  Future<CroppedFile> cropBannerImageFile(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio3x2],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: const Color(0xff554585),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
      ],
    );
    return croppedFile!;
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
        startDate = dateFormat.format(picked);
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
        endDate = dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        appBar: AppBar(
          title: const Text(
            "Create A Tournament",
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 65),
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                getBannerImage();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 235, 235, 240),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: bannerImagePath == "null"
                                          ? Image.asset(
                                              'assets/images/banner.png')
                                          : Image.file(bannerImageFile))),
                            ),
                          ),
                          Center(
                            child: Stack(children: [
                              CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                      child: imagePath == "null"
                                          ? Image.asset(
                                              'assets/images/team_logo.png',
                                              height: 100,
                                              width: 100,
                                            )
                                          : Image.file(imageFile,
                                              height: 95, width: 95))),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(65, 65, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                          child: Icon(Icons.camera_alt))),
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Label(text: "Tournament Name"),
                      InputText(
                        icon: Icons.event,
                        hint: "Enter tournament name",
                        keyboard: TextInputType.text,
                        min: 5,
                        max: 30,
                        controller: tournamentNameController,
                        valid: tournamentNameValid,
                        error: "Can't be less than 5 characters",
                        updateValid: (bool isValid) {
                          setState(() {
                            tournamentNameValid = isValid;
                          });
                        },
                      ),
                      const Label(text: "Organizer Name"),
                      InputText(
                        icon: Icons.person,
                        hint: "Enter organizer name",
                        keyboard: TextInputType.name,
                        min: 3,
                        max: 30,
                        controller: organizerNameController,
                        valid: organiserNameValid,
                        error: "Can't be less than 3 characters",
                        updateValid: (bool isValid) {
                          setState(() {
                            organiserNameValid = isValid;
                          });
                        },
                      ),
                      const Label(text: "Contact Number"),
                      InputText(
                        icon: Icons.phone,
                        hint: "Enter contact number",
                        keyboard: TextInputType.number,
                        min: 10,
                        max: 10,
                        controller: phoneController,
                        valid: phoneValid,
                        error: "Invalid phone number",
                        updateValid: (bool isValid) {
                          setState(() {
                            phoneValid = isValid;
                          });
                        },
                      ),
                      const Label(text: "Location"),
                      InputText(
                        icon: Icons.place,
                        hint: "Enter city",
                        keyboard: TextInputType.streetAddress,
                        min: 1,
                        max: 20,
                        controller: cityController,
                        valid: cityValid,
                        error: "Invalid city",
                        updateValid: (bool isValid) {
                          setState(() {
                            cityValid = isValid;
                          });
                        },
                      ),
                      const Label(text: "Ground Name"),
                      Row(
                        children: [
                          Expanded(
                            child: InputText(
                              icon: Icons.sports_football_outlined,
                              hint: "Enter ground name",
                              keyboard: TextInputType.text,
                              min: 5,
                              max: 30,
                              controller: groundController,
                              valid: groundValid,
                              error: "Can't be less than 5 characters",
                              updateValid: (bool isValid) {
                                setState(() {
                                  groundValid = isValid;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                border:
                                    Border.all(width: 2, color: Colors.grey)),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.add, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      const Label(text: "Number of Teams"),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  hint: const Text("Select number of teams"),
                                  icon: const SizedBox(),
                                  value: numberOfTeams,
                                  underline: const SizedBox(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      numberOfTeams = value!;
                                      if (int.parse(numberOfTeams) < 8) {
                                        numberOfGroups = '1';
                                      } else if (numberOfTeams == '8' ||
                                          numberOfTeams == '10' ||
                                          numberOfTeams == '14') {
                                        numberOfGroups = null;
                                        groupOptions = ['1', '2'];
                                      } else if (numberOfTeams == '12' ||
                                          numberOfTeams == '18') {
                                        numberOfGroups = null;
                                        groupOptions = ['1', '2', '3'];
                                      } else if (numberOfTeams == '16') {
                                        numberOfGroups = null;
                                        groupOptions = ['1', '2', '4'];
                                      } else if (numberOfTeams == '20') {
                                        numberOfGroups = null;
                                        groupOptions = ['2', '4', '5'];
                                      } else if (numberOfTeams == '22' ||
                                          numberOfTeams == '26') {
                                        numberOfGroups = '2';
                                        groupOptions = ['2'];
                                      } else if (numberOfTeams == '24') {
                                        numberOfGroups = null;
                                        groupOptions = ['2', '3', '4', '6'];
                                      } else if (numberOfTeams == '28') {
                                        numberOfGroups = null;
                                        groupOptions = ['2', '4', '7'];
                                      } else if (numberOfTeams == '30') {
                                        numberOfGroups = null;
                                        groupOptions = ['2', '3', '5', '6'];
                                      }
                                    });
                                  },
                                  items: <String>[
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '10',
                                    '12',
                                    '14',
                                    '16',
                                    '18',
                                    '20',
                                    '22',
                                    '24',
                                    '26',
                                    '28',
                                    '30',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xff554585))
                            ],
                          ),
                        ),
                      ),
                      const Label(text: "Number of Groups"),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  hint: const Text("Select number of groups"),
                                  icon: const SizedBox(),
                                  value: numberOfGroups,
                                  underline: const SizedBox(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      numberOfGroups = value!;
                                    });
                                  },
                                  items: groupOptions
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Color(0xff554585))
                            ],
                          ),
                        ),
                      ),
                      const Label(text: "Tournament Date"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () => {selectStartDate(context)},
                                child: Date(
                                    text: startDate, icon: Icons.date_range)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                                onTap: () => {selectEndDate(context)},
                                child: Date(
                                    text: endDate, icon: Icons.date_range)),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Text("*Game Time",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: Text("*First Half",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            width: 0,
                                            color: const Color(0xff7A7A7A))),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 16, 4),
                                      child: DropdownButton<String>(
                                        hint: const Text("Game time"),
                                        value: gameTime,
                                        underline: const SizedBox(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            gameTime = value!;
                                            if (gameTime == "30 minutes") {
                                              firstHalf = "15 minutes";
                                            } else if (gameTime ==
                                                "60 minutes") {
                                              firstHalf = "30 minutes";
                                            } else if (gameTime ==
                                                "90 minutes") {
                                              firstHalf = "45 minutes";
                                            }
                                          });
                                        },
                                        items: <String>[
                                          '30 minutes',
                                          '60 minutes',
                                          '90 minutes'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ))),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            width: 0,
                                            color: const Color(0xff7A7A7A))),
                                    child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(firstHalf,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: firstHalf == "First half"
                                                    ? Colors.grey
                                                    : null))))),
                          ),
                        ],
                      ),
                      const Label(text: "Tournament Catagory"),
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "School";
                                  });
                                },
                                child: Catagory(
                                    label: "School",
                                    selected: selectedCategory == "School"
                                        ? true
                                        : false),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "College";
                                  });
                                },
                                child: Catagory(
                                    label: "College",
                                    selected: selectedCategory == "College"
                                        ? true
                                        : false),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "University";
                                  });
                                },
                                child: Catagory(
                                    label: "University",
                                    selected: selectedCategory == "University"
                                        ? true
                                        : false),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "Corporate";
                                  });
                                },
                                child: Catagory(
                                    label: "Corporate",
                                    selected: selectedCategory == "Corporate"
                                        ? true
                                        : false),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "Open Tournament";
                                  });
                                },
                                child: Catagory(
                                    label: "Open Tournament",
                                    selected:
                                        selectedCategory == "Open Tournament"
                                            ? true
                                            : false),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = "Others";
                                  });
                                },
                                child: Catagory(
                                    label: "Others",
                                    selected: selectedCategory == "Others"
                                        ? true
                                        : false),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Label(text: "Add More Details"),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: detailsController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: "Enter Details",
                            hintStyle: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ]),
              )),
            ),
            Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          if (tournamentNameController.text.length < 5) {
                            setState(() {
                              tournamentNameValid = false;
                            });
                          } else if (organizerNameController.text.length < 3) {
                            setState(() {
                              organiserNameValid = false;
                            });
                          } else if (phoneController.text.length < 10) {
                            setState(() {
                              phoneValid = false;
                            });
                          } else if (cityController.text.isEmpty) {
                            setState(() {
                              cityValid = false;
                            });
                          } else if (groundController.text.length < 5) {
                            setState(() {
                              groundValid = false;
                            });
                          } else if (numberOfTeams == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select number of teams first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)));
                          } else if (numberOfGroups == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select number of groups first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)));
                          } else if (startDate == "Start date") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select tournament start date first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)));
                          } else if (endDate == "End date") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select tournament end date first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)));
                          } else if (gameTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select game time first",
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3)));
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            String cleanedImageUrl = "null";
                            if (imagePath != "null") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Uploading logo...",
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.cyan,
                                duration: Duration(seconds: 2),
                              ));
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
                            }
                            String cleanedBannerImageUrl = "null";
                            if (cleanedImageUrl != "error") {
                              if (bannerImagePath != "null") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Uploading banner image...",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.cyan,
                                  duration: Duration(seconds: 3),
                                ));
                                var request = http.MultipartRequest(
                                    'POST',
                                    Uri.parse(
                                        'https://yoursportzbackend.azurewebsites.net/api/upload/'));
                                request.files.add(
                                    await http.MultipartFile.fromPath(
                                        'file', bannerImagePath));
                                var response = await request.send();
                                imageUrl =
                                    await response.stream.bytesToString();
                                cleanedBannerImageUrl =
                                    imageUrl.replaceAll('"', '');
                              }
                            }
                            if (cleanedBannerImageUrl != "error") {
                              final body = jsonEncode(<String, dynamic>{
                                'phone': widget.phone,
                                'logoUrl': cleanedImageUrl,
                                'bannerUrl': cleanedBannerImageUrl,
                                'tournamentName': tournamentNameController.text,
                                'organizerName': organizerNameController.text,
                                'organizerPhone': phoneController.text,
                                'city': cityController.text,
                                'groundNames': [groundController.text],
                                'numberOfTeams': numberOfTeams,
                                'numberOfGroups': numberOfGroups,
                                'startDate': startDate,
                                'endDate': endDate,
                                'gameTime': gameTime,
                                'firstHalf': firstHalf,
                                'tournamentCategory': selectedCategory,
                                'additionalDetails': detailsController.text,
                                'teams': [],
                                'tournamentType': "null"
                              });
                              final response = await http.post(
                                  Uri.parse(
                                      "https://yoursportzbackend.azurewebsites.net/api/tournament/create/"),
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
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            SelectTournamentType(
                                                phone: widget.phone,
                                                tournamentId:
                                                    responseData['id']))));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Row(
                                          children: [
                                            Text(
                                                "Tournament Created Successfully",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            SizedBox(width: 8),
                                            Icon(Icons.done_all,
                                                color: Colors.white)
                                          ],
                                        ),
                                        backgroundColor: Colors.green));
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Server Error. Failed to create tournament !!!",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3)));
                              }
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
                                child: Text("Create Tournament",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                      )),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class Date extends StatefulWidget {
  const Date({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 0, color: const Color(0xff7A7A7A))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(widget.text,
                    style: TextStyle(
                        fontSize: 17,
                        color: widget.text[0].startsWith(RegExp(r'\d'))
                            ? null
                            : Colors.grey)),
                const Spacer(),
                Icon(widget.icon)
              ],
            ),
          )),
    );
  }
}

class Catagory extends StatelessWidget {
  const Catagory({super.key, required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                width: 0, color: selected ? Colors.blue : Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Text(label,
              style: TextStyle(color: selected ? Colors.white : Colors.grey)),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  const Label({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required this.icon,
      required this.hint,
      required this.keyboard,
      required this.min,
      required this.max,
      required this.controller,
      required this.valid,
      required this.error,
      required this.updateValid});

  final IconData icon;
  final String hint;
  final TextInputType keyboard;
  final int min;
  final int max;
  final TextEditingController controller;
  final bool valid;
  final String error;
  final Function(bool) updateValid;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: [LengthLimitingTextInputFormatter(max)],
      onChanged: (value) {
        if (value.length >= min) {
          updateValid(true);
        }
      },
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          hintText: hint,
          errorText: valid ? null : error,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal)),
    );
  }
}
