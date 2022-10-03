import 'package:flutter/material.dart';
import 'package:sakay_v2/components/main_layout.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      showBackButton: false,
      title: '',
      widget: Text('Success'),
    );
  }
}
