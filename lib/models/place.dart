class Place {
  const Place(
    this.userObjectId,
    this.driverUserObjectId,
    this.currentLocation,
    this.destinationLocation,
    this.clientWasDropOff,
    this.clientWasPickedUp,
    this.clientCancelled,
    this.clientPaid,
    this.driverCancelled,
  );
  final String userObjectId;
  final String driverUserObjectId;
  final String currentLocation;
  final String destinationLocation;
  final bool clientWasDropOff;
  final bool clientWasPickedUp;
  final bool clientCancelled;
  final bool clientPaid;
  final bool driverCancelled;

  factory Place.fromJson(dynamic json) {
    return Place(
      json['userObjectId'] as String,
      json['driverUserObjectId'] as String,
      json['currentLocation'] as String,
      json['destinationLocation'] as String,
      json['clientWasDropOff'] as bool,
      json['clientWasPickedUp'] as bool,
      json['clientCancelled'] as bool,
      json['clientPaid'] as bool,
      json['driverCancelled'] as bool,
    );
  }

  @override
  String toString() {
    return '{ $userObjectId, $driverUserObjectId, $currentLocation, $destinationLocation, $clientWasDropOff, $clientWasPickedUp, $driverCancelled, $clientCancelled, $clientPaid }';
  }
}
