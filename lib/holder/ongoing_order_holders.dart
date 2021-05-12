
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class OngoingOrderHolder extends StatefulWidget {
  final OngoingOrder ongoingOrder;

  const OngoingOrderHolder(
      {Key? key, required this.ongoingOrder})
      : super(key: key);

  @override
  _OngoingOrderHolderState createState() => _OngoingOrderHolderState();
}

class _OngoingOrderHolderState extends State<OngoingOrderHolder> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/gas_refill.jpg", width: 80, height: 80,),
                SizedBox(width: 2,),
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                            tag: 'description${widget.ongoingOrder.id}',
                            child: Text("${widget.ongoingOrder.weight} KG ${widget.ongoingOrder.classification}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.9))),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            if(widget.ongoingOrder.initialPrice != null)
                            Text("Ksh ${widget.ongoingOrder.initialPrice}", style: Theme.of(context).textTheme.caption!.apply(decoration: TextDecoration.lineThrough, fontSizeFactor: 0.9, color: Colors.redAccent)),
                            if(widget.ongoingOrder.initialPrice != null)
                              SizedBox(width: 4,),
                            Text("Ksh ${widget.ongoingOrder.price}", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green, fontSizeFactor: 0.9)),

                          ],
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset("assets/logo.jpg", width: 20, height: 20,),
                      Text(widget.ongoingOrder.company_name, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 1,),
                    ],
                  ),
                ),
              ],
            ),

            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Address : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.address}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "House Number : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.house_number}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Apartment Number / Estate : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.apartment_estate}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Landmark : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.landmark}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Order Placed at : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.created_at_parsed}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Order Status: ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.ongoingOrder.status}".toUpperCase(), style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: Colors.green)),
                ],
              ),
            ),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}


