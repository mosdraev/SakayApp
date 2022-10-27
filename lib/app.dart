import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/screens/entry/login.dart';
import 'package:sakay_v2/screens/start/home.dart';
import 'package:sakay_v2/static/constant.dart';
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

  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  Future<void> getUserType() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      objectId = prefs.getString(Constant.userObjectId);
      sessionToken = prefs.getString(Constant.userSessionToken);
      isLoggedIn = prefs.getBool(Constant.userIsLoggedIn);
    });
  }

  Widget showScreen() {
    Widget screen;

    if (objectId == null && sessionToken == null) {
      screen = const Home();
    } else {
      screen =
          (isLoggedIn == true) ? const Index(defaultIndex: 0) : const Login();
    }

    return screen;
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
