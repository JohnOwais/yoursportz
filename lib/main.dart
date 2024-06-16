// ignore_for_file: empty_catches

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoursportz/firebase_options.dart';
import 'package:yoursportz/on_bording/animated_splash.dart';
import 'package:yoursportz/translations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('CurrentUser');
  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('ar'),
          Locale('pt', 'BR'),
          Locale('en'),
          Locale('fr'),
          Locale('hi'),
          Locale('pt'),
          Locale('es'),
          Locale('ur')
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: const YourSportz()),
  );
}

class YourSportz extends StatelessWidget {
  const YourSportz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'YourSportz',
      debugShowCheckedModeBanner: false,
      home: const SplashAnimated(),
    );
  }
}
