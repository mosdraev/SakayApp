import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/screens/entry/register.dart';
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

  bool _showPassword = true;
  void _togglePasswordObscured() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  String? apiErrorMessage;
  loginUser() async {
    var navigator = Navigator.of(context),
        userObject = ParseUser(mobileNumberController.text.trim(),
            passwordController.text.trim(), null),
        response = await userObject.login();

    if (response.success) {
      var loggedInUser = await Service.getUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mobileNumber', mobileNumberController.text);
      await prefs.setString('objectId', loggedInUser['objectId']);
      await prefs.setString('sessionToken', loggedInUser['sessionToken']);
      navigator.push(buildRoute(const Index()));
    } else {
      setState(() {
        apiErrorMessage = response.error!.message;
      });
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/welcome_app_logo.png",
                height: 200,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
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
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const OutlineInputBorder(),
                    prefixText: '+63',
                    labelText: 'Mobile Number',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  autofocus: true,
                ),
              ),
              if (apiErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    apiErrorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
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
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
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
                    labelText: 'Password',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 15,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(30, 10),
                    // fixedSize: const Size.fromWidth(150),
                    backgroundColor: buttonBackgroundColor,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                  child: const Text(
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
              const SizedBox(
                height: 100,
              )
            ],
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
              Navigator.of(context).push(
                  buildRoute(const Register(type: 2000, label: 'Passenger')));
            },
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Color(0xff50524f),
                fontFamily: 'Montserrat',
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
