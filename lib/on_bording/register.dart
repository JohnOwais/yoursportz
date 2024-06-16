// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yoursportz/home/home_screen.dart';
import 'package:http/http.dart' as http;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.language, required this.phone});

  final String language;
  final String phone;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  var selectedGender = "Male";
  final nameController = TextEditingController();
  var dateOfBirth = "Date of Birth";
  final locationController = TextEditingController();
  var nameValid = true;
  var dobValid = true;
  var locationValid = true;
  var isLoading = false;
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat('dd-MMM-yyyy');

  Future<void> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime lastDate = DateTime(
      currentDate.year - 8,
      currentDate.month,
      currentDate.day,
    );
    final DateTime initialDate =
        selectedDate.isBefore(lastDate) ? selectedDate : lastDate;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1970),
        lastDate: lastDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirth = dateFormat.format(picked);
        dobValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text("Your Information"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = "Male";
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectedGender == "Male"
                            ? const Color.fromARGB(255, 135, 200, 250)
                            : const Color.fromARGB(255, 240, 240, 245),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.male, size: 50),
                        Text("Men",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: selectedGender == "Male"
                                    ? FontWeight.bold
                                    : FontWeight.normal))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = "Female";
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectedGender == "Female"
                            ? const Color.fromARGB(255, 250, 190, 200)
                            : const Color.fromARGB(255, 240, 240, 245),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.female, size: 50),
                        Text("Women",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: selectedGender == "Female"
                                    ? FontWeight.bold
                                    : FontWeight.normal))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = "N/A";
                    });
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectedGender == "N/A"
                            ? null
                            : const Color.fromARGB(255, 240, 240, 245),
                        gradient: selectedGender == "N/A"
                            ? const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 135, 200, 250),
                                  Colors.white,
                                  Color.fromARGB(255, 250, 190, 200)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 0.5, 1.0],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset('assets/images/gender.png',
                              height: 36),
                        ),
                        Text("Prefer N/A",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: selectedGender == "N/A"
                                    ? FontWeight.bold
                                    : FontWeight.normal))
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              onChanged: (value) {
                if (value.length >= 3) {
                  setState(() {
                    nameValid = true;
                  });
                }
              },
              inputFormatters: [LengthLimitingTextInputFormatter(30)],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 240, 240, 245),
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  prefixIcon: const Icon(Icons.person),
                  hintText: "Full name",
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  errorText:
                      nameValid ? null : "Can't be less than 3 characters"),
            ),
            const SizedBox(height: 16),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 240, 245),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      selectDate(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.date_range),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(dateOfBirth,
                                style: TextStyle(
                                    color: dateOfBirth == "Date of Birth"
                                        ? Colors.grey[700]
                                        : null,
                                    fontSize: 15))),
                      ],
                    ),
                  ),
                )),
            dobValid
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    child: Text(
                      "Please select date",
                      style: TextStyle(
                          color: Color.fromARGB(255, 200, 20, 10),
                          fontSize: 13),
                    ),
                  ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    locationValid = true;
                  });
                }
              },
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 240, 240, 245),
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "City/Town",
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  errorText:
                      locationValid ? null : "Please enter a valid city/town"),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    nameController.text = nameController.text.trim();
                    locationController.text = locationController.text.trim();
                    if (nameController.text.length < 3) {
                      setState(() {
                        nameValid = false;
                      });
                    } else if (dateOfBirth.length > 11) {
                      setState(() {
                        dobValid = false;
                      });
                    } else if (locationController.text.isEmpty) {
                      setState(() {
                        locationValid = false;
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      final body = jsonEncode(<String, dynamic>{
                        'phone': widget.phone,
                        'name': nameController.text,
                        'dob': dateOfBirth,
                        'city': locationController.text,
                        'gender': selectedGender,
                        'language': widget.language
                      });
                      final response = await http.put(
                          Uri.parse(
                              "https://yoursportzbackend.azurewebsites.net/api/auth/save/"),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: body);
                      final Map<String, dynamic> responseData =
                          jsonDecode(response.body);
                      if (responseData['message'] == "success") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen(phone: widget.phone)),
                            (route) => false);

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
                          child: Text("Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                )),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
