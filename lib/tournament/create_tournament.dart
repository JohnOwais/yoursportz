// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yoursportz/tournament/ongoing_tournaments.dart';

class CreateTournament extends StatefulWidget {
  const CreateTournament({super.key, required this.phone});

  final String phone;

  @override
  State<CreateTournament> createState() => _CreateTournamentState();
}

class _CreateTournamentState extends State<CreateTournament> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final organizerController = TextEditingController();
  final groundController = TextEditingController();
  final teamController = TextEditingController();
  final locationController = TextEditingController();

  final detailsController = TextEditingController();
  final schoolController = TextEditingController();
  final collegeController = TextEditingController();
  final universityController = TextEditingController();
  final corporateController = TextEditingController();
  final minController = TextEditingController();
  final maxController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  var startValid = true;
  var endValid = true;
  var minValid = true;
  var maxValid = true;
  var corporateValid = true;
  var detailsValid = true;

  var nameValid = true;
  var phoneValid = true;
  var locationValid = true;
  var groundValid = true;
  var teamValid = true;

  var schoolValid = true;
  var collegeValid = true;
  var universityValid = true;
  var isLoading = false;
  var selectedCategory = "School";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 235, 240),
        appBar: AppBar(
          title: const Text(
            "Add A Tournament",
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
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 235, 235, 240),
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                      Image.asset('assets/images/banner.png'),
                                )),
                          ),
                          Center(
                            child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                    child: Image.asset(
                                  'assets/images/team_logo.png',
                                  height: 100,
                                ))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Label(text: "Tournament Name"),
                      InputText(
                        icon: Icons.event,
                        hint: "Enter tournament name",
                        keyboard: TextInputType.name,
                        max: 50,
                        controller: nameController,
                        valid: nameValid,
                      ),
                      const Label(text: "Organizer Name"),
                      InputText(
                        icon: Icons.person,
                        hint: "Enter organizer name",
                        keyboard: TextInputType.name,
                        max: 30,
                        controller: organizerController,
                        valid: nameValid,
                      ),
                      const Label(text: "Contact Number"),
                      InputText(
                        icon: Icons.phone,
                        hint: "Enter contact number",
                        keyboard: TextInputType.number,
                        max: 10,
                        controller: phoneController,
                        valid: phoneValid,
                      ),
                      const Label(text: "Location"),
                      InputText(
                        icon: Icons.place,
                        hint: "Enter location",
                        keyboard: TextInputType.streetAddress,
                        max: 50,
                        controller: locationController,
                        valid: locationValid,
                      ),
                      const Label(text: "Ground Name"),
                      Row(
                        children: [
                          Expanded(
                            child: InputText(
                              icon: Icons.sports_football_outlined,
                              hint: "Enter ground name",
                              keyboard: TextInputType.number,
                              max: 5,
                              controller: teamController,
                              valid: teamValid,
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
                      InputText(
                        icon: Icons.numbers,
                        hint: "Number of teams",
                        keyboard: TextInputType.number,
                        max: 50,
                        controller: groundController,
                        valid: groundValid,
                      ),
                      const Label(text: "Tournament Date"),
                      Row(
                        children: [
                          Expanded(
                            child: InputText(
                              icon: Icons.calendar_month,
                              hint: "Start Date",
                              keyboard: TextInputType.datetime,
                              max: 10,
                              controller: startController,
                              valid: startValid,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InputText(
                              icon: Icons.calendar_month,
                              hint: "End Date",
                              keyboard: TextInputType.datetime,
                              max: 10,
                              controller: endController,
                              valid: endValid,
                            ),
                          ),
                        ],
                      ),
                      const Label(text: "Match Duration"),
                      Row(
                        children: [
                          Expanded(
                            child: InputText(
                              icon: Icons.punch_clock,
                              hint: "Min 15",
                              keyboard: TextInputType.number,
                              max: 10,
                              controller: minController,
                              valid: minValid,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: InputText(
                                  icon: Icons.punch_clock_rounded,
                                  hint: "Max 45",
                                  keyboard: TextInputType.number,
                                  max: 10,
                                  controller: maxController,
                                  valid: maxValid))
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
                          setState(() {
                            isLoading = true;
                          });
                          await Future.delayed(const Duration(seconds: 2));
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const OngoingTournaments(
                                          phone: '919149764646'))));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Row(
                                    children: [
                                      Text("Tournament Created Successfully",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      SizedBox(width: 8),
                                      Icon(Icons.done_all, color: Colors.white)
                                    ],
                                  ),
                                  backgroundColor: Colors.green));
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
      this.max,
      required this.controller,
      required this.valid});
  final IconData icon;
  final String hint;
  final int? max;
  final TextInputType keyboard;
  final TextEditingController controller;
  final bool valid;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none),
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal)),
      controller: controller,
      keyboardType: keyboard,
    );
  }
}
