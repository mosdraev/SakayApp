import 'package:flutter/material.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/start/select_user.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: null,
      bottomNavigationBar: null,
      showBackButton: true,
      title: '',
      widget: Container(
        decoration: const BoxDecoration(color: appBackgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/welcome_app_logo.png",
              alignment: Alignment.bottomCenter,
              height: 250,
            ),
            const SizedBox(height: 100),
            const StartButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
        child: ElevatedButton(
          onPressed: () => {
            Navigator.of(context).push(buildRoute(const SelectUser())),
          },
          style: ElevatedButton.styleFrom(
            elevation: 15,
            backgroundColor: buttonBackgroundColor,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.fromLTRB(0, 2.0, 2.0, 2.0),
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            foregroundColor: Colors.white70,
            side: const BorderSide(
              width: 5,
              color: Colors.white70,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SizedBox(width: 80),
              Text('START'),
              SizedBox(width: 20),
              Icon(
                size: 60,
                color: Colors.white70,
                Icons.play_circle_fill_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
