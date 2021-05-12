import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/holder/ongoing_order_holders.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {

    Future<Map<String, dynamic>> fetchOrders() async {
      var userId = await getUserId();
      var url = "${BASE_URL}api/get_all_orders/$userId";
      var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw new Exception('Error fetching your orders');
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
                  return EmptyPage(icon: Icons.error, message: "No orders found",height: 200.0,);
                }
                List<dynamic> incidents = mapp['orders'];
                bool hasData = incidents.length > 0;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: incidents.length,
                    itemBuilder: (context, index) {
                      return hasData
                          ? OngoingOrderHolder(
                        ongoingOrder:  OngoingOrder.fromJson(incidents[index]),
                      )
                          : Column(
                        children: [
                          SizedBox(height: 40,),
                          Image.asset('assets/not_found.png', height: 80, width: 80,),
                          Text("Oops! No orders found",style: Theme.of(context).textTheme.caption,)
                        ],
                      );
                    });
              } else if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }else {
                return Center(child: Container(child: CircularProgressIndicator()));
              }
            },
            future: fetchOrders(),),
        ),
      ),
    );
  }
}
