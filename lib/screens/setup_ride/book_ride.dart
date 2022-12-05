import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/api/service.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/models/dropdown_items.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
import 'package:sakay_v2/static/constant.dart';
import 'package:sakay_v2/static/route.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookRide extends StatefulWidget {
  const BookRide({super.key});

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  String? selectedDriver;
  String? errorMessage;
  String? userObjectId;

  bool _formSubmitted = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserObjectId();
  }

  Future<void> getUserObjectId() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      userObjectId = prefs.getString(Constant.userObjectId);
    });
  }

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  _futureData() async {
    return _memoizer.runOnce(() async {
      var drivers = await getDriverUsers();
      var deviceLocation = await _determinePosition();

      return {
        'drivers': drivers,
        'deviceLocation': deviceLocation,
      };
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getDriverUsers() async {
    var data = await Service.getDrivers();
    List<DropdownItems> selectDrivers = <DropdownItems>[];

    if (data != null) {
      for (var dataUser in data) {
        selectDrivers.add(DropdownItems(dataUser['userObjectId'],
            '${dataUser['firstName']}  ${dataUser['lastName']}'));
      }

      return selectDrivers;
    }

    return null;
  }

  Future alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: buttonBackgroundColor,
            size: 60,
          ),
          title: const Text(
            'Success!',
            style: TextStyle(
              fontFamily: defaultFont,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text('Booking added successfully.'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  // elevation: 15,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: buttonBackgroundColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    'Back to Places',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: defaultFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(context).push(buildRoute(const Index(
                    defaultIndex: 0,
                  )));
                },
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorContext = Navigator.of(context);

    return MainLayout(
      title: 'Book a Ride',
      widget: Container(
        decoration: const BoxDecoration(color: Colors.white70),
        child: SlidingUpPanel(
          maxHeight: 350,
          panel: FutureBuilder(
            future: _futureData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading form'));
                  } else {
                    final Object? data;
                    if (snapshot.hasData) {
                      data = snapshot.data;
                      var checkData = data as Map;
                      if (checkData['drivers'] == null) {
                        return const Center(child: Text('Error loading form'));
                      } else {
                        return buildForm(navigatorContext, data);
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            },
          ),
          body: FutureBuilder(
            future: _futureData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading map.'));
                  } else {
                    final Object? data;
                    if (snapshot.hasData) {
                      data = snapshot.data;
                      return buildMap(navigatorContext, data);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: null,
      floatingActionButton: null,
    );
  }

  Widget buildMap(navigatorContext, data) {
    var location = data['deviceLocation'];
    List<Marker> markers = [];

    markers.add(Marker(
      point: LatLng(location.latitude, location.longitude),
      width: 30,
      height: 30,
      builder: (context) => IconButton(
        icon: const Icon(Icons.place),
        iconSize: 30.0,
        color: Colors.red,
        onPressed: () {},
      ),
    ));

    void placeMarker(point) {
      var marker = Marker(
        point: point,
        width: 30,
        height: 30,
        builder: (context) => IconButton(
          icon: const Icon(Icons.place),
          iconSize: 30.0,
          color: Colors.blue,
          onPressed: () {},
        ),
      );
      if (markers.asMap().containsKey(1)) {
        markers[1] = marker;
      } else {
        markers.add(marker);
      }
    }

    return FlutterMap(
      // mapController: mapController,
      options: MapOptions(
        center: LatLng(
            location.latitude, location.longitude), // Defaults to Alaminos City
        zoom: 12,
        maxZoom: 18,
        onLongPress: (tapPosition, point) {
          placeMarker(point);
          destinationLocationController.text = json.encode({
            "latitude": point.latitude,
            "longitude": point.longitude,
          });
        },
        // keepAlive: true,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.sakay_v2',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  Widget buildForm(navigatorContext, data) {
    List<DropdownItems> drivers = data['drivers'];
    Position location = data['deviceLocation'];
    LatLng devicePointer = LatLng(location.latitude, location.longitude);

    currentLocationController.text = json.encode({
      "latitude": devicePointer.latitude,
      "longitude": devicePointer.longitude
    });

    DropdownMenuItem<DropdownItems> buildMenuItem(DropdownItems item) =>
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        );

    confirmBooking() async {
      // print(selectedPreviousPlace);
      // print(selectedDriver);
      // print(currentLocationController.text);
      // print(destinationLocationController.value);
      // print(userObjectId);
      ParseObject place = ParseObject('Place');
      place.set('userObjectId', userObjectId);
      place.set('currentLocation', currentLocationController.text);
      place.set(
        'destinationLocation',
        destinationLocationController.text,
      );
      place.set('driverUserObjectId', selectedDriver);

      var response = await place.save();
      return response.success;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
              child: TextFormField(
                readOnly: true,
                controller: currentLocationController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.black26,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Color.fromARGB(255, 130, 157, 72),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 130, 157, 72),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Current Location',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: TextFormField(
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please select a destination from the map.";
                  }
                  return null;
                },
                controller: destinationLocationController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black26,
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
                  labelText: 'Destination',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 6),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a designated driver.';
                    }
                    return null;
                  },
                  isExpanded: true,
                  items: drivers.map(buildMenuItem).toList(),
                  onChanged: (value) {
                    selectedDriver = value?.id;
                  },
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.drive_eta_outlined,
                      color: Colors.black26,
                    ),
                    labelText: 'Select Drivers',
                    floatingLabelStyle: const TextStyle(
                      color: Color.fromARGB(255, 130, 157, 72),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 130, 157, 72), width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: buttonBackgroundColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _formSubmitted = true;
                    });
                    var status = await confirmBooking();

                    if (status == true) {
                      // ignore: use_build_context_synchronously
                      await alertDialog(context);
                      setState(() {
                        _formSubmitted = false;
                      });
                    }
                  }
                },
                child: _formSubmitted
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Color.fromARGB(255, 235, 236, 235),
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            // const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
