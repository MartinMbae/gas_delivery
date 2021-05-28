
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class GasItemHolder extends StatefulWidget {
  final GasItem gasItem;

  const GasItemHolder(
      {Key? key, required this.gasItem})
      : super(key: key);

  @override
  _GasItemHolderState createState() => _GasItemHolderState();
}

class _GasItemHolderState extends State<GasItemHolder> {
 late ArsProgressDialog progressDialog;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                Hero(
                  tag: 'imageTnag${widget.gasItem.id}',
                    child: Image.asset("assets/gas_refill.jpg", width: 80, height: 80,)
                ),
                SizedBox(width: 2,),
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
                        Row(
                          children: [
                            if(widget.gasItem.initialPrice != null)
                            Text("Ksh ${widget.gasItem.initialPrice}", style: Theme.of(context).textTheme.caption!.apply(decoration: TextDecoration.lineThrough, fontSizeFactor: 0.9, color: Colors.redAccent)),
                            if(widget.gasItem.initialPrice != null)
                              SizedBox(width: 4,),
                            Text("Ksh ${widget.gasItem.price}", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green, fontSizeFactor: 0.9)),

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
                      Hero(
                          tag: 'imageTag${widget.gasItem.id}',
                          child: Image.asset("assets/logo.jpeg", width: 20, height: 20,)
                      ),
                      Hero(
                          tag: 'comapanyName${widget.gasItem.id}',
                          child: Text(widget.gasItem.company_name, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 1,)),
                    ],
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
                      child: Text("Request Order".toUpperCase(), style: Theme.of(context).textTheme.subtitle1!.apply(color: primaryColorLight, fontSizeFactor: 0.7),),
                    ),
                  ],
                ),
              ),
              onTap: (){
                navigateToPage(context, CheckOutPage(gasItem: widget.gasItem,));
              },
            )

          ],
        ),
      ),
    );
  }
}


