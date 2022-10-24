import 'package:flutter/material.dart';
import 'package:sakay_v2/static/style.dart';

class MainLayout extends StatefulWidget {
  const MainLayout(
      {super.key,
      required this.title,
      required this.widget,
      required this.bottomNavigationBar,
      required this.floatingActionButton,
      this.showBackButton});

  final String title;
  final bool? showBackButton;
  final Widget? widget;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.showBackButton ?? true,
          title: Text(widget.title),
          // centerTitle: true,
          backgroundColor: appBackgroundColor,
          shadowColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: widget.widget!,
          ),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
