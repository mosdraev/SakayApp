import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakay_v2/api/service.dart';

import 'app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  Service.connect();

  runApp(const App());
}
