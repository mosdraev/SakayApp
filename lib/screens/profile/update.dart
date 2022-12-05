import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/models/dropdown_items.dart';
import 'package:sakay_v2/models/profile_data.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/static/constant.dart';
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
  Future<dynamic>? futureData;

  int accountType = Constant.accountPassenger;

  bool formSubmitted = false;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<dynamic> getUserProfileData() {
    return _memoizer.runOnce(() async {
      var prefs = await SharedPreferences.getInstance();
      objectId = prefs.getString(Constant.userObjectId);

      if (objectId != null) {
        futureData = Service.getUserProfile(objectId);
      }

      return futureData;
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
        future: getUserProfileData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return const Text('Failed to connect to server');
              } else {
                if (snapshot.hasData) {
                  Object? userProfileData = snapshot.data;
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

    // TextEditingController firstnameController =
    //     TextEditingController(text: data.firstName);

    // TextEditingController lastnameController =
    //     TextEditingController(text: data.lastName);

    // TextEditingController emailController =
    //     TextEditingController(text: data.email);

    firstnameController.text = data.firstName;
    lastnameController.text = data.lastName;
    // emailController.text = data.email;

    List<DropdownItems> idTypes;
    if (data.accountType == Constant.accountDriver) {
      idTypes = <DropdownItems>[
        const DropdownItems(200, 'Drivers License'),
      ];
    } else {
      idTypes = <DropdownItems>[
        const DropdownItems(100, 'SSS'),
        const DropdownItems(200, 'Drivers License'),
        const DropdownItems(300, 'UMID'),
      ];
    }

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
        // profile.set('email', emailController.text.trim());

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
            defaultIndex: 1,
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   child: TextFormField(
            //     keyboardType: TextInputType.emailAddress,
            //     validator: (value) {
            //       if (value!.isEmpty) {
            //         return "Please enter your email.";
            //       }
            //       return null;
            //     },
            //     controller: emailController,
            //     decoration: InputDecoration(
            //       floatingLabelStyle: const TextStyle(
            //         color: Color.fromARGB(255, 130, 157, 72),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //             color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //       border: const OutlineInputBorder(),
            //       labelText: 'Email Address',
            //     ),
            //   ),
            // ),
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      formSubmitted = true;
                    });
                    updateProfile();
                  }
                },
                child: formSubmitted
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 235, 236, 235),
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
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

    List<DropdownItems> idTypes = <DropdownItems>[
      const DropdownItems(100, 'SSS'),
      const DropdownItems(200, 'Drivers License'),
      const DropdownItems(300, 'UMID'),
    ];

    List<DropdownItems> driverType = <DropdownItems>[
      const DropdownItems(200, 'Drivers License'),
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
      // profile.set('email', emailController.text.trim());
      if (accountType == Constant.accountDriver) {
        idType = 200;
      }
      profile.set('idType', idType);
      profile.set('idFrontImage', frontImageBase64);
      profile.set('idBackImage', backImageBase64);
      profile.set('accountType', accountType);

      var response = await profile.save();

      if (response.success) {
        navContext.push(buildRoute(const Index(
          defaultIndex: 1,
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
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Text(
                  'Set up your profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: defaultFont,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFormField(
                validator: (value) {
                  return (value!.isEmpty)
                      ? "Please enter your firstname."
                      : null;
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
                  return (value!.isEmpty)
                      ? "Please enter your lastname."
                      : null;
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   child: TextFormField(
            //     keyboardType: TextInputType.emailAddress,
            //     validator: (value) {
            //       return (value!.isEmpty) ? "Please enter your email." : null;
            //     },
            //     controller: emailController,
            //     decoration: InputDecoration(
            //       floatingLabelStyle: const TextStyle(
            //         color: Color.fromARGB(255, 130, 157, 72),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderSide: const BorderSide(
            //             color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //       border: const OutlineInputBorder(),
            //       labelText: 'Email Address',
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextButton.icon(
                label: Tooltip(
                  showDuration: const Duration(seconds: 10),
                  triggerMode: TooltipTriggerMode.tap,
                  message:
                      'You can only select account type once, There can\nonly be one account type per mobile number registered.',
                  child: Ink(
                    height: 20,
                    width: 20,
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), color: Colors.black26),
                    child: const Icon(
                      Icons.question_mark_outlined,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                icon: const Text(
                  'Select Account Type',
                  style: TextStyle(
                    fontFamily: defaultFont,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      activeColor: buttonBackgroundColor,
                      selectedTileColor: buttonBackgroundColor,
                      title: const Text('Driver'),
                      value: Constant.accountDriver,
                      groupValue: accountType,
                      onChanged: (value) => setState(() {
                        accountType = value!;
                      }),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      selectedTileColor: buttonBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      activeColor: buttonBackgroundColor,
                      title: const Text('Passenger'),
                      value: Constant.accountPassenger,
                      groupValue: accountType,
                      onChanged: (value) => setState(() {
                        accountType = value!;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  validator: (value) {
                    return (value == null) ? "Please select an id type." : null;
                  },
                  isExpanded: true,
                  value: accountType == Constant.accountDriver
                      ? idTypes.where((type) => type.id == 200).single
                      : null,
                  items: accountType == Constant.accountDriver
                      ? driverType.map(buildMenuItem).toList()
                      : idTypes.map(buildMenuItem).toList(),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(30, 10),
                  backgroundColor: buttonBackgroundColor,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      formSubmitted = true;
                    });
                    saveProfile();
                  }
                },
                child: formSubmitted
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 235, 236, 235),
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
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
