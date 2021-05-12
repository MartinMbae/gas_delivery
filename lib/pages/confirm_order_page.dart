import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/models/address.dart';
import 'package:gas_delivery/fragments/dashboard.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;


class ConfirmOrderPage extends StatefulWidget {

  final GasItem gasItem;
  final int count;
  final UserAddress userAddress;

  const ConfirmOrderPage({Key? key, required this.gasItem, required this.count, required this.userAddress}) : super(key: key);

  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {


  late ArsProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {


    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          color: Colors.grey[100],
          child: Card(
            margin: EdgeInsets.all(8),
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset("assets/logo.jpg", width: 60, height: 60,),
                              Text(widget.gasItem.company_name, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 1,),
                            ],
                          ),
                        ),

                        SizedBox(width: 8,),
                        Flexible(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                    tag: 'description${widget.gasItem.id}',
                                    child: Text("${widget.gasItem.weight} KG ${widget.gasItem.classification}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.9))),
                                SizedBox(height: 8,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                      ],
                    ),

                    SizedBox(height: 20,),
                    RichText(text: TextSpan(children: [
                      TextSpan(text: "Price per Unit : "),

                      if(widget.gasItem.initialPrice != null)
                      TextSpan(text: "Ksh ${widget.gasItem.initialPrice}  ", style: Theme.of(context).textTheme.caption!.apply(decoration: TextDecoration.lineThrough, color: Colors.redAccent, fontSizeFactor: 0.9)),
                      TextSpan(text: "Ksh ${widget.gasItem.price}"),
                    ],
                    style: TextStyle(color: Colors.black)
                    )),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        Text("Number of items  "),
                        Text("${widget.count}", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green)),
                      ],
                    ),
                    SizedBox(height: 8,),
                    RichText(text: TextSpan(children: [
                      TextSpan(text: "Total Price: "),
                      TextSpan(text: "Ksh ${int.parse(widget.gasItem.price) * widget.count }", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green)),
                    ],
                        style: TextStyle(color: Colors.black)
                    )),
                    SizedBox(height: 20,),

                    Divider(height: 2,),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Order Address", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Address : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                          TextSpan(text: "${widget.userAddress.address}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "House Number : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                          TextSpan(text: "${widget.userAddress.house_number}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Apartment Number / Estate : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                          TextSpan(text: "${widget.userAddress.apartment_estate}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Landmark : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                          TextSpan(text: "${widget.userAddress.landmark}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                    Divider(height: 2,),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Business Details", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "Mpesa Till Number : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                          TextSpan(text: "789087", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(onPressed: () async{
                          var user_id = await getUserId();
                          submitNewOrder(int.parse(widget.gasItem.price) * widget.count, widget.count, widget.userAddress.id, widget.gasItem.id, user_id!);
                        }, icon: Icon(Icons.check), label: Text("Submit Order")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitNewOrder(
      int total_price,
      int count,
      int address_id,
      int gas_id,
      String user_id,
      ) async {
    _progressDialog.show();
    String url = BASE_URL + 'api/order';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'user_id': "$user_id",
        'total_price': "$total_price",
        'count': "$count",
        'address_id': "$address_id",
        'gas_id': "$gas_id",
      }).timeout(Duration(seconds: 20));
    } on Exception {
      response = null;
    }
    _progressDialog.dismiss();

    if (response == null) {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText:
          "Page took so long to load. Check your internet access and try again.");
      return null;
    } else if (response.statusCode != 200) {
      Map<String, dynamic> responseError = jsonDecode(response.body);
      List<String> checks = ['user_id', 'total_price','count','address_id','gas_id'];
      String errorMessage = "";
      for (String check in checks) {
        if (responseError.containsKey(check)) {
          errorMessage = "$errorMessage, ${responseError[check][0]}";
        }
      }
      if (errorMessage.isNotEmpty) {
        if (errorMessage.trim().startsWith(",")) {
          errorMessage = errorMessage.replaceFirst(",", "");
        }
        errorMessage = errorMessage.trim();
        DangerAlertBox(
            context: context, title: "Error", messageText: errorMessage);
        return null;
      } else {
        DangerAlertBox(
            context: context,
            title: "Error",
            messageText:
            "An unknown error occurred. Please check your internet and try again.");
        return null;
      }
    }

    Map<String, dynamic> responseAsJson = jsonDecode(response.body);
    if (responseAsJson['success'] == true) {
      navigateToPageRemoveHistory(context, DashboardPage());
      SuccessAlertBox(
          context: context,
          title: "Success",
          messageText: responseAsJson['message']);
    } else {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText: responseAsJson['message']);
      return null;
    }
  }

}
