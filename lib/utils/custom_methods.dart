import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> navigateToPageRemoveHistory(
    BuildContext context, Widget newRoute) async {
   await Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => newRoute), (route) => false);
}

Future navigateToPage(context, page) async {
  return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}


String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  DateFormat format = DateFormat('dd MMM yyyy');
  String formattedDate = format.format(dateTime);
  return formattedDate;
}

String formatCharges(String amount) {
  double am = double.parse(amount);
  return am == 0 ? "Free" : "$am";
}
