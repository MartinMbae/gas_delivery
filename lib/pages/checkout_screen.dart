import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/address_page.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';


class CheckOutPage extends StatefulWidget {

  final GasItem gasItem;

  const CheckOutPage({Key? key, required this.gasItem}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Card(
          margin: EdgeInsets.all(8),
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
                          Hero(
                              tag: 'imageTag${widget.gasItem.id}',
                              child: Image.asset("assets/logo.jpeg", width: 60, height: 60,)),
                          Hero(
                              tag: 'comapanyName${widget.gasItem.id}',
                              child: Text(widget.gasItem.company_name, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis, maxLines: 1,)),
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
                    Text("Number of items"),
                    CustomNumberPicker(
                      initialValue: 1,
                      maxValue: 10,
                      minValue: 1,
                      step: 1,
                      onValue: (value) {
                        setState(() {
                          count = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                RichText(text: TextSpan(children: [
                  TextSpan(text: "Total Price: "),
                  TextSpan(text: "Ksh ${int.parse(widget.gasItem.price) * count }", style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.green)),
                ],
                    style: TextStyle(color: Colors.black)
                )),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(onPressed: (){
                      navigateToPage(context, AddressPage(
                        gasItem: widget.gasItem,
                        count: count,
                      ));
                    }, icon: Icon(Icons.check), label: Text("Order Now")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
