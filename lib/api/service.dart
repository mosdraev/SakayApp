// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:sakay_v2/static/constant.dart';

const keyApplicationId = 'lBeOw2i9gvsTsvfCMiPh51TwfiVqPiPSZF6liOss';
const keyClientKey = 'tm17H6rNXSBskhZ8097NdIL6SeUpXe7weENTz7vg';
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

  static getUserByToken(token) async {
    ParseResponse? currentUser =
        await ParseUser.getCurrentUserFromServer(token);
    return currentUser?.result;
  }

  static getUserProfile(objectId) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));
    parseQuery.whereEqualTo('userObjectId', objectId);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // ignore: prefer_typing_uninitialized_variables
      var data;
      for (var o in apiResponse.results!) {
        data = jsonDecode((o as ParseObject).toString());
      }
      return data;
    }
    return null;
  }

  static getDrivers() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));
    parseQuery.whereEqualTo('accountType', Constant.accountDriver);
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // ignore: prefer_typing_uninitialized_variables
      List<dynamic> data = [];
      for (var o in apiResponse.results!) {
        data.add(jsonDecode((o as ParseObject).toString()));
      }
      return data;
    }
    return null;
  }

  static getUserPlaces(objectId) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Place'));
    parseQuery.whereEqualTo('userObjectId', objectId);
    parseQuery.orderByDescending('createdAt');
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      List<dynamic> data = [];
      for (var o in apiResponse.results!) {
        data.add(jsonDecode((o as ParseObject).toString()));
      }
      return data;
    }
    return null;
  }

  static getDriverUserPlaces(objectId) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Place'));
    parseQuery.whereEqualTo('driverUserObjectId', objectId);
    parseQuery.orderByDescending('createdAt');
    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      List<dynamic> data = [];
      for (var o in apiResponse.results!) {
        data.add(jsonDecode((o as ParseObject).toString()));
      }
      return data;
    }
    return null;
  }
}
