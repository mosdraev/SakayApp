import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/screens/entry/login.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? objectId;
  String? sessionToken;

  Future<void> _getUserType() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      objectId = prefs.getString('objectId');
      sessionToken = prefs.getString('sessionToken');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Widget showScreen() {
    if (objectId == null && sessionToken == null) {
      return const Login();
    } else {
      return const Index();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(toolbarTextStyle: appBarTextStyle),
        textTheme: const TextTheme(
            button: appBarTextStyle, bodyText1: appBarTextStyle),
        primaryColor: appBackgroundColor,
      ),
      home: showScreen(),
    );
  }
}
