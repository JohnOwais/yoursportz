// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yoursportz/home/change_language.dart';
import 'package:yoursportz/home/settings.dart';
import 'package:yoursportz/start_match/select_ground.dart';
import 'package:yoursportz/tournament/ongoing_tournaments.dart';
import 'package:yoursportz/create_team/create_team.dart';
import 'package:yoursportz/home/edit_profile.dart';
import 'package:yoursportz/teams/my_teams.dart';
import 'package:yoursportz/scorer/fetch_matches.dart';
import 'home_layout.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.phone});

  final String phone;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  var notifications = 0;
  Map ground = {};
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> userDetails = {'followers': [], 'profileViews': 0};
  late File imageFile;
  var imagePath = "null";
  var imageUrl = "null";
  var age = "-";

  @override
  void initState() {
    storeUserCredentials();
    if (widget.phone != "guest") {
      getUserDetails();
    }
    super.initState();
  }

  Future<void> storeUserCredentials() async {
    var currentUser = await Hive.openBox('CurrentUser');
    if (widget.phone != "guest") {
      await currentUser.put('userId', widget.phone);
    } else {
      await currentUser.put('userId', 'null');
    }
  }

  Future<void> getUserDetails() async {
    final body = jsonEncode(<String, dynamic>{'phone': widget.phone});
    final response = await http.post(
        Uri.parse(
            "https://yoursportzbackend.azurewebsites.net/api/auth/get-user/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    setState(() {
      userDetails = jsonDecode(response.body);
      age = "${calculateAge(userDetails['dob'])} Years";
    });
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
      var request = http.MultipartRequest('POST',
          Uri.parse('https://yoursportzbackend.azurewebsites.net/api/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Updating Display Picture...",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan,
        duration: Duration(seconds: 3),
      ));
      var response = await request.send();
      imageUrl = await response.stream.bytesToString();
      String cleanedImageUrl = imageUrl.replaceAll('"', '');
      final body = jsonEncode(<String, dynamic>{
        'phone': widget.phone,
        'url': cleanedImageUrl,
      });
      final finalResponse = await http.put(
          Uri.parse(
              "https://yoursportzbackend.azurewebsites.net/api/auth/update-dp/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      final Map<String, dynamic> responseData = jsonDecode(finalResponse.body);
      if (responseData['message'] == "success") {
        setState(() {
          userDetails['dp'] = cleanedImageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Text("Display Picture Updated",
                  style: TextStyle(color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.done, color: Colors.white)
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      }
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

  int calculateAge(String dob) {
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    DateTime birthDate = dateFormat.parse(dob);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: homeWidgetsAppBar(selectedIndex),
      body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            setState(() {
              selectedIndex = 0;
            });
          },
          child: homeWidgetsBody(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 250, 100, 100),
            fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          bottomItem("Home", "assets/images/bn1.png", selectedIndex == 0),
          bottomItem("Find", "assets/images/bn2.png", selectedIndex == 1),
          bottomItem("My Football", "assets/images/bottom_football.png",
              selectedIndex == 2),
          bottomItem("Profile", "assets/images/bn5.png", selectedIndex == 3),
          bottomItem("Clips", "assets/images/bn4.png", selectedIndex == 4),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 250, 100, 100),
        onTap: (val) {
          setState(() {
            selectedIndex = val;
          });
        },
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/drawer_bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(200, 200, 200, 200)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                      child: Image.network(
                                    userDetails['dp'] ?? "",
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
                                  ))),
                              Text(userDetails['name'] ?? "User's Name",
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Row(children: [
                              Text(
                                  userDetails['phone'] != null
                                      ? userDetails['phone'].length <= 25
                                          ? userDetails['phone']
                                          : userDetails['phone']
                                              .toString()
                                              .substring(0, 25)
                                      : "Phone or Email",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/go_live.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Go Live', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                // Handle navigation to Item 1
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/create_teams.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Create Team', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => CreateTeam(
                            phone: widget.phone,
                            ground: ground,
                            source: "home"))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/my_teams.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('My Teams', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => MyTeams(phone: widget.phone))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/start_match.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Start A Match', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            SelectGround(phone: widget.phone))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/start_tournament.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Start A Tournament',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            OngoingTournaments(phone: widget.phone))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/performance.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Show My Performance',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                // Handle navigation to Item 1
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/premium.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Premium Features',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                // Handle navigation to Item 1
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/admin.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Admin', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                // Handle navigation to Item 1
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/ads.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('My Ads', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                // Handle navigation to Item 1
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/share.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Share With Friends',
                      style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Share.share(
                    'Download YourSportz on the App Store and Google Play to stay connected with your local football arena! 📲⚽\n\n👉 iOS App: https://www.apple.com/in/search/YourSportz \n\n👉 Android App: https://play.google.com/store/apps/details?id=com.eternachat.app');
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/change_language.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Change Language', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            ChangeLanguage(phone: widget.phone))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/settings.png',
                    height: 25,
                  ),
                  const SizedBox(width: 8),
                  const Text('Settings', style: TextStyle(fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => Settings(phone: widget.phone))));
              },
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomItem(
      String name, String image, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          image,
          height: 20,
          width: 20,
          color: isSelected
              ? const Color.fromARGB(255, 250, 100, 100)
              : Colors.grey,
        ),
      ),
      label: name,
    );
  }

  Widget homeWidgetsBody(int index) {
    switch (index) {
      case 0:
        return const HomeLayout();
      case 1:
        return Container();
      case 2:
        return MyFootball(
          phone: widget.phone,
        );
      case 3:
        return Container();
      case 4:
        return Container();
      default:
        return Container();
    }
  }

  AppBar homeWidgetsAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          elevation: 6,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          toolbarHeight: 130,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset(
                          "assets/images/menu.png",
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 7),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 240, 240),
                            border: Border.all(
                                color: const Color(0xffBE2929), width: 0),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/ic_play.png",
                              height: 25,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FetchMatches(phone: widget.phone)));
                              },
                              child: const Text(
                                "Go Live",
                                style: TextStyle(
                                    color: Color(0xffBE2929), fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectGround(phone: widget.phone)))
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 7),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 240, 240, 250),
                              border: Border.all(
                                  color: const Color(0xff413566), width: 0),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/ic_foot_ic.png",
                                height: 25,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              const Text(
                                "Play",
                                style: TextStyle(
                                    color: Color(0xff413566), fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Stack(children: [
                        Image.asset(
                          "assets/images/notification.png",
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                          child: Text(
                            notifications.toString(),
                            style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 240, 245),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 0.5, color: const Color(0xff7A7A7A))),
                      child: const TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xff7A7A7A),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 7),
                            hintText: "Search",
                            hintStyle: TextStyle(
                                color: Color(0xff7A7A7A),
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset("assets/images/qr.jpg", height: 35, width: 35)
                ],
              )
            ],
          ),
        );
      case 1:
        return AppBar(
            leadingWidth: 0,
            elevation: 6,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            foregroundColor: Colors.white,
            scrolledUnderElevation: 0,
            toolbarHeight: 130,
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 240, 245),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.5, color: const Color(0xff7A7A7A))),
                        child: const TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xff7A7A7A),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 7),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Color(0xff7A7A7A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
      case 2:
        return AppBar(
          leadingWidth: 0,
          elevation: 6,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          toolbarHeight: 130,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("My Football",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: const Text(
                        "Matches",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Tournaments",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      case 3:
        return AppBar(
          leadingWidth: 0,
          elevation: 6,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          toolbarHeight: 300,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userDetails['name'] ?? "User's Name",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                    phone: widget.phone,
                                    userDetails: userDetails,
                                    updateUserDetails: (Map<String, dynamic>
                                        updatedUserDetails) {
                                      setState(() {
                                        userDetails = updatedUserDetails;
                                        age =
                                            "${calculateAge(userDetails['dob'])} Years";
                                      });
                                    })));
                      },
                      child: const Row(
                        children: [
                          Text("Edit",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                          SizedBox(width: 4),
                          Icon(Icons.edit_note, color: Colors.black),
                        ],
                      ))
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                            child: Image.network(
                          userDetails['dp'] ?? "",
                          height: 70,
                          width: 70,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                              height: 70,
                            );
                          },
                        ))),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 60, 0, 0),
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
                Column(
                  children: [
                    Text(userDetails['followers'].length.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Text(
                      "Followers",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text((userDetails['profileViews']).toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Text(
                      "Profile Views",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/qr.jpg',
                      height: 20,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "QR Code",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox()
              ]),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text(userDetails['position'] ?? "Player Position",
                    style: const TextStyle(fontSize: 17, color: Colors.black)),
              ),
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.grey, size: 15),
                  const SizedBox(width: 4),
                  Text(userDetails['city'] ?? "City",
                      style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(userDetails['height'] ?? "-",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(
                        "Height",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(age,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        userDetails['dob'] ?? "Date of Birth",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(userDetails['foot'] ?? "-",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(
                        "Preffered Foot",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(userDetails['country'] ?? "-",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text(
                        "Country",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      case 4:
        return AppBar(
            leadingWidth: 0,
            elevation: 6,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            foregroundColor: Colors.white,
            scrolledUnderElevation: 0,
            toolbarHeight: 130,
            backgroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Clips",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 240, 245),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 0.5, color: const Color(0xff7A7A7A))),
                        child: const TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xff7A7A7A),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 7),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Color(0xff7A7A7A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
      default:
        return AppBar();
    }
  }

  Widget optionMenu(String name, String image, dynamic onTap) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: const Color(0xffF2F2F2),
      width: 300,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/$image",
                height: 20,
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: Text(
                  name,
                  style:
                      const TextStyle(color: Color(0xff575757), fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyFootball extends StatelessWidget {
  const MyFootball({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You haven't started a match yet. To start a Match.\nclick the below button",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectGround(
                            phone: phone,
                          )));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text("Start a Match",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
