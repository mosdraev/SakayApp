import 'package:geocoding/geocoding.dart';

class Address {
  static getAddress(Placemark data) {
    return '${data.street} ${data.subAdministrativeArea}'
        ' ${data.administrativeArea} ${data.locality} ${data.country} ${data.postalCode}';
  }
}
