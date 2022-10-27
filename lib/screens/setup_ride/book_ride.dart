import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/models/dropdown_items.dart';
import 'package:sakay_v2/screens/dashboard/index.dart';
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
  late Future<Position> deviceLocation;
  int? selectedPreviousPlace;
  int? selectedDriver;

  String? userObjectId;

  TextEditingController currentLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDeviceLocation();
    getUserObjectId();
  }

  Future<void> getUserObjectId() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      userObjectId = prefs.getString('objectId');
    });
  }

  void getDeviceLocation() {
    deviceLocation = _determinePosition();
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
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorContext = Navigator.of(context);

    return MainLayout(
      title: 'Book a Ride',
      widget: Container(
        decoration: const BoxDecoration(color: Colors.white70),
        child: SlidingUpPanel(
          panel: FutureBuilder(
            future: deviceLocation,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return const Text('Error loading form');
                  } else {
                    final Object? data;
                    if (snapshot.hasData) {
                      data = snapshot.data;
                      return buildForm(navigatorContext, data);
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            },
          ),
          body: FutureBuilder(
            future: deviceLocation,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return const Text('Error loading map.');
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
    List<Marker> markers = [];

    markers.add(Marker(
      point: LatLng(data.latitude, data.longitude),
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
        center:
            LatLng(data.latitude, data.longitude), // Defaults to Alaminos City
        zoom: 12,
        maxZoom: 18,
        onLongPress: (tapPosition, point) {
          placeMarker(point);
          destinationLocationController.text = point.toString();
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
    LatLng devicePointer = LatLng(data.latitude, data.longitude);

    currentLocationController.text = devicePointer.toString();

    List<DropdownItems> selectRiders = <DropdownItems>[
      const DropdownItems(100, 'Driver 1'),
      const DropdownItems(200, 'Driver 2'),
      const DropdownItems(300, 'Driver 3'),
    ];

    List<DropdownItems> selectPlaces = <DropdownItems>[
      const DropdownItems(100, 'Place 1'),
      const DropdownItems(200, 'Place 2'),
      const DropdownItems(300, 'Place 3'),
    ];

    DropdownMenuItem<DropdownItems> buildMenuItem(DropdownItems item) =>
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        );

    void confirmBooking() async {
      // print(selectedPreviousPlace);
      // print(selectedDriver);
      // print(currentLocationController.text);
      // print(destinationLocationController.text);
      // print(userObjectId);

      if (selectedPreviousPlace != null) {
        destinationLocationController.text = selectPlaces
            .where((type) => type.id == selectedPreviousPlace)
            .single
            .name;
      }

      ParseObject place = ParseObject('Place');
      place.set('userObjectId', userObjectId);
      place.set('currentLocation', currentLocationController.text.trim());
      place.set(
        'destinationLocation',
        destinationLocationController.text.trim(),
      );
      place.set('driverUserObjectId', selectedDriver.toString());

      var response = await place.save();

      print(response.success);
      print(response.statusCode);

      if (response.success) {
        navigatorContext.push(buildRoute(const Index(
          defaultIndex: 1,
        )));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: TextFormField(
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              isExpanded: true,
              items: selectPlaces.map(buildMenuItem).toList(),
              onChanged: (value) {
                selectedPreviousPlace = value?.id;
              },
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.place_outlined,
                  color: Colors.black26,
                ),
                labelText: 'Select Previous Destinations',
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              isExpanded: true,
              items: selectRiders.map(buildMenuItem).toList(),
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
            onPressed: () {
              confirmBooking();
            },
            child: const Text(
              'Confirm Booking',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
