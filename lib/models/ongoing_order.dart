import 'package:flutter/foundation.dart';
import 'package:gas_delivery/models/accessory.dart';

class OngoingOrder {
  final id,address,house_number,apartment_estate,landmark,
      created_at_parsed, status , gasItemsOrders,accessoryItemsOrders ;
  OngoingOrder({
    @required this.id,
    @required this.address,
    @required this.house_number,
    @required this.apartment_estate,
    @required this.landmark,
    @required this.created_at_parsed,
    @required this.status,
    @required this.gasItemsOrders,
    @required this.accessoryItemsOrders,
  });

  static OngoingOrder fromJson(dynamic json) {
    return OngoingOrder(
      id: json['id'],
      address: json['address'],
      house_number: json['house_number'],
      apartment_estate: json['apartment_estate'],
      landmark: json['landmark'],
      created_at_parsed: json['created_at_parsed'],
      status: json['status'],
      gasItemsOrders: json['gasItemsOrders'],
      accessoryItemsOrders: json['accessoryItemsOrders'],
    );
  }

  List<dynamic> getOrderedAccessories(){
    List<dynamic> accessories = accessoryItemsOrders;
    return accessories;
  }
  List<dynamic> getOrderedGasItems(){
    List<dynamic> gasItems = gasItemsOrders;
    return gasItems;
  }
}
