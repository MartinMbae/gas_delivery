import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_delivery/holder/simple_row.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/models/address.dart';
import 'package:gas_delivery/pages/confirm_order_page.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class AddressItemHolder extends StatefulWidget {
  final UserAddress userAddress;
  final GasItem gasItem;
  final int count;

  const AddressItemHolder(
      {Key? key,
        required this.userAddress,
        required this.gasItem,
        required this.count,
      })
      : super(key: key);

  @override
  _AddressItemHolderState createState() => _AddressItemHolderState();
}

class _AddressItemHolderState extends State<AddressItemHolder> {
 late ArsProgressDialog progressDialog;


  @override
  Widget build(BuildContext context) {
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 2,),
                Flexible(
                  child: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SimpleRow(title: "Address", subtitle: widget.userAddress.address),
                        SimpleRow(title: "House Number", subtitle: widget.userAddress.house_number),
                        SimpleRow(title: "Apartment Number / Estate", subtitle: widget.userAddress.apartment_estate),
                        SimpleRow(title: "Landmark", subtitle: widget.userAddress.landmark),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Divider(
              height: 3,
            ),
            GestureDetector(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Use This Address".toUpperCase(), style: Theme.of(context).textTheme.subtitle1!.apply(color: primaryColorLight, fontSizeFactor: 0.7),),
                    ),
                  ],
                ),
              ),
              onTap: (){

                navigateToPage(context, ConfirmOrderPage(gasItem: widget.gasItem, count: widget.count, userAddress: widget.userAddress));
              },
            )

          ],
        ),
      ),
    );
  }
}


