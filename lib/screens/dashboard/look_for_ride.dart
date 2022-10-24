import 'package:flutter/material.dart';
import 'package:sakay_v2/screens/setup_ride/prepare_a_ride.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';

class LookForRide extends StatelessWidget {
  const LookForRide({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(buildRoute(const PrepareRide()));
      },
      label: const Text(
        "Look for a ride",
        style: lookForRideStyle,
      ),
      elevation: 10,
      extendedPadding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
      backgroundColor: buttonBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
    );
  }
}
