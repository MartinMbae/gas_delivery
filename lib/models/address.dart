import 'package:flutter/foundation.dart';

class UserAddress {

  final id,address,house_number,apartment_estate,landmark;

  UserAddress({
    @required this.id,
    @required this.address,
    @required this.house_number,
    @required this.apartment_estate,
    @required this.landmark,
  });

  static UserAddress fromJson(dynamic json) {
    return UserAddress(
      id: json['id'],
      address: json['address'],
      house_number: json['house_number'],
      apartment_estate: json['apartment_estate'],
      landmark: json['landmark'],
    );
  }
}
