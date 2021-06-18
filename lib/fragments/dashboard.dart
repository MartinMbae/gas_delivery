import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/holder/accessory_holders.dart';
import 'package:gas_delivery/holder/ongoing_order_holders.dart';
import 'package:gas_delivery/models/accessory.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/models/select_options.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/pages/new_purchase.dart';
import 'package:gas_delivery/utils/colors.dart';
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
      var response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw new Exception('Action took so long');
      });
      if (response.statusCode != 200) {
        throw new Exception('Error fetching your orders');
      }

      Map<String, dynamic> map = json.decode(response.body);
      return map;
    }

    Future<Map<String, dynamic>> fetchAccessories() async {
      var url = "${BASE_URL}api/accessories";
      var response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 30), onTimeout: () {
        throw new Exception('Action took so long');
      });
      if (response.statusCode != 200) {
        throw new Exception('Error fetching your orders');
      }
      Map<String, dynamic> map = json.decode(response.body);
      return map;
    }

    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        height: size.height,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text("Gas Accessories", style: Theme.of(context).textTheme.subtitle1!.copyWith(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: primaryColorDark),),
              ),

              FutureBuilder(
                future: fetchAccessories(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return Center(
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(vertical: 20),
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //   );
                    // } else
                      if (snapshot.hasData) {

                      Map<String, dynamic> mapp =
                      (snapshot.data as Map<String, dynamic>);
                      var success = mapp['success'];
                      if (!success) {
                        return EmptyPage(
                          icon: Icons.error,
                          message: "No accessories found",
                          height: 200.0,
                        );
                      }
                      List<dynamic> accessories = mapp['accessories'];
                      bool hasData = accessories.length > 0;

                      if (!hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Image.asset(
                              'assets/not_found.png',
                              height: 80,
                              width: 80,
                            ),
                            Text(
                              "Oops! No accessory found",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,
                            )
                          ],
                        );
                      }

                      int accessoriesCount = accessories.length;

                      int columnCount = 3;
                      if(accessoriesCount > (columnCount * 2)){
                        accessoriesCount = (columnCount * 2);
                      }
                      return Container(
                        height: 220,
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              child: ListView.builder(
                                itemCount: accessoriesCount,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return AccessoryHolder(
                                    accessory: Accessory.fromJson(accessories[index]),
                                  );
                                },
                              ),
                            ), 
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return EmptyPage(icon: Icons.error_outline,
                          message: "${snapshot.error}", height: 120.0,);
                    } else {
                      return EmptyPage(icon: Icons.error_outline,
                          message: "Something went wrong", height: 120.0,);
                    }
                  }
              ),
              ListView(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children:
                selectOptionsList.map(buildOptionSelectionList).toList(),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Ongoing Orders",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5!
                    .apply(
                    fontSizeFactor: 0.8, decoration: TextDecoration.underline),
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> mapp =
                    (snapshot.data as Map<String, dynamic>);
                    var success = mapp['success'];
                    if (!success) {
                      return EmptyPage(
                        icon: Icons.error,
                        message: "No orders found",
                        height: 200.0,
                      );
                    }
                    List<dynamic> incidents = mapp['orders'];
                    bool hasData = incidents.length > 0;

                    if (!hasData) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Image.asset(
                            'assets/not_found.png',
                            height: 80,
                            width: 80,
                          ),
                          Text(
                            "Oops! No ongoing orders found",
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          )
                        ],
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: incidents.length,
                        itemBuilder: (context, index) {
                          return OngoingOrderHolder(
                            ongoingOrder:
                            OngoingOrder.fromJson(incidents[index]),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return EmptyPage(
                      icon: Icons.error,
                      message: snapshot.error.toString(),
                      height: 200.0,
                    );
                  } else {
                    return Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
                        child: Center(child: CircularProgressIndicator()));
                  }
                },
                future: fetchOngoingOrders(),
              ),
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
                Image.asset(
                  selectOption.image_icon,
                  width: 80,
                  height: 80,
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectOption.title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle2),
                        SizedBox(
                          height: 8,
                        ),
                        Text(selectOption.description,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2),
                        SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            switch (selectOption.select_options_items) {
                              case SELECT_OPTIONS_ITEMS.REFILL:
                                navigateToPage(
                                    context,
                                    NewPurchasePage(
                                      url: "api/gas",
                                      title: "Refilling",
                                    ));
                                break;
                              case SELECT_OPTIONS_ITEMS.NEW_PURCHASE:
                                navigateToPage(
                                    context,
                                    NewPurchasePage(
                                      url: "api/gas/0",
                                      title: "New Purchase",
                                    ));
                                break;
                            }
                          },
                          child: Text(
                            selectOption.buttonText,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption!
                                .apply(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
