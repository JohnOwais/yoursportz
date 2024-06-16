// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:yoursportz/home/home_screen.dart';
import 'package:yoursportz/on_bording/on_boarding_screen.dart';

class SplashAnimated extends StatefulWidget {
  const SplashAnimated({super.key});

  @override
  State<SplashAnimated> createState() => _SplashAnimatedState();
}

class _SplashAnimatedState extends State<SplashAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  var theme = 1;
  var userId = "null";

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
    changeColor();
  }

  Future<void> changeColor() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      theme = 2;
    });
    await Future.delayed(const Duration(seconds: 1));
    var currentUser = await Hive.openBox('CurrentUser');
    if (currentUser.containsKey('userId')) {
      setState(() {
        userId = currentUser.get('userId');
      });
    } else {
      await currentUser.put('userId', "null");
    }
    if (userId == "null") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(phone: userId)),
          (route) => false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme == 1
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 200, 172, 255),
                    Colors.deepPurple
                  ],
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation.value,
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      height: 100,
                      width: 100,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(-200 + (animation.value * 200), 0),
                    child: Center(
                      child: Text(
                        'YourSportz',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme == 1 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(200 - (animation.value * 200), 0),
                    child: Center(
                      child: Text(
                        'Game it your way',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme == 1
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
