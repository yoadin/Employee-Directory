import 'package:ecommerce_app/features/profile/domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final String street;
  final String number;
  final String zipcode;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final address = json['address'] as Map<String, dynamic>;
    return UserProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: name['firstname'] as String,
      lastName: name['lastname'] as String,
      phone: json['phone'] as String,
      city: address['city'] as String,
      street: address['street'] as String,
      number: address['number'].toString(),
      zipcode: address['zipcode'] as String,
    );
  }

  UserProfile toEntity() => UserProfile(
        id: id,
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: UserAddress(
          city: city,
          street: street,
          number: number,
          zipcode: zipcode,
        ),
      );
}
