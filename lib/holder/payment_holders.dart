
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/models/payment.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class PaymentsHolder extends StatefulWidget {
  final Payment payment;

  const PaymentsHolder(
      {Key? key, required this.payment})
      : super(key: key);

  @override
  _PaymentsHolderState createState() => _PaymentsHolderState();
}

class _PaymentsHolderState extends State<PaymentsHolder> {
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
                        Text("${widget.payment.callback_phone}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.9)),
                        SizedBox(height: 8,),
                        Text("Ksh. ${widget.payment.callback_amount}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.9)),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Mpesa Code : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.payment.mpesa_receipt_number}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "Transaction Date : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
                  TextSpan(text: "${widget.payment.created_at_parsed}", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8, color: primaryColor)),
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


