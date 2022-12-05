import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/models/address.dart';
import 'package:sakay_v2/models/coord.dart';
import 'package:sakay_v2/models/place.dart';
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
  String? userSessionToken;
  bool cancelClientBookingClicked = false;
  bool clientPaidBookingClicked = false;

  @override
  void initState() {
    super.initState();
  }

  _futureData() async {
    var prefs = await SharedPreferences.getInstance();
    var userObjectId = prefs.getString(Constant.userObjectId);
    var currentUserData = await Service.getUserProfile(userObjectId);
    var dataPlaces;

    if (currentUserData != null &&
        currentUserData['accountType'] == Constant.accountDriver) {
      dataPlaces = await Service.getDriverUserPlaces(userObjectId);
    } else {
      dataPlaces = await Service.getUserPlaces(userObjectId);
    }

    var placeAddress = [];

    if (dataPlaces != null) {
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
    } else {
      dataPlaces = null;
    }

    return {
      'placeAddress': placeAddress,
      'places': dataPlaces,
      'userData': currentUserData,
    };
  }

  cancelBookingByClient(placeObjectId, accountType) async {
    var place = ParseObject('Place');
    place.set('objectId', placeObjectId);
    if (accountType == Constant.accountDriver) {
      place.set('driverCancelled', true);
    } else {
      place.set('clientCancelled', true);
    }

    var response = await place.update();
    return response.success;
  }

  clientWasPickedUp(placeObjectId) async {
    var place = ParseObject('Place');
    place.set('objectId', placeObjectId);
    place.set('clientWasPickedUp', true);

    var response = await place.update();
    return response.success;
  }

  clientWasDroppedOff(placeObjectId) async {
    var place = ParseObject('Place');
    place.set('objectId', placeObjectId);
    place.set('clientWasDropOff', true);

    var response = await place.update();
    return response.success;
  }

  clientPaidBooking(placeObjectId) async {
    var place = ParseObject('Place');
    place.set('objectId', placeObjectId);
    place.set('clientPaid', true);

    var response = await place.update();
    return response.success;
  }

  Future cancelBooking(BuildContext context, placeObjectId, accountType) {
    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.amber,
            size: 60,
          ),
          content: const Text(
            'Do you want to cancel booking?',
            style: TextStyle(
              fontFamily: defaultFont,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // shape: const StadiumBorder(),
                // elevation: 15,
                // padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.grey,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: defaultFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).push(buildRoute(const Index(
                //   defaultIndex: 0,
                // )));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: const StadiumBorder(),
                  // elevation: 15,
                  // padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.red,
                ),
                child: cancelClientBookingClicked
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 235, 236, 235),
                          strokeWidth: 3,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: defaultFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                onPressed: () async {
                  setState(() {
                    cancelClientBookingClicked = true;
                  });
                  var result =
                      await cancelBookingByClient(placeObjectId, accountType);

                  if (result) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      cancelClientBookingClicked = false;
                    });
                  }
                  // Navigator.of(context).push(buildRoute(const Index(
                  //   defaultIndex: 0,
                  // )));
                },
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }

  Future clientPaymentDialog(BuildContext context, placeObjectId) {
    Navigator.pop(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_rounded,
            color: Colors.amber,
            size: 60,
          ),
          content: const Text(
            'Click yes if your client made a payment?',
            style: TextStyle(
              fontFamily: defaultFont,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // shape: const StadiumBorder(),
                // elevation: 15,
                // padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.grey,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: defaultFont,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).push(buildRoute(const Index(
                //   defaultIndex: 0,
                // )));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // shape: const StadiumBorder(),
                  // elevation: 15,
                  // padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: buttonBackgroundColor,
                ),
                child: clientPaidBookingClicked
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 235, 236, 235),
                          strokeWidth: 3,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          'YES',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: defaultFont,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                onPressed: () async {
                  setState(() {
                    clientPaidBookingClicked = true;
                  });
                  var result = await clientPaidBooking(placeObjectId);

                  if (result) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    setState(() {
                      clientPaidBookingClicked = false;
                    });
                  }
                  // Navigator.of(context).push(buildRoute(const Index(
                  //   defaultIndex: 0,
                  // )));
                },
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
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
                var checkData = data as Map;

                if (checkData['places'] == null) {
                  return const Center(child: Text('Empty Results'));
                } else {
                  return buildListPlaces(navigationContext, data);
                }
              } else {
                return const Center(child: Text('Empty Results'));
              }
            }
        }
      },
    );
  }

  Widget buildListPlaces(navigationContext, data) {
    var userData = data['userData'];
    var places = data['places'];
    var placeAddress = data['placeAddress'];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          var placeObject = Place.fromJson(places[index]);
          var placeObjectId = places[index]['objectId'];
          var placeArray = placeAddress[index][placeObjectId];
          var from = (placeArray != null) ? placeArray['from'] : '';
          var to = (placeArray != null) ? placeArray['to'] : '';

          return Card(
            color: placeObject.clientCancelled ? Colors.grey[300] : null,
            elevation: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    if (userData['accountType'] == Constant.accountPassenger) {
                      _showModalClient(
                          context, placeObjectId, userData['accountType']);
                    } else {
                      _showModalDriver(
                          context, placeObjectId, userData['accountType']);
                    }
                  },
                  onLongPress: () {
                    if (userData['accountType'] == Constant.accountPassenger) {
                      _showModalClientInfo(context, placeObject);
                    } else {
                      _showModalDriverInfo(context, placeObject);
                    }
                  },
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      placeObject.clientCancelled
                          ? const Icon(
                              Icons.location_off,
                              size: 25,
                            )
                          : const Icon(Icons.place, size: 25),
                    ],
                  ),
                  trailing: placeObject.clientCancelled
                      ? null
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.arrow_forward_ios,
                                size: 25, color: buttonBackgroundColor),
                          ],
                        ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text('To: $to',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('From: $from',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  dense: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showModalClient(context, placeObjectId, accountType) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.orange,
                ),
                title: const Text('Cancel Booking'),
                onTap: () {
                  cancelBooking(context, placeObjectId, accountType);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.drive_eta_outlined,
                  color: Colors.green,
                ),
                title: const Text('Picked Up by Driver'),
                onTap: () {
                  clientWasPickedUp(placeObjectId);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.drive_eta_rounded,
                  color: Colors.red,
                ),
                title: const Text('Dropped off by Driver'),
                onTap: () {
                  clientWasDroppedOff(placeObjectId);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _showModalDriver(context, placeObjectId, accountType) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.cancel_outlined,
                color: Colors.orange,
              ),
              title: const Text('Cancel Booking'),
              onTap: () {
                cancelBooking(context, placeObjectId, accountType);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.paid_outlined,
                color: Colors.green,
              ),
              title: const Text('Client Paid'),
              onTap: () {
                clientPaymentDialog(context, placeObjectId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showModalDriverInfo(context, placeObject) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            placeObject.clientCancelled == true
                ? ListTile(
                    leading: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    title: const Text('Client Cancelled'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                : const Text(''),
          ],
        );
      },
    );
  }

  void _showModalClientInfo(context, placeObject) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: (placeObject.clientWasPickedUp == true)
                    ? Colors.green
                    : null,
              ),
              title: const Text('Client was picked up.'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: (placeObject.clientWasDropOff == true)
                    ? Colors.green
                    : null,
              ),
              title: const Text('Client was dropped off.'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            placeObject.driverCancelled == true
                ? ListTile(
                    leading: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                    title: const Text('Driver Cancelled'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                : const Text(''),
          ],
        );
      },
    );
  }
}
