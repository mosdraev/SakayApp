import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/models/profile_data.dart';
import 'package:sakay_v2/screens/profile/change_password.dart';
import 'package:sakay_v2/screens/profile/update.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? objectId;

  @override
  void initState() {
    super.initState();
    _getUserObjectId();
  }

  Future<void> _getUserObjectId() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      objectId = prefs.getString('objectId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
          child: Text(
            'Account Settings',
            style: TextStyle(
              fontFamily: defaultFont,
              fontSize: 20,
            ),
          ),
        ),
        FutureBuilder(
          future: Service.getUserProfile(objectId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return const Text('');
                } else {
                  final Object? userProfileData;
                  if (snapshot.hasData) {
                    userProfileData = snapshot.data;
                    return buildProfileData(userProfileData);
                  } else {
                    return const Text('');
                  }
                }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 1,
              padding: const EdgeInsets.symmetric(vertical: 15),
              minimumSize: const Size(30, 10),
              backgroundColor: Colors.white,
            ),
            onPressed: () => {
              Navigator.of(context).push(buildRoute(const Update())),
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
              Navigator.of(context).push(buildRoute(const ChangePassword())),
            },
            child: const Text(
              'Change Password',
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
            onPressed: () => {},
            child: const Text(
              'Logout',
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
            onPressed: () => {},
            child: const Text(
              'Delete Account',
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

  Widget buildProfileData(profile) {
    ProfileData? data = ProfileData.fromJson(profile);

    var stringInBytes = utf8.encode(data.userObjectId);
    String hashImage = sha256.convert(stringInBytes).toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xff9EB86D),
          radius: 40,
          child: CircleAvatar(
            backgroundColor: Colors.cyan[100],
            backgroundImage: NetworkImage(
                'http://www.gravatar.com/avatar/$hashImage?d=identicon'),
            radius: 39,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                'Name: ${data.firstName} ${data.lastName}',
                style: const TextStyle(fontSize: 16, fontFamily: defaultFont),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                'Email: ${data.email}',
                style: const TextStyle(fontSize: 16, fontFamily: defaultFont),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
