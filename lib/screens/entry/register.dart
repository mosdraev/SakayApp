import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.type, required this.label});

  final int type;
  final String label;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController mobileNumberController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showPassword = true;
  bool _showConfirmPassword = true;

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

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
              _passwordField(),
              _confirmPasswordField(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        minimumSize: const Size(30, 10),
                        // fixedSize: const Size.fromWidth(150),
                        backgroundColor: buttonBackgroundColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var navigator = Navigator.of(context),
                              userObject = ParseUser.createUser(
                                  mobileNumberController.text,
                                  passwordController.text),
                              response = await userObject.signUp(
                                  allowWithoutEmail: true);

                          if (response.success) {
                            final prefs = await SharedPreferences.getInstance();

                            var userType = {
                              "mobileNumber": mobileNumberController.text,
                              "type": widget.type
                            };

                            // set value
                            await prefs.setString(
                                'userType', userType.toString());

                            navigator.push(buildRoute(const Index()));
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => showAlertDialog(context));
                          }
                        }
                      },
                      child: const Text(
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
        children: const [
          Text(
            'Already have an account?',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Sign in',
            style: TextStyle(
              color: Color(0xff50524f),
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          )
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
          prefixText: '+63',
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
