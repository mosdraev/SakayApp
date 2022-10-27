import 'package:flutter/material.dart';
import 'package:sakay_v2/components/button_primary.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:sakay_v2/components/main_layout.dart';

class SelectUser extends StatelessWidget {
  const SelectUser({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: null,
      bottomNavigationBar: null,
      showBackButton: false,
      title: '',
      widget: Container(
        decoration: const BoxDecoration(color: appBackgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/welcome_app_logo.png",
              alignment: Alignment.center,
              height: 250,
            ),
            const SizedBox(width: 200, height: 100),
            Column(
              children: const [
                ButtonPrimary(
                  labelText: 'Driver',
                  userType: Constant.accountDriver,
                  icon: Icon(
                    Icons.drive_eta_rounded,
                    size: 32,
                  ),
                ),
                ButtonPrimary(
                  labelText: 'Passenger',
                  userType: Constant.accountPassenger,
                  icon: Icon(
                    Icons.emoji_people,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 200, height: 100),
          ],
        ),
      ),
    );
  }
}
