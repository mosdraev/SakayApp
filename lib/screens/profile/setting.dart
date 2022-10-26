import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/profile/update.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
          child: Center(
            child: Text(
              'Account Settings',
              style: TextStyle(
                fontFamily: defaultFont,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(30, 10),
              backgroundColor: Colors.white,
            ),
            onPressed: () => {
              Navigator.of(context).push(buildRoute(const Updates())),
            },
            child: const Text(
              'Update Profile',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(30, 10),
              backgroundColor: Colors.white,
            ),
            onPressed: () => {
              Navigator.of(context).push(buildRoute(const Updates())),
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
