import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController(),
      newPasswordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _formSubmitted = false;

  void togglePasswordObscured() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void toggleConfirmPasswordObscured() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  var _user;

  futureData() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(Constant.userSessionToken);
    ParseUser user = await Service.getUserByToken(token);
    _user = user;

    return user;
  }

  updatePassword(navigator) async {
    // final prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString(Constant.userSessionToken);

    // ParseUser user = await Service.getUserByToken(token);
    // user.set('password', '12345');
    // var result = await user.update();
    // print(result.result);
    // print(result.error);
    // print(result.success);
    // print(response.success);
    // final ParseResponse parseResponse = await user.requestPasswordReset();
    // if (parseResponse.success) {
    //   Message.showSuccess(
    //       context: context,
    //       message: 'Password reset instructions have been sent to email!',
    //       onPressed: () {
    //         Navigator.pop(context);
    //       });
    // } else {
    //   Message.showError(
    //       context: context, message: parseResponse.error!.message);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Change Password',
      bottomNavigationBar: null,
      floatingActionButton: null,
      widget: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your old password";
                    }
                    return null;
                  },
                  controller: oldPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
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
                    labelText: 'Old Password',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your new password";
                    }
                    return null;
                  },
                  controller: newPasswordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.black26,
                    ),
                    suffix: InkWell(
                      onTap: togglePasswordObscured,
                      child: Icon(
                        color: Colors.black26,
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 130, 157, 72)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'New Password',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password does not match";
                    }

                    if (value.isNotEmpty) {
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        return "Password does not match";
                      }
                    }

                    return null;
                  },
                  controller: confirmPasswordController,
                  obscureText: _showConfirmPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.black26,
                    ),
                    suffix: InkWell(
                      onTap: toggleConfirmPasswordObscured,
                      child: Icon(
                        color: Colors.black26,
                        _showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 130, 157, 72)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        minimumSize: const Size(30, 10),
                        backgroundColor: buttonBackgroundColor,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            _formSubmitted = true;
                          });
                          var navigator = Navigator.of(context);
                          updatePassword(navigator);
                        }
                      },
                      child: _formSubmitted
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
                              'Update Password',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // FutureBuilder(
      //   future: futureData(),
      //   builder: (context, snapshot) {
      //     print(snapshot);
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return const Center(child: CircularProgressIndicator());
      //       default:
      //         if (!snapshot.hasError) {
      //           if (snapshot.hasData) {
      //             return buildForm(context, snapshot.data);
      //           }
      //         }
      //     }
      //     return const Center(child: Text('Failed to connect to server.'));
      //   },
      // ),
    );
  }

  // Widget buildForm(context, data) {
  //   return SingleChildScrollView(
  //     child: Form(
  //       key: formKey,
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //             child: TextFormField(
  //               obscureText: true,
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return "Please enter your old password";
  //                 }
  //                 return null;
  //               },
  //               controller: oldPasswordController,
  //               // obscureText: _showPassword,
  //               decoration: InputDecoration(
  //                 prefixIcon: const Icon(
  //                   Icons.lock_outline,
  //                   color: Colors.black26,
  //                 ),
  //                 // suffix: InkWell(
  //                 //   onTap: _togglePasswordObscured,
  //                 //   child: Icon(
  //                 //     color: Colors.black26,
  //                 //     _showPassword ? Icons.visibility_off : Icons.visibility,
  //                 //   ),
  //                 // ),
  //                 floatingLabelStyle: const TextStyle(
  //                   color: Color.fromARGB(255, 130, 157, 72),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: const BorderSide(
  //                       color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 border: const OutlineInputBorder(),
  //                 labelText: 'Old Password',
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //             child: TextFormField(
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return "Please enter your new password";
  //                 }
  //                 return null;
  //               },
  //               controller: newPasswordController,
  //               obscureText: _showConfirmPassword,
  //               decoration: InputDecoration(
  //                 prefixIcon: const Icon(
  //                   Icons.lock_outline,
  //                   color: Colors.black26,
  //                 ),
  //                 suffix: InkWell(
  //                   onTap: togglePasswordObscured,
  //                   child: Icon(
  //                     color: Colors.black26,
  //                     _showConfirmPassword
  //                         ? Icons.visibility_off
  //                         : Icons.visibility,
  //                   ),
  //                 ),
  //                 floatingLabelStyle:
  //                     const TextStyle(color: Color.fromARGB(255, 130, 157, 72)),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: const BorderSide(
  //                       color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 border: const OutlineInputBorder(),
  //                 labelText: 'New Password',
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //             child: TextFormField(
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return "Password does not match";
  //                 }

  //                 if (value.isNotEmpty) {
  //                   if (newPasswordController.text !=
  //                       confirmPasswordController.text) {
  //                     return "Password does not match";
  //                   }
  //                 }

  //                 return null;
  //               },
  //               controller: confirmPasswordController,
  //               obscureText: _showConfirmPassword,
  //               decoration: InputDecoration(
  //                 prefixIcon: const Icon(
  //                   Icons.lock_outline,
  //                   color: Colors.black26,
  //                 ),
  //                 suffix: InkWell(
  //                   onTap: toggleConfirmPasswordObscured,
  //                   child: Icon(
  //                     color: Colors.black26,
  //                     _showConfirmPassword
  //                         ? Icons.visibility_off
  //                         : Icons.visibility,
  //                   ),
  //                 ),
  //                 floatingLabelStyle:
  //                     const TextStyle(color: Color.fromARGB(255, 130, 157, 72)),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: const BorderSide(
  //                       color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
  //                   borderRadius: BorderRadius.circular(5.0),
  //                 ),
  //                 border: const OutlineInputBorder(),
  //                 labelText: 'Confirm Password',
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     elevation: 5,
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 10, horizontal: 20),
  //                     minimumSize: const Size(30, 10),
  //                     backgroundColor: buttonBackgroundColor,
  //                   ),
  //                   onPressed: () async {
  //                     if (formKey.currentState!.validate()) {
  //                       setState(() {
  //                         _formSubmitted = true;
  //                       });
  //                       var navigator = Navigator.of(context);
  //                       updatePassword(navigator);
  //                     }
  //                   },
  //                   child: _formSubmitted
  //                       ? Container(
  //                           width: 24,
  //                           height: 24,
  //                           padding: const EdgeInsets.all(2.0),
  //                           child: const CircularProgressIndicator(
  //                             color: Color.fromARGB(255, 235, 236, 235),
  //                             strokeWidth: 3,
  //                           ),
  //                         )
  //                       : const Text(
  //                           'Update Password',
  //                           style: TextStyle(
  //                             color: Colors.white70,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
