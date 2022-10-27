import 'package:flutter/material.dart';
import 'package:sakay_v2/components/main_layout.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Change Password',
      floatingActionButton: null,
      bottomNavigationBar: null,
      widget: Text('change password form'),
    );
  }
}
