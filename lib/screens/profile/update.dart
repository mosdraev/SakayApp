import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/models/dropdown_items.dart';
import 'package:sakay_v2/models/profile_data.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String? objectId;
  ProfileData? profileData;
  @override
  void initState() {
    super.initState();
    _getUserObjectId();
  }

  Future<void> _getUserObjectId() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      objectId = prefs.getString('objectId');
    });
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navContext = Navigator.of(context);
    return MainLayout(
      title: 'Update Profile',
      floatingActionButton: null,
      bottomNavigationBar: null,
      widget: FutureBuilder(
        future: Service.getUserProfile(objectId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return const Text('Show default page');
              } else {
                final Object? userProfileData;
                if (snapshot.hasData) {
                  userProfileData = snapshot.data;
                  return buildUpdateForm(navContext, userProfileData);
                } else {
                  return buildForm(navContext);
                }
              }
          }
        },
      ),
    );
  }

  Widget buildUpdateForm(navContext, userProfileData) {
    var originProfileData = userProfileData;
    ProfileData? data = ProfileData.fromJson(userProfileData);
    int? idType;
    String? frontImageBase64;
    String? backImageBase64;

    final formKey = GlobalKey<FormState>();

    TextEditingController firstnameController =
        TextEditingController(text: data.firstName);

    TextEditingController lastnameController =
        TextEditingController(text: data.lastName);

    TextEditingController emailController =
        TextEditingController(text: data.email);

    List<DropdownItems> idTypes = <DropdownItems>[
      const DropdownItems(100, 'SSS'),
      const DropdownItems(200, 'Drivers License'),
      const DropdownItems(300, 'UMID'),
    ];

    DropdownMenuItem<DropdownItems> buildMenuItem(DropdownItems item) =>
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        );

    void openFileImageExplorer({isFront = 1}) async {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile == null) return;

      final file = pickedFile.files.first;

      final bytes = File(file.path!).readAsBytesSync();
      String img64 = base64Encode(bytes);

      if (isFront == 1) {
        frontImageBase64 = img64;
      } else {
        backImageBase64 = img64;
      }
    }

    updateProfile() async {
      if (objectId == originProfileData['userObjectId']) {
        var profile = ParseObject('Profile');
        profile.set('objectId', originProfileData['objectId']);
        profile.set('userObjectId', objectId);
        profile.set('firstName', firstnameController.text.trim());
        profile.set('lastName', lastnameController.text.trim());
        profile.set('email', emailController.text.trim());

        if (idType != null) {
          profile.set('idType', idType);
        }
        if (frontImageBase64 != null) {
          profile.set('idFrontImage', frontImageBase64);
        }
        if (backImageBase64 != null) {
          profile.set('idBackImage', backImageBase64);
        }

        var response = await profile.update();
        if (response.success) {
          navContext.push(buildRoute(const Index(
            defaultIndex: 2,
          )));
        }
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
            ),
            Padding(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  items: idTypes.map(buildMenuItem).toList(),
                  value: idTypes.where((type) => type.id == data.idType).single,
                  onChanged: (value) {
                    idType = value?.id;
                  },
                  decoration: InputDecoration(
                    labelText: 'Select ID Type',
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 130, 157, 72),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
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
                onPressed: updateProfile,
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

  Widget buildForm(navContext) {
    final formKey = GlobalKey<FormState>();

    int? idType;
    String? frontImageBase64;
    String? backImageBase64;

    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    List<DropdownItems> idTypes = <DropdownItems>[
      const DropdownItems(100, 'SSS'),
      const DropdownItems(200, 'Drivers License'),
      const DropdownItems(300, 'UMID'),
    ];

    DropdownMenuItem<DropdownItems> buildMenuItem(DropdownItems item) =>
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        );

    void openFileImageExplorer({isFront = 1}) async {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile == null) return;

      final file = pickedFile.files.first;

      final bytes = File(file.path!).readAsBytesSync();
      String img64 = base64Encode(bytes);

      if (isFront == 1) {
        frontImageBase64 = img64;
      } else {
        backImageBase64 = img64;
      }
    }

    saveProfile() async {
      var profile = ParseObject('Profile');
      profile.set('userObjectId', objectId);
      profile.set('firstName', firstnameController.text.trim());
      profile.set('lastName', lastnameController.text.trim());
      profile.set('email', emailController.text.trim());
      profile.set('idType', idType);
      profile.set('idFrontImage', frontImageBase64);
      profile.set('idBackImage', backImageBase64);

      var response = await profile.save();

      if (response.success) {
        navContext.push(buildRoute(const Index(
          defaultIndex: 2,
        )));
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
            ),
            Padding(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  items: idTypes.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    idType = value?.id;
                  },
                  decoration: InputDecoration(
                    labelText: 'Select ID Type',
                    prefixIcon: null,
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 130, 157, 72),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
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
                onPressed: saveProfile,
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
