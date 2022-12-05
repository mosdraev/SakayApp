import 'package:flutter/material.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/dashboard/look_for_ride.dart';
import 'package:sakay_v2/screens/dashboard/places.dart';
import 'package:sakay_v2/screens/profile/setting.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Index extends StatefulWidget {
  const Index({super.key, required this.defaultIndex});

  final int defaultIndex;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int selectedIndex = 0;

  final titles = [
    'Places',
    'Settings',
  ];

  final screens = [
    const Places(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.defaultIndex > 0) {
        selectedIndex = widget.defaultIndex;
      }
    });
    getUserProfileData();
  }

  String? userObjectId;

  Future<dynamic> getUserProfileData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      userObjectId = prefs.getString(Constant.userObjectId);
    });
  }

  Object? currentUserData;

  _futureData() async {
    var data = await Service.getUserProfile(userObjectId);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      // floatingActionButton: (selectedIndex == 1) ? null : const LookForRide(),
      floatingActionButton: FutureBuilder(
        future: _futureData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('');
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
            default:
              if (snapshot.hasError) {
                return Text('Failed to connect to server ${snapshot.error}');
              } else {
                if (snapshot.hasData) {
                  final data = snapshot.data as Map;

                  if (data['accountType'] == Constant.accountPassenger) {
                    if (selectedIndex == 1) {
                      return const Text('');
                    } else {
                      return const LookForRide();
                    }
                  }
                } else {
                  return const Center(child: Text('Empty Results'));
                }
              }
          }

          return const Text('');
        },
      ),
      showBackButton: false,
      title: titles[selectedIndex],
      widget: screens[selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: appBackgroundColor,
          indicatorColor: const Color(0xff8ba260),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontFamily: defaultFont,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(seconds: 1),
          height: 70,
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) => setState(() {
            selectedIndex = value;
          }),
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.place,
                color: Colors.white54,
                size: 35,
              ),
              icon: Icon(
                Icons.place_outlined,
                color: Colors.white54,
                size: 35,
              ),
              label: "Places",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.white54,
                size: 35,
              ),
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.white54,
                size: 35,
              ),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
