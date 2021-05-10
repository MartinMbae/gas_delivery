import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/models/select_options.dart';
import 'package:gas_delivery/pages/new_purchase.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {

    Future<bool> fetchOngoingOrders() async{
      await Future.delayed(Duration(seconds: 3));
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Gas"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Container(
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
                if(snapshot.hasData){
                  Object? data = snapshot.data;
                  if (data == false){
                    return Column(
                      children: [
                        SizedBox(height: 40,),
                        Image.asset('assets/not_found.png', height: 80, width: 80,),
                        Text("Oops! No orders found",style: Theme.of(context).textTheme.caption,)
                      ],
                    );
                  }else{
                    return Text("Inflate ongoing Orders");
                  }
                }else{
                  return Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),
                  );
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
    return Padding(
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
    );
  }
}
