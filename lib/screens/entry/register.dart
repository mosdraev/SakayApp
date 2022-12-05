import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/entry/login.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  // final int type;
  // final String label;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController mobileNumberController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool _formSubmitted = false;

  void _togglePasswordObscured() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordObscured() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void registerUser(navigator) async {
    final username = mobileNumberController.text;
    final password = passwordController.text;
    final email = emailController.text.trim();

    ParseUser userObject = ParseUser.createUser(username, password, email);
    var response = await userObject.signUp();

    if (response.success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          Constant.userMobileNumber, mobileNumberController.text);
      navigator.push(buildRoute(const Login()));
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => showAlertDialog(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      floatingActionButton: null,
      bottomNavigationBar: null,
      showBackButton: false,
      title: "Register User",
      widget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GetStarted(),
              const FillupForm(),
              _mobileNumberField(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.black26,
                    ),
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 130, 157, 72)),
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
              _passwordField(),
              _confirmPasswordField(),
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _formSubmitted = true;
                          });
                          var navigator = Navigator.of(context);
                          registerUser(navigator);
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
                              'Create Account',
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
              const AlreadyHaveAccount(),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Registration Error"),
      content: const Text("Failed to create an account, Please try again."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  MobileNumberField _mobileNumberField() =>
      MobileNumberField(mobileNumberController: mobileNumberController);

  Padding _passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
    );
  }

  Padding _confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Password does not match";
          }

          if (value.isNotEmpty) {
            if (passwordController.text != confirmPasswordController.text) {
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
            onTap: _toggleConfirmPasswordObscured,
            child: Icon(
              color: Colors.black26,
              _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          floatingLabelStyle:
              const TextStyle(color: Color.fromARGB(255, 130, 157, 72)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Confirm Password',
        ),
      ),
    );
  }
}

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(buildRoute(const Login()));
            },
            child: const Text(
              'Sign in',
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

class MobileNumberField extends StatelessWidget {
  const MobileNumberField({
    Key? key,
    required this.mobileNumberController,
  }) : super(key: key);

  final TextEditingController mobileNumberController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
          floatingLabelStyle:
              const TextStyle(color: Color.fromARGB(255, 130, 157, 72)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
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
    );
  }
}

class FillupForm extends StatelessWidget {
  const FillupForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9.0, 0, 5.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Fill up the form to get started.',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class GetStarted extends StatelessWidget {
  const GetStarted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Get Started',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
