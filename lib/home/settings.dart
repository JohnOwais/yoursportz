// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yoursportz/on_bording/login.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.phone});

  final String phone;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 240),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [DeleteAccount(phone: widget.phone), const Logout()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => const Dialog(
                      child: SingleChildScrollView(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Feature unavailable for beta release"),
                    )),
                  )));
        },
        child: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Account",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Sure to logout?"),
                    content: const Text("Are you sure to logout?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No")),
                      TextButton(
                          onPressed: () async {
                            var currentUser = await Hive.openBox('CurrentUser');
                            await currentUser.put('userId', 'null');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignIn(language: "English")),
                                (route) => false);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    content: Row(
                                      children: [
                                        Text("User Successfully Logged Out",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        SizedBox(width: 8),
                                        Icon(Icons.done_all,
                                            color: Colors.white)
                                      ],
                                    ),
                                    backgroundColor: Colors.green));
                          },
                          child: const Text("Yes"))
                    ],
                  ));
        },
        child: const Row(
          children: [
            Icon(Icons.logout, color: Colors.orange),
            SizedBox(width: 8),
            Text("Logout",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 17,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
