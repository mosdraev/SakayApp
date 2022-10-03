import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/entry/register.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';

class ButtonPrimary extends StatelessWidget {
  final String labelText;
  final int userType;
  final Widget icon;

  const ButtonPrimary(
      {super.key,
      required this.labelText,
      required this.userType,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        // horizontal: 50,
      ),
      child: ElevatedButton.icon(
        icon: icon,
        style: ElevatedButton.styleFrom(
          elevation: 10,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          minimumSize: const Size(30, 10),
          fixedSize: const Size.fromWidth(200),
          backgroundColor: buttonBackgroundColor,
        ),
        label: Text(
          labelText,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white70,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            buildRoute(
              Register(type: userType, label: labelText),
            ),
          );
        },
      ),
    );
  }
}
