import 'package:flutter/material.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/dashboard/look_for_ride.dart';
import 'package:sakay_v2/screens/dashboard/places.dart';
import 'package:sakay_v2/screens/profile/settings.dart';
import 'package:sakay_v2/static/style.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int selectedIndex = 0;

  final titles = [
    'Home',
    'Places Traveled',
    'Profile Settings',
  ];

  final screens = [
    const Text('Home'),
    const Places(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: (selectedIndex == 2) ? null : const LookForRide(),
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
                Icons.house,
                color: Colors.white54,
                size: 35,
              ),
              icon: Icon(
                Icons.house_outlined,
                color: Colors.white54,
                size: 35,
              ),
              label: "Home",
            ),
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
