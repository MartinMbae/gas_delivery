import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/models/accessory.dart';
import 'package:gas_delivery/models/ongoing_order.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class OngoingOrderHolder extends StatefulWidget {
  final OngoingOrder ongoingOrder;

  const OngoingOrderHolder({Key? key, required this.ongoingOrder})
      : super(key: key);

  @override
  _OngoingOrderHolderState createState() => _OngoingOrderHolderState();
}

class _OngoingOrderHolderState extends State<OngoingOrderHolder> {
  late ArsProgressDialog progressDialog;

  calculateTotal() {
    setState(() {
      totalCostString = totalCost;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      return calculateTotal();
    });
  }

  int totalCost = 0;
  int totalCostString = 0;

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
            Text(
              "Ordered Items".toUpperCase(),
              style: Theme.of(context).textTheme.headline6!.apply(
                  fontSizeFactor: 0.7, decoration: TextDecoration.underline, color: primaryColorDark),
            ),
            SizedBox(height: 10,),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.ongoingOrder.getOrderedAccessories().length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var jsonString =
                    widget.ongoingOrder.getOrderedAccessories()[index];
                Accessory accessory =
                    Accessory.fromJson(jsonString['accessory']);

                int price = int.tryParse(jsonString['total_price']) ?? 0;
                totalCost += price;

                return RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "${jsonString['count']}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(fontSizeFactor: 0.8, color: primaryColor)),
                      TextSpan(
                          text: " ${accessory.title} for ",
                          style: Theme.of(context).textTheme.subtitle1!.apply(
                                fontSizeFactor: 0.8,
                              )),
                      TextSpan(
                          text: "Ksh. ${jsonString['total_price']}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(fontSizeFactor: 0.8, color: primaryColor)),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: widget.ongoingOrder.getOrderedGasItems().length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var jsonString = widget.ongoingOrder.getOrderedGasItems()[index];

                int price = int.tryParse(jsonString['total_price']) ?? 0;
                totalCost += price;

                return RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "${jsonString['count']}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(fontSizeFactor: 0.8, color: primaryColor)),
                      TextSpan(
                          text:
                              " ${jsonString['company_name']} Gas (${jsonString['classification']}) for ",
                          style: Theme.of(context).textTheme.subtitle1!.apply(
                                fontSizeFactor: 0.8,
                              )),
                      TextSpan(
                          text: "Ksh. ${jsonString['total_price']}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .apply(fontSizeFactor: 0.8, color: primaryColor)),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Total Cost : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: " Ksh. $totalCostString",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Text(
              "Delivery Address".toUpperCase(),
              style: Theme.of(context).textTheme.headline6!.apply(
                  fontSizeFactor: 0.7, decoration: TextDecoration.underline, color: primaryColorDark),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Address : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.address}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "House Number : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.house_number}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Apartment Number / Estate : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.apartment_estate}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Landmark : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.landmark}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Order Placed at : ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.created_at_parsed}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: primaryColor)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "Order Status: ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8)),
                  TextSpan(
                      text: "${widget.ongoingOrder.status}".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontSizeFactor: 0.8, color: Colors.green)),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
