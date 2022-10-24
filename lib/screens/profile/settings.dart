import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/components/select_dropdown.dart';
import 'package:sakay_v2/models/id_type.dart';
import 'package:sakay_v2/static/style.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // _getUser();
    super.initState();
  }

  // var user;

  // _getUser() async {
  //   var currentUser = await Service.getUser();
  //   setState(() {
  //     user = currentUser;
  //   });
  //   print(currentUser);
  // }

  final _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController(),
      lastnameController = TextEditingController(),
      emailController = TextEditingController();

  List<CustomDropdownItems> idTypes = <CustomDropdownItems>[
    const CustomDropdownItems(100, 'SSS'),
    const CustomDropdownItems(200, 'Drivers License'),
    const CustomDropdownItems(300, 'UMID'),
  ];

  String? frontImageBase64;
  String? backImageBase64;

  void openFileImageExplorer({isFront = 1}) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile == null) return;

    final file = pickedFile.files.first;

    final bytes = File(file.path!).readAsBytesSync();
    String img64 = base64Encode(bytes);

    setState(() {
      if (isFront == 1) {
        frontImageBase64 = img64;
      } else {
        backImageBase64 = img64;
      }
    });
  }

  var idType;

  void selectIds(CustomDropdownItems? value) {
    setState(() {
      idType = value?.id;
    });
  }

  saveProfileSettings() async {
    // print(firstnameController.text);
    // print(lastnameController.text);
    // print(emailController.text);
    // print(frontImageBase64);
    // print(backImageBase64);
    // print(idType);

    var profile = ParseObject('Profile');
    profile.set('firstname', firstnameController.text.trim());
    profile.set('lastname', lastnameController.text.trim());
    profile.set('email', emailController.text.trim());
    profile.set('id_type', idType);
    profile.set('id_front', frontImageBase64);
    profile.set('id_back', backImageBase64);
    // profile.set('user', user.objectId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // ProfileWidget(
            //   imagePath:
            //       "https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80",
            //   onClicked: () async {},
            // ),
            FirstnameField(firstnameController: firstnameController),
            LastnameField(lastnameController: lastnameController),
            EmailField(emailController: emailController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SelectDropdown(
                label: "Select ID type",
                icon: null,
                itemOptions: idTypes,
                callback: selectIds,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(30, 10),
                  backgroundColor: Colors.white,
                ),
                onPressed: () => openFileImageExplorer(isFront: 1),
                child: const Text(
                  'Select Front ID Image',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(30, 10),
                  backgroundColor: Colors.white,
                ),
                onPressed: () => openFileImageExplorer(isFront: 0),
                child: const Text(
                  'Select Back ID Image',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(30, 10),
                  backgroundColor: buttonBackgroundColor,
                ),
                onPressed: saveProfileSettings,
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
          ],
        ),
      ),
    );
  }
}

// class IDTypeField extends StatefulWidget {
//   const IDTypeField({
//     Key? key,
//     required this.idTypes,
//   }) : super(key: key);

//   final List<CustomDropdownItems> idTypes;

//   @override
//   State<IDTypeField> createState() => _IDTypeFieldState();
// }

// class _IDTypeFieldState extends State<IDTypeField> {
//   String? value;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       child: SelectDropdown(
//         label: "Select ID type",
//         icon: null,
//         itemOptions: widget.idTypes,
//         callback: () => setState(() {
//           value = value;
//         }),
//       ),
//     );
//   }
// }

class FirstnameField extends StatelessWidget {
  const FirstnameField({
    Key? key,
    required this.firstnameController,
  }) : super(key: key);

  final TextEditingController firstnameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your firstname.";
          }
          return null;
        },
        controller: firstnameController,
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
    );
  }
}

class LastnameField extends StatelessWidget {
  const LastnameField({
    Key? key,
    required this.lastnameController,
  }) : super(key: key);

  final TextEditingController lastnameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your lastname.";
          }
          return null;
        },
        controller: lastnameController,
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
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your email.";
          }
          return null;
        },
        controller: emailController,
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
