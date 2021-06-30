import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_delivery/holder/gasses_holders.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:http/http.dart' as http;

class NewPurchasePage extends StatefulWidget {

  final String title;
  final String url;


  final void Function(int) notifyParent;

  final FlutterCart flutterCart;

  const NewPurchasePage({Key? key, required this.title, required this.url, required this.flutterCart, required this.notifyParent}) : super(key: key);
  @override
  _NewPurchasePageState createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {

  Future<Map<String, dynamic>> fetchNewPurchases() async {
    var url = "$BASE_URL${widget.url}";
    var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30), onTimeout: (){
      throw new Exception("Please check your internet and try again");
    });
    if (response.statusCode != 200) {
      throw new Exception('Error fetching available new Purchases');
    }
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  var cartCount;
  void refresh(int newCartCount) {
    setState(() {
      cartCount = newCartCount;
    });

    widget.notifyParent(newCartCount);
  }


  @override
  Widget build(BuildContext context) {

     cartCount = widget.flutterCart.getCartItemCount();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          GestureDetector(
            onTap: (){
              if(cartCount == 0){
                Fluttertoast.showToast(msg: "You must first add items to cart", toastLength: Toast.LENGTH_LONG);
              }else {
                navigateToPage(
                    context,
                    CheckOutPage(
                      flutterCart: widget.flutterCart,
                    ));
              }
            },
            child: Padding(
              padding:  EdgeInsets.only(right: 20, top: 10),
              child: Badge(
                badgeContent: Text("$cartCount"),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder(
          future: fetchNewPurchases(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> mapp = (snapshot.data as Map<String, dynamic>);
              var success = mapp['success'];
              if (!success){
                return EmptyPage(icon: Icons.error, message: "No items found",height: 200.0,);
              }
              List<dynamic> incidents = mapp['gasses'];
              bool hasData = incidents.length > 0;
              if (!hasData){
                return EmptyPage(icon: Icons.error, message: "No items found",height: 200.0,);
              }
              return ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    return hasData
                        ? GasItemHolder(
                      gasItem: GasItem.fromJson(incidents[index]),
                      flutterCart: widget.flutterCart,
                        notifyParent: refresh
                    )
                        : EmptyPage(
                        icon: Icons.error, message: "No items found");
                  });

            } else if(snapshot.hasError){
              return EmptyPage(icon: Icons.error, message: "Something went wrong. Please check your internet and try again",height: 200.0,);
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
