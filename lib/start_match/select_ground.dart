// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:yoursportz/start_match/start_match.dart';

class SelectGround extends StatefulWidget {
  const SelectGround({super.key, required this.phone});

  final String phone;

  @override
  State<SelectGround> createState() => _SelectGroundState();
}

class _SelectGroundState extends State<SelectGround> {
  final locationController = TextEditingController();
  final nameController = TextEditingController();
  var gameTime;
  var firstHalf = "First half";
  var players2play;
  var date = "Select date";
  var dateValid = true;
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat('dd-MMM-yyyy');
  TimeOfDay selectedTime = TimeOfDay.now();
  Map ground = {};
  final locationFocus = FocusNode();
  final groundFocus = FocusNode();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date = dateFormat.format(picked);
        dateValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Start A Match"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 68),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("*Location",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  InputText(
                      locationController: locationController,
                      focus: locationFocus,
                      hint: "Enter your location",
                      keyboard: TextInputType.text),
                  const Text("*Ground",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  InputText(
                      locationController: nameController,
                      focus: groundFocus,
                      hint: "Enter ground name",
                      keyboard: TextInputType.text),
                  const Text("*Date",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  GestureDetector(
                      onTap: () => {selectDate(context)},
                      child: Date(text: date, icon: Icons.date_range)),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: DropdownButton<String>(
                                    hint: const Text("Game time"),
                                    value: gameTime,
                                    underline: const SizedBox(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        gameTime = value!;
                                        if (gameTime == "30 minutes") {
                                          firstHalf = "15 minutes";
                                        } else if (gameTime == "60 minutes") {
                                          firstHalf = "30 minutes";
                                        } else if (gameTime == "90 minutes") {
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
                  const Text("*Players to Play",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: DropdownButton<String>(
                                    hint:
                                        const Text("Select number of players"),
                                    value: players2play,
                                    underline: const SizedBox(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        players2play = value!;
                                      });
                                    },
                                    items: <String>[
                                      '5 Players',
                                      '8 Players',
                                      '11 Players'
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
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("Schedule Match",
                                style: TextStyle(
                                    color: Color(0xff554585),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          locationController.text =
                              locationController.text.trim();
                          nameController.text = nameController.text.trim();
                          if (locationController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please enter location",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red));
                            locationFocus.requestFocus();
                          } else if (nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please enter ground name",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red));
                            groundFocus.requestFocus();
                          } else if (date == "Select date") {
                            selectDate(context);
                          } else if (gameTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select game time",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red));
                          } else if (players2play == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select number of players to play",
                                        style: TextStyle(color: Colors.white)),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red));
                          } else {
                            ground['location'] = locationController.text;
                            ground['name'] = nameController.text;
                            ground['date'] = date;
                            ground['gameTime'] = gameTime;
                            ground['firstHalf'] = firstHalf;
                            ground['players'] = players2play.toString();
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartMatch(
                                        phone: widget.phone, ground: ground)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color(0xff554585)),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text("Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required this.locationController,
      this.focus,
      required this.hint,
      required this.keyboard});

  final TextEditingController locationController;
  final FocusNode? focus;
  final String hint;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 0, color: const Color(0xff7A7A7A))),
        child: TextField(
          controller: locationController,
          focusNode: focus,
          keyboardType: keyboard,
          inputFormatters: [
            keyboard == TextInputType.number
                ? LengthLimitingTextInputFormatter(2)
                : LengthLimitingTextInputFormatter(30)
          ],
          decoration: InputDecoration(
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: hint,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              contentPadding: const EdgeInsets.all(16)),
        ),
      ),
    );
  }
}
