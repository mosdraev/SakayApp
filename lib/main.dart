import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakay_v2/api/service.dart';

import 'app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black45,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black45,
    ),
  );

  Service.connect();

  runApp(const App());
}
