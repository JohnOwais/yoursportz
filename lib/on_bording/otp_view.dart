// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoursportz/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:yoursportz/on_bording/login.dart';
import 'package:yoursportz/on_bording/register.dart';

class OtpView extends StatefulWidget {
  const OtpView(
      {super.key,
      required this.language,
      required this.countryCode,
      required this.phone});

  final String language;
  final String countryCode;
  final String phone;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  int secondsRemaining = 60;
  late Timer timer;
  var isLoading = false;
  var validOTP = true;
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();
  final otp5 = TextEditingController();
  final otp6 = TextEditingController();
  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  var focusNode4 = FocusNode();
  var focusNode5 = FocusNode();
  var focusNode6 = FocusNode();
  final otplessFlutterPlugin = Otpless();
  late String completePhoneNumer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> onHeadlessResult(dynamic result) async {
    if (result['responseType'] == "ONETAP") {
      if (result['statusCode'] == 200) {
        completePhoneNumer =
            widget.countryCode.replaceAll("+", "") + widget.phone;
        final body = jsonEncode(<String, dynamic>{
          'userId': completePhoneNumer,
        });
        final response = await http.post(
            Uri.parse(
                "https://yoursportzbackend.azurewebsites.net/api/auth/check-user/"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['message'] == "success") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetails(
                      language: widget.language, phone: completePhoneNumer)),
              (route) => false);
        } else {
          showDialog(
              context: context,
              builder: ((context) => Dialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: const SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: Column(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.cyan,
                              size: 100,
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Verified",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 32),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )));
          setState(() {
            isLoading = false;
          });
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(phone: completePhoneNumer)),
              (route) => false);
        }
      }
    } else if (result['response']['verification'] == "FAILED") {
      setState(() {
        validOTP = false;
        isLoading = false;
      });
    }
  }

  Future<void> startHeadlessPhoneVerify(
      String countryCode, String phoneNumber, String otp) async {
    Map<String, dynamic> arg = {};
    arg["phone"] = phoneNumber;
    arg["countryCode"] = countryCode;
    arg["otp"] = otp;
    otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Enter OTP"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text("OTP has been sent to ${widget.phone}",
                style: const TextStyle(color: Colors.grey, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 20),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode2.nextFocus();
                      }
                    },
                    controller: otp1,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode1,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode3.nextFocus();
                      }
                    },
                    controller: otp2,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode2,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode4.nextFocus();
                      }
                    },
                    controller: otp3,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode3,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode5.nextFocus();
                      }
                    },
                    controller: otp4,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode4,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode6.nextFocus();
                      }
                    },
                    controller: otp5,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode5,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        focusNode6.unfocus();
                      }
                    },
                    controller: otp6,
                    keyboardType: TextInputType.number,
                    focusNode: focusNode6,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 235, 235, 240),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide()),
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
              child: Row(
                children: [
                  validOTP
                      ? const SizedBox()
                      : const Text(
                          "Invalid OTP",
                          style: TextStyle(color: Colors.red),
                        ),
                  const Spacer(),
                  Text(
                    formatDuration(Duration(seconds: secondsRemaining)),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.lock_clock)
                ],
              ),
            ),
            const Text("Didn't received OTP?"),
            GestureDetector(
              onTap: () async {
                if (secondsRemaining == 0) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              SignIn(language: widget.language))));
                }
              },
              child: const Text("Resend OTP",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 17,
                      color: Colors.blue)),
            ),
            const SizedBox(height: 50),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      if (secondsRemaining != 0) {
                        setState(() {
                          validOTP = true;
                          isLoading = true;
                        });
                        final otp = otp1.text +
                            otp2.text +
                            otp3.text +
                            otp4.text +
                            otp5.text +
                            otp6.text;
                        startHeadlessPhoneVerify(
                            widget.countryCode, widget.phone, otp);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("OTP Expired !!!",
                                    textAlign: TextAlign.center),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3)));
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
                            child: Text("Verify",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
