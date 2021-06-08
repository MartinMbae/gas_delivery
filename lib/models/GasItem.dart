import 'package:flutter/foundation.dart';

class GasItem {
  final id,company_id,classification,weight,initialPrice, price, availability,company_name, url;

  int count = 1;

  GasItem({
    @required this.id,
    @required this.company_id,
    @required this.classification,
    @required this.weight,
    @required this.initialPrice,
    @required this.price,
    @required this.availability,
    @required this.company_name,
    @required this.url,
  });

  static GasItem fromJson(dynamic json) {
    return GasItem(
      id: json['id'],
      company_id: json['company_id'],
      classification: json['classification'],
      weight: json['weight'],
      initialPrice: json['initialPrice'],
      price: json['price'],
      availability: json['availability'],
      company_name: json['company_name'],
      url: json['url'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'company_id' : company_id,
      'classification' : classification,
      'weight' : weight,
      'initialPrice' : initialPrice,
      'price' : price,
      'availability' : availability,
      'company_name' : company_name,
      'url' : url,
      'count' : count,
    };
  }

  void setCount(int newCount){
    count = newCount;
  }
}
