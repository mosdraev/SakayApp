import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/screens/entry/register.dart';
import 'package:sakay_v2/screens/profile/update.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumberController = TextEditingController(),
      passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _formSubmitted = false;

  bool _showPassword = true;
  void _togglePasswordObscured() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  String? apiErrorMessage;
  loginUser() async {
    final username = mobileNumberController.text.trim();
    final password = passwordController.text.trim();

    var navigator = Navigator.of(context);
    ParseUser userObject = ParseUser(username, password, null);
    var response = await userObject.login();

    if (response.success) {
      var loggedInUser = await Service.getUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constant.userMobileNumber, username);
      await prefs.setString(Constant.userObjectId, loggedInUser['objectId']);
      await prefs.setString(
          Constant.userSessionToken, loggedInUser['sessionToken']);
      await prefs.setBool(Constant.userIsLoggedIn, true);

      var userProfile = await Service.getUserProfile(loggedInUser['objectId']);
      if (userProfile != null) {
        navigator.pushAndRemoveUntil(
            buildRoute(
              const Index(
                defaultIndex: 0,
              ),
            ),
            (route) => false);
      } else {
        navigator.pushAndRemoveUntil(
            buildRoute(
              const Update(),
            ),
            (route) => false);
      }
    } else {
      setState(() {
        apiErrorMessage = response.error!.message;
      });
    }
  }

  Widget showError() {
    setState(() {
      _formSubmitted = false;
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        apiErrorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: null,
      bottomNavigationBar: null,
      title: 'Login User',
      showBackButton: false,
      widget: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(color: Colors.white70),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                Image.asset("assets/images/welcome_app_logo.png", height: 200),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mobile number is required";
                      }
                      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      RegExp regExp = RegExp(pattern);

                      if (!regExp.hasMatch(value)) {
                        return 'Please enter valid mobile number';
                      }

                      return null;
                    },
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(
                          color: Color.fromARGB(255, 130, 157, 72)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 130, 157, 72),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.fromLTRB(14.0, 14.0, 8.0, 8.0),
                        child: Text(
                          '+63',
                          style: TextStyle(
                            fontFamily: defaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      labelText: 'Mobile Number',
                      counterText: '',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    autofocus: true,
                  ),
                ),
                if (apiErrorMessage != null) showError(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.black26,
                      ),
                      suffix: InkWell(
                        onTap: _togglePasswordObscured,
                        child: Icon(
                          color: Colors.black26,
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 130, 157, 72),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 130, 157, 72),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      minimumSize: const Size(30, 10),
                      backgroundColor: buttonBackgroundColor,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _formSubmitted = true;
                        });
                        loginUser();
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
                            'Login',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                const NewUser(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewUser extends StatelessWidget {
  const NewUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'New user?',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(buildRoute(const Register()));
            },
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Color(0xff50524f),
                fontFamily: defaultFont,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
