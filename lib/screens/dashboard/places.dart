import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/models/address.dart';
import 'package:sakay_v2/models/coord.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  String? userObjectId;

  @override
  void initState() {
    super.initState();
    getUserProfileData();
  }

  Future<dynamic> getUserProfileData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      userObjectId = prefs.getString(Constant.userObjectId);
    });
  }

  _futureData() async {
    var dataPlaces = await Service.getUserPlaces(userObjectId);
    // var currentUserData = await Service.getUserProfile(userObjectId);
    var placeAddress = [];

    for (var place in dataPlaces) {
      var from = Coord.fromJson(jsonDecode(place['currentLocation']));
      var to = Coord.fromJson(jsonDecode(place['destinationLocation']));
      var fromPlaceMark =
          await placemarkFromCoordinates(from.latitude, from.longitude);
      var toPlaceMark =
          await placemarkFromCoordinates(to.latitude, to.longitude);

      var fromAddress = Address.getAddress(fromPlaceMark.first);
      var toAddress = Address.getAddress(toPlaceMark.first);

      // print(fromPlaceMark);
      // print(toPlaceMark);

      placeAddress.add({
        place['objectId']: {'from': fromAddress, 'to': toAddress}
      });

      // placeAddress.add({
      //   place['objectId']: {'from': 'test', 'to': 'test'}
      // });
    }

    return {
      'placeAddress': placeAddress,
      'places': dataPlaces,
      // 'userData': currentUserData,
    };
  }

  @override
  Widget build(BuildContext context) {
    var navigationContext = Navigator.of(context);
    return FutureBuilder(
        future: _futureData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Text('Failed to connect to server ${snapshot.error}');
              } else {
                if (snapshot.hasData) {
                  Object? data = snapshot.data;
                  return buildListPlaces(navigationContext, data);
                } else {
                  return const Text('Empty Results');
                }
              }
          }
        });
  }

  Widget buildListPlaces(navigationContext, data) {
    // var userData = data['userData'];
    var places = data['places'];
    var placeAddress = data['placeAddress'];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          var placeObjectId = places[index]['objectId'];
          var placeArray = placeAddress[index][placeObjectId];
          var from = (placeArray != null) ? placeArray['from'] : '';
          var to = (placeArray != null) ? placeArray['to'] : '';
          // print(from);
          // print(to);

          return Card(
            elevation: 2,
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.place, size: 35),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_forward_ios,
                      size: 25, color: buttonBackgroundColor),
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text('To: $to'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('From: $from'),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              dense: true,
            ),
          );
        },
      ),
    );
  }
}
