import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_delivery/holder/gasses_holders.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/empty_screen.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:http/http.dart' as http;

class NewPurchasePage extends StatefulWidget {

  final String title;
  final String url;

  const NewPurchasePage({Key? key, required this.title, required this.url}) : super(key: key);


  @override
  _NewPurchasePageState createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {

  Future<List<dynamic>> fetchNewPurchases() async {
    var url = "$BASE_URL${widget.url}";
    var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw new Exception('Error fetching available new Purchases');
    }
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> incidents = map['gasses'];
    return incidents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder(
          future: fetchNewPurchases(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> incidents = (snapshot.data as List);
              bool hasData = incidents.length > 0;
              return ListView.builder(
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    return hasData
                        ? GasItemHolder(
                          gasItem: GasItem.fromJson(incidents[index]),
                        )
                        : EmptyPage(
                        icon: Icons.error, message: "No items found");
                  });
            } else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
