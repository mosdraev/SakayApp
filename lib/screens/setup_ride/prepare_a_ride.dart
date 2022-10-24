import 'package:flutter/material.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/components/select_dropdown.dart';
import 'package:sakay_v2/static/style.dart';

class PrepareRide extends StatelessWidget {
  const PrepareRide({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Book a Ride',
      widget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(color: Colors.white70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.black26,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Color.fromARGB(255, 130, 157, 72),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Current Location',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black26,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Color.fromARGB(255, 130, 157, 72),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Destination',
                ),
              ),
            ),
            const SelectDropdown(
              label: "Choose a saved place",
              icon: Icon(
                Icons.place_outlined,
                color: Colors.black26,
              ),
            ),
            const SelectDropdown(
              label: "Choose a rider",
              icon: Icon(
                Icons.drive_eta_outlined,
                color: Colors.black26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(30, 10),
                  backgroundColor: buttonBackgroundColor,
                ),
                onPressed: () {},
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: null,
      floatingActionButton: null,
    );
  }
}