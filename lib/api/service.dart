// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

const keyApplicationId = 'MhFXqr7K8dQIAMX61Ag8dTHDfkI4rkqOSMNCtHZ8';
const keyClientKey = '99uTxRU26iN0U5t9g3zoCcbqhbZdgvFHS0Ytvy5U';
const keyParseServerUrl = 'https://parseapi.back4app.com';

class Service {
  static connect() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
  }

  static getUser() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  static getUserProfile(objectId) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));
    parseQuery.whereEqualTo('userObjectId', objectId);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // ignore: prefer_typing_uninitialized_variables
      var userData;
      for (var o in apiResponse.results!) {
        userData = jsonDecode((o as ParseObject).toString());
      }
      return userData;
    }
    return null;
  }
}
