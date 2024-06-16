// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:yoursportz/helper/country_codes.dart';
import 'package:yoursportz/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:yoursportz/on_bording/otp_view.dart';
import 'dart:io';
import 'package:yoursportz/on_bording/register.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.language});

  final String language;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final otplessFlutterPlugin = Otpless();
  final controller = TextEditingController();
  String selectedCountryCode = '+91';
  var valid = true;
  var validNumber = false;
  var isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  var providedCountryCode = "";
  var providedPhoneNumber = "";
  var socialLoginLoading = false;
  Map<String, dynamic> completeResponse = {};

  @override
  void initState() {
    super.initState();
    otplessFlutterPlugin.initHeadless("H6NVDI88B5QUHH6UG60Z");
    otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
  }

  Future<void> onHeadlessResult(dynamic result) async {
    if (result['response']['channel'] == "PHONE") {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => OtpView(
                  language: widget.language,
                  countryCode: providedCountryCode,
                  phone: providedPhoneNumber))));
    } else {
      if (result['responseType'] == "ONETAP") {
        if (result['statusCode'] == 200) {
          setState(() {
            socialLoginLoading = true;
          });
          final userID = result['response']['identities'][0]['identityValue'];
          final body = jsonEncode(<String, dynamic>{'userId': userID});
          final response = await http.post(
              Uri.parse(
                  "https://yoursportzbackend.azurewebsites.net/api/auth/check-user/"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body);
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          if (responseData['message'] == "success") {
            setState(() {
              socialLoginLoading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => UserDetails(
                        language: widget.language, phone: userID))));
          } else {
            setState(() {
              socialLoginLoading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => HomeScreen(phone: userID))));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Authentication Failed !!!"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3)));
        }
      }
    }
  }

  Future<void> startHeadless(String channelType) async {
    Map<String, dynamic> arg = {'channelType': channelType};
    otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

  Future<void> startHeadlessPhone(
      String countryCode, String phoneNumber) async {
    Map<String, dynamic> arg = {};
    arg["phone"] = phoneNumber;
    arg["countryCode"] = countryCode;
    otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/app_icon.png', height: 50),
                    const SizedBox(
                      height: 8,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Your",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff554585))),
                        Text("Sportz",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ],
                    ),
                    Text("Game it your way",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.7))),
                    const SizedBox(height: 48),
                    TextField(
                        controller: controller,
                        onChanged: (String value) {
                          setState(() {
                            if (value.length == 10) {
                              setState(() {
                                validNumber = true;
                                valid = true;
                              });
                            } else {
                              setState(() {
                                validNumber = false;
                              });
                            }
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 240, 240, 245),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: DropdownButton<String>(
                                  underline: Container(height: 0),
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  value: selectedCountryCode,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCountryCode = newValue!;
                                    });
                                  },
                                  items: countryCodes
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                            hintText: "Enter your phone number",
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.normal),
                            errorText:
                                valid ? null : "Can't be less than 10 digits.",
                            errorStyle: const TextStyle(
                                backgroundColor: Colors.white,
                                fontWeight: FontWeight.bold),
                            suffixIcon: validNumber
                                ? const Icon(Icons.check_box_rounded,
                                    color: Colors.green)
                                : null)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () async {
                            if (controller.text.length < 10) {
                              setState(() {
                                valid = false;
                              });
                            } else {
                              setState(() {
                                isLoading = true;
                                providedCountryCode = selectedCountryCode;
                                providedPhoneNumber = controller.text;
                              });
                              startHeadlessPhone(
                                  selectedCountryCode, controller.text);
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
                                  child: Text("Sign In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                        )),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("OR",
                          style: TextStyle(fontSize: 17, color: Colors.grey)),
                    ),
                    socialLoginLoading
                        ? const Padding(
                            padding: EdgeInsets.all(3),
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  startHeadless("WHATSAPP");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                          child: Image.asset(
                                        'assets/images/whatsapp_icon.png',
                                        height: 70,
                                      ))),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  startHeadless("GMAIL");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                          child: Image.asset(
                                        'assets/images/google_icon.png',
                                        height: 70,
                                      ))),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  startHeadless("FACEBOOK");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                          child: Image.asset(
                                        'assets/images/facebook_icon.png',
                                        height: 70,
                                      ))),
                                ),
                              ),
                              if (Platform.isIOS)
                                GestureDetector(
                                  onTap: () {
                                    startHeadless("APPLE");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                            child: Image.asset(
                                          'assets/images/apple_icon.png',
                                          height: 70,
                                        ))),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  startHeadless("TWITTER");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                          child: Image.asset(
                                        'assets/images/x_icon.png',
                                        height: 70,
                                      ))),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomeScreen(phone: "guest")),
                            (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 245)),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("Sign In as Guest",
                            style: TextStyle(
                                color: Color(0xff554585),
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
