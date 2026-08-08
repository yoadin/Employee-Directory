/// Domain entity representing a user profile.
class UserAddress {
  const UserAddress({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  final String city;
  final String street;
  final String number;
  final String zipcode;

  @override
  String toString() => '$number $street, $city $zipcode';
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final UserAddress address;

  String get fullName => '$firstName $lastName';
}
