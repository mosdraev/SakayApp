class Place {
  const Place(
    this.userObjectId,
    this.driverUserObjectId,
    this.currentLocation,
    this.destinationLocation,
  );
  final String userObjectId;
  final String driverUserObjectId;
  final String currentLocation;
  final String destinationLocation;

  factory Place.fromJson(dynamic json) {
    return Place(
        json['userObjectId'] as String,
        json['driverUserObjectId'] as String,
        json['currentLocation'] as String,
        json['destinationLocation'] as String);
  }

  @override
  String toString() {
    return '{ $userObjectId, $driverUserObjectId, $currentLocation, $destinationLocation }';
  }
}
