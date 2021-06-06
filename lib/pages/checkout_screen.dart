import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/address_page.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class CheckOutPage extends StatefulWidget {
  final FlutterCart flutterCart;

  const CheckOutPage({Key? key, required this.flutterCart}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  removeItemFromCart(int index) {
    widget.flutterCart.decrementItemFromCart(index);
  }

  addItemToCart(int index) {
    widget.flutterCart.incrementItemToCart(index);
  }

  @override
  Widget build(BuildContext context) {
    var totalPrice = 0;
    for (int i = 0; i < widget.flutterCart.getCartItemCount(); i++) {
      var to = widget.flutterCart.cartItem[i].unitPrice *
          widget.flutterCart.cartItem[i].quantity;
      totalPrice += to as int;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              ListView.builder(
                itemCount: widget.flutterCart.getCartItemCount(),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  GasItem gasItem =  widget.flutterCart.cartItem[index].productDetails;
                  return Card(
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
                                        tag: 'imageTag${gasItem.id}',
                                        child: Image.asset(
                                          "assets/logo.jpeg",
                                          width: 60,
                                          height: 60,
                                        )),
                                    Hero(
                                        tag: 'comapanyName${gasItem.id}',
                                        child: Text(
                                          gasItem.company_name,
                                          style:
                                              Theme.of(context).textTheme.caption,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                          tag: 'description${gasItem.id}',
                                          child: Text(
                                              "${gasItem.weight} KG ${gasItem.classification}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .apply(fontSizeFactor: 0.9))),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: "Price per Unit : "),
                            if (gasItem.initialPrice != null)
                              TextSpan(
                                  text: "Ksh ${gasItem.initialPrice}  ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.redAccent,
                                          fontSizeFactor: 0.9)),
                            TextSpan(text: "Ksh ${gasItem.price}"),
                          ], style: TextStyle(color: Colors.black))),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text("Number of items"),
                              CustomNumberPicker(
                                initialValue: 1,
                                maxValue: 10,
                                minValue: 1,
                                step: 1,
                                onValue: (value) {
                                  var countItem =
                                      widget.flutterCart.cartItem[index].quantity;
                                  if (countItem == value) {
                                  } else if (countItem > value) {
                                    int specificId = widget.flutterCart
                                        .findItemIndexFromCart(gasItem.id);
                                    removeItemFromCart(specificId);
                                  } else {
                                    int specificId = widget.flutterCart
                                        .findItemIndexFromCart(gasItem.id);
                                    addItemToCart(specificId);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: "Total Price: "),
                            TextSpan(
                                text:
                                    "Ksh ${widget.flutterCart.cartItem[index].unitPrice * widget.flutterCart.cartItem[index].quantity}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(color: Colors.green)),
                          ], style: TextStyle(color: Colors.black))),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Total Price"),
                        SizedBox(
                          height: 8,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(text: "Total Price: "),
                          TextSpan(
                              text: "Ksh $totalPrice",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .apply(color: Colors.green)),
                        ], style: TextStyle(color: Colors.black))),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                                onPressed: () {
                                  navigateToPage(
                                      context,
                                      AddressPage(
                                        flutterCart: widget.flutterCart,
                                      ));
                                },
                                icon: Icon(Icons.check),
                                label: Text("Order Now")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
