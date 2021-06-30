import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/holder/ongoing_order_holders.dart';
import 'package:gas_delivery/holder/payment_holders.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/models/payment.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class PaymentsFragment extends StatefulWidget {
  @override
  _PaymentsFragmentState createState() => _PaymentsFragmentState();
}

class _PaymentsFragmentState extends State<PaymentsFragment> {
  @override
  Widget build(BuildContext context) {

    Future<Map<String, dynamic>> fetchPayments() async {
      var userId = await getUserId();
      var url = "${BASE_URL}api/get_all_payments/$userId";
      var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw new Exception('Error fetching your payments');
      }
      Map<String, dynamic> map = json.decode(response.body);
      return map;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: FutureBuilder(
            builder: (context, snapshot){
              if (snapshot.hasData) {
                Map<String, dynamic> mapp = (snapshot.data as Map<String, dynamic>);
                var success = mapp['success'];
                if (!success){
                  return EmptyPage(icon: Icons.error, message: "No payments found",height: 200.0,);
                }
                List<dynamic> payments = mapp['payments'];
                bool hasData = payments.length > 0;
                if(!hasData){
                return   EmptyPage(icon: Icons.error, message: "No payments found",height: 200.0,);
                }
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      return PaymentsHolder(
                        payment:  Payment.fromJson(payments[index]),
                      );
                    });
              } else if(snapshot.hasError){
                return Text("Something went wrong. Please check your internet and try again");
              }else {
                return Center(child: Container(child: CircularProgressIndicator()));
              }
            },
            future: fetchPayments(),),
        ),
      ),
    );
  }
}
