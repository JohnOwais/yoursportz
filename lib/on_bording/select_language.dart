// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yoursportz/on_bording/login.dart';
import 'package:yoursportz/translations/locale_keys.g.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  var dropdownValue = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(LocaleKeys.choose_language.tr(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.start),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: Text(LocaleKeys.choose_language_desc.tr(),
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start)),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240),
                border:
                    Border.all(color: const Color.fromARGB(255, 240, 240, 240)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: const Text("Select Language",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        value: dropdownValue,
                        icon: const SizedBox(),
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          setState(() async {
                            dropdownValue = newValue!;
                            if (dropdownValue == "عربي") {
                              await context.setLocale(const Locale('ar'));
                            } else if (dropdownValue == "Brasileiro") {
                              await context.setLocale(const Locale('pt', 'BR'));
                            } else if (dropdownValue == "English") {
                              await context.setLocale(const Locale('en'));
                            } else if (dropdownValue == "Français") {
                              await context.setLocale(const Locale('fr'));
                            } else if (dropdownValue == "हिंदी") {
                              await context.setLocale(const Locale('hi'));
                            } else if (dropdownValue == "Português") {
                              await context.setLocale(const Locale('pt'));
                            } else if (dropdownValue == "Español") {
                              await context.setLocale(const Locale('es'));
                            } else if (dropdownValue == "اردو") {
                              await context.setLocale(const Locale('ur'));
                            }
                          });
                        },
                        items: <String>[
                          'عربي',
                          'Brasileiro',
                          'English',
                          'Français',
                          'हिंदी',
                          'Português',
                          'Español',
                          'اردو'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Text(value),
                              ],
                            ),
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
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignIn(language: dropdownValue)));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xff554585)),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child:
                        Text("Continue", style: TextStyle(color: Colors.white)),
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
