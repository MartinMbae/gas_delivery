import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:gas_delivery/holder/address_holders.dart';
import 'package:gas_delivery/models/address.dart';
import 'package:gas_delivery/pages/new_address_page.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

import 'empty_screen.dart';

class AddressPage extends StatefulWidget {

  final FlutterCart flutterCart;
  const AddressPage({Key? key, required this.flutterCart}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage>{

  Future<Map<String, dynamic>> fetchMyAddresses() async {
    var userId = await getUserId();
    var url = "${BASE_URL}api/get_addresses/$userId";
    var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30), onTimeout: (){
      throw new Exception('Action took so long');
    });
    if (response.statusCode != 200) {
      throw new Exception('Error fetching your addresses');
    }
    Map<String, dynamic> map = json.decode(response.body);
    return map;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Delivery Address"),),
      body: Container(
        height: size.height,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Select an address".toUpperCase(), style: Theme.of(context).textTheme.bodyText2!.apply(decoration: TextDecoration.underline),),
                SizedBox(height: 10,),
                OutlinedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Add New Address"),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>NewAddress()))
                        .then((value){
                          setState(() {

                          });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(size.width, 40),
                    side: BorderSide(width: 2.0, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: fetchMyAddresses(),
                  builder: (context, snapshot){
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(child: Container(child: CircularProgressIndicator()));
                    }
                    if (snapshot.hasData) {
                      Map<String, dynamic> mapp = (snapshot.data as Map<String, dynamic>);
                      var success = mapp['success'];
                      if (!success){
                       return EmptyPage(icon: Icons.error, message: "No address found",height: 200.0,);
                      }

                      List<dynamic> incidents = mapp['addresses'];
                      bool hasData = incidents.length > 0;
                      if(!hasData){
                        return EmptyPage(icon: Icons.error, message: "No address found", height: 300.0,);
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: incidents.length,
                          itemBuilder: (context, index) {
                          if(hasData){
                            return AddressItemHolder(
                              userAddress: UserAddress.fromJson(incidents[index]),
                              flutterCart: widget.flutterCart,
                            );
                          }else{
                            return EmptyPage(icon: Icons.error, message: "No address found", height: 300,);

                          }
                          });
                    } else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }else {
                      return Center(child: Container(child: CircularProgressIndicator()));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
