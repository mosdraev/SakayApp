class Coord {
  const Coord(
    this.latitude,
    this.longitude,
  );
  final double latitude;
  final double longitude;

  factory Coord.fromJson(dynamic json) {
    return Coord(
      json['latitude'] as double,
      json['longitude'] as double,
    );
  }

  @override
  String toString() {
    return '{ $latitude, $longitude }';
  }
}
