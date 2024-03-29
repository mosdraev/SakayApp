class ProfileData {
  const ProfileData(
    this.userObjectId,
    this.firstName,
    this.lastName,
    this.idType,
    this.accountType,
  );
  final String userObjectId;
  final String firstName;
  final String lastName;
  final int idType;
  final int accountType;

  factory ProfileData.fromJson(dynamic json) {
    return ProfileData(
      json['userObjectId'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['idType'] as int,
      json['accountType'] as int,
    );
  }

  @override
  String toString() {
    return '{ $userObjectId, $firstName, $lastName, $idType. $accountType }';
  }
}
