import 'package:flutter/foundation.dart';

class Accessory {
  final id,title,description,url, initialPrice,price ;
  Accessory({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.initialPrice,
    @required this.price
  });

  static Accessory fromJson(dynamic json) {
    return Accessory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      initialPrice: json['initialPrice'],
      price: json['price'],
    );
  }
}
