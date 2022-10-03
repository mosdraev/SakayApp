import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/screens/entry/login.dart';
import 'package:sakay_v2/screens/start/home.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? userData;
  bool? isLoggedIn;

  _getUserType() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      userData = prefs.getString('userType');
      isLoggedIn = prefs.getBool('isLoggedIn');
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  Widget showScreen() {
    if (userData != null) {
      if (isLoggedIn == true) {
        return const Index();
      }
      return const Login();
    } else {
      return const Home();
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
