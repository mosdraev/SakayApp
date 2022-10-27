import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sakay_v2/components/main_layout.dart';
import 'package:sakay_v2/models/dropdown_items.dart';
import 'package:sakay_v2/static/style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({super.key});

  @override
  State<PrepareRide> createState() => _PrepareRideState();
}

class _PrepareRideState extends State<PrepareRide> {
  int? previousPlace;
  int? drivers;
  var latLang;

  final List<Marker> _markers = [];

  MapController mapController = MapController();
  TextEditingController currentLocation = TextEditingController();
  TextEditingController destinationLocation = TextEditingController();

  var currentDevicePosition;

  @override
  void initState() {
    super.initState();

    _markers.add(
      Marker(
        point: (latLang != null) ? latLang : LatLng(16.1653, 119.976),
        width: 45,
        height: 45,
        builder: (context) => IconButton(
          icon: const Icon(Icons.place),
          iconSize: 45.0,
          color: Colors.red,
          onPressed: () {},
        ),
      ),
    );
    _getPosition();
  }

  void _getPosition() async {
    currentDevicePosition = await _determinePosition();
    print(currentDevicePosition.latitude.toString());
    print(currentDevicePosition.longitude.toString());
    relocateMarker(LatLng(
        currentDevicePosition.latitude, currentDevicePosition.longitude));
  }

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

  void relocateMarker(point) {
    _markers[0] = Marker(
      point: point,
      width: 30,
      height: 30,
      builder: (context) => IconButton(
        icon: const Icon(Icons.place),
        iconSize: 30.0,
        color: Colors.red,
        onPressed: () {},
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Book a Ride',
      widget: Container(
        decoration: const BoxDecoration(color: Colors.white70),
        child: SlidingUpPanel(
          panel: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextFormField(
                  controller: currentLocation,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextFormField(
                  controller: destinationLocation,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    items: selectPlaces.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      previousPlace = value?.id;
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
                            color: Color.fromARGB(255, 130, 157, 72),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    items: selectRiders.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      drivers = value?.id;
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
                            color: Color.fromARGB(255, 130, 157, 72),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 15,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    // minimumSize: const Size(30, 10),
                    backgroundColor: buttonBackgroundColor,
                  ),
                  onPressed: () {},
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
              const SizedBox(
                height: 80,
              )
            ],
          ),
          body: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(16.1653, 119.976), // Defaults to Alaminos City
              zoom: 12,
              maxZoom: 18,
              onTap: (tapPosition, point) {
                latLang = point;
                relocateMarker(point);
                setState(() {
                  currentLocation.text = point.toString();
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
              MarkerLayer(markers: _markers),
            ],
          ),
        ),
      ),
      bottomNavigationBar: null,
      floatingActionButton: null,
    );
  }
}
