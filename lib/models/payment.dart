import 'package:flutter/foundation.dart';

class Payment {
  final id,callback_phone,callback_amount,mpesa_receipt_number, created_at_parsed;
  Payment({
    @required this.id,
    @required this.callback_phone,
    @required this.callback_amount,
    @required this.mpesa_receipt_number,
    @required this.created_at_parsed,
  });

  static Payment fromJson(dynamic json) {
    return Payment(
      id: json['id'],
      callback_phone: json['callback_phone'],
      callback_amount: json['callback_amount'],
      mpesa_receipt_number: json['mpesa_receipt_number'],
      created_at_parsed: json['created_at_parsed'],
    );
  }
}
