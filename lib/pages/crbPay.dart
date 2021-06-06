import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/homepage.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:gas_delivery/utils/validator.dart';
import 'package:http/http.dart' as http;

class PayPage extends StatefulWidget {

  final FlutterCart flutterCart;
  final order_id;

  const PayPage({Key? key, required this.flutterCart, required this.order_id})
      : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late ArsProgressDialog _progressDialog;

  TextEditingController phoneController = new TextEditingController();

  String? phone = '';

  Future<void> fetchPhoneNumber() async {
    var string = await getPhoneNumber();
    phoneController.text = "$string";
  }

  @override
  void initState() {
    super.initState();
    fetchPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay'),
        centerTitle: true,
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
                    Text('You have successfully placed your order. Please proceed to make your payment now.', textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, color: Colors.black87),),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.flutterCart.getCartItemCount(),
                      itemBuilder: (context,index){
                        GasItem gasItem = widget.flutterCart.cartItem[index].productDetails;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image.asset("assets/logo.jpeg", width: 60, height: 60,),
                                      Text(gasItem.company_name, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                                            tag: 'description${gasItem.id}',
                                            child: Text("${gasItem.weight} KG ${gasItem.classification}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.9))),
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

                              if(gasItem.initialPrice != null)
                                TextSpan(text: "Ksh ${gasItem.initialPrice}  ", style: Theme.of(context).textTheme.caption!.apply(decoration: TextDecoration.lineThrough, color: Colors.redAccent, fontSizeFactor: 0.9)),
                              TextSpan(text: "Ksh ${gasItem.price}"),
                            ],
                                style: TextStyle(color: Colors.black)
                            )),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Text("Number of items  "),
                                Text("${widget.flutterCart.cartItem[index].quantity}", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green)),
                              ],
                            ),
                            SizedBox(height: 8,),
                            RichText(text: TextSpan(children: [
                              TextSpan(text: "Total Price: "),
                              TextSpan(text: "Ksh ${int.parse(gasItem.price) * widget.flutterCart.cartItem[index].quantity }", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green)),
                            ],
                                style: TextStyle(color: Colors.black)
                            )),
                            SizedBox(height: 20,),
                          ],
                        );
                      },
                      separatorBuilder: (context, index){
                        return  Divider();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Pay Now",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .apply(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.orange[200],
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                            color: Colors.orange[200], size: 20),
                        hintText: "Mpesa Phone Number to initiate Payment",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),),
                      ),
                      validator: (value) {
                        value = value!.trim();
                        return Validator().validateMobile(value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                            onPressed: () async {
                              navigateToPageRemoveHistory(context, HomePage());
                            },
                            icon: Icon(Icons.cancel, color: Colors.red,),
                            label: Text("I'll pay later")),
                        OutlinedButton.icon(
                            onPressed: () async {
                              var user_id = await getUserId();
                              var phone = phoneController.text;
                              startPay(
                                  widget.order_id,
                                  user_id!,
                                  phone);
                            },
                            icon: Icon(Icons.attach_money_outlined, color: Colors.green,),
                            label: Text("Pay Now")),
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

  Future<void> startPay(
    int order_id,
    String user_id,
    String phone,
  ) async {
    if (phone.trim().isEmpty) {
      Fluttertoast.showToast(
          msg: "You must first provide a valid phone number.",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    _progressDialog.show();
    String url = BASE_URL + 'api/pay';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'user_id': "$user_id",
        'order_id': "$order_id",
        'phone': "$phone",
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
      List<String> checks = [
        'user_id',
        'total_price',
        'count',
        'phone',
        'gas_id'
      ];
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
      navigateToPageRemoveHistory(context, HomePage());
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
