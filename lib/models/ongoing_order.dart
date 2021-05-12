import 'package:flutter/foundation.dart';

class OngoingOrder {
  final id,address,house_number,apartment_estate,landmark,total_price,classification,weight, initialPrice,price,company_name, created_at_parsed, status ;
  OngoingOrder({
    @required this.id,
    @required this.address,
    @required this.house_number,
    @required this.apartment_estate,
    @required this.landmark,
    @required this.total_price,
    @required this.classification,
    @required this.weight,
    @required this.initialPrice,
    @required this.price,
    @required this.company_name,
    @required this.created_at_parsed,
    @required this.status,
  });

  static OngoingOrder fromJson(dynamic json) {
    return OngoingOrder(
      id: json['id'],
      address: json['address'],
      house_number: json['house_number'],
      apartment_estate: json['apartment_estate'],
      landmark: json['landmark'],
      total_price: json['total_price'],
      classification: json['classification'],
      weight: json['weight'],
      initialPrice: json['initialPrice'],
      price: json['price'],
      company_name: json['company_name'],
      created_at_parsed: json['created_at_parsed'],
      status: json['status'],
    );
  }
}
