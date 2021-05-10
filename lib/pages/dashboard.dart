import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/holder/ongoing_order_holders.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/models/select_options.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/pages/new_purchase.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {

    Future<Map<String, dynamic>> fetchOngoingOrders() async {
      var userId = await getUserId();
      var url = "${BASE_URL}api/get_orders/$userId";
      var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw new Exception('Error fetching your orders');
      }
      Map<String, dynamic> map = json.decode(response.body);
      return map;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Gas"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Container(
          color: Colors.grey[200],
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              ListView(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: selectOptionsList.map(buildOptionSelectionList).toList(),
              ),
              Text("Ongoing Orders", style: Theme.of(context).textTheme.headline5!.apply(fontSizeFactor: 0.8, decoration: TextDecoration.underline),),
              FutureBuilder(
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
                future: fetchOngoingOrders(),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionSelectionList(SelectOption selectOption) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(selectOption.image_icon, width: 80, height: 80,),
                SizedBox(width: 8,),
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectOption.title, style: Theme.of(context).textTheme.subtitle2),
                        SizedBox(height: 8,),
                        Text(selectOption.description, style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(height: 8,),
                        ElevatedButton(
                            onPressed: () async{
                              switch (selectOption.select_options_items){
                                case SELECT_OPTIONS_ITEMS.REFILL:
                                  navigateToPage(context, NewPurchasePage(
                                    url: "api/gas",
                                    title: "Refilling",
                                  ));
                                  break;
                                case SELECT_OPTIONS_ITEMS.NEW_PURCHASE:
                                 navigateToPage(context, NewPurchasePage(
                                   url: "api/gas/0",
                                   title: "New Purchase",
                                 ));
                                  break;
                              }
                            }, child: Text(selectOption.buttonText, style: Theme.of(context).textTheme.caption!.apply(color: Colors.white),)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(height: 1,)
          ],
        ),
      ),
    );
  }
}
