import 'package:flutter/material.dart';
import 'package:sakay_v2/static/style.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          ProfileWidget(
            imagePath:
                "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
            onClicked: () async {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Firstname',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Lastname',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'ID Type',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'ID Front Image',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                  color: Color.fromARGB(255, 130, 157, 72),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: const OutlineInputBorder(),
                labelText: 'ID Back Image',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(30, 10),
                // fixedSize: const Size.fromWidth(150),
                backgroundColor: buttonBackgroundColor,
              ),
              onPressed: () async {},
              child: const Text(
                'Save Profile',
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
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
