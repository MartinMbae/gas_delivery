import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:gas_delivery/models/GasItem.dart';
import 'package:gas_delivery/pages/checkout_screen.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class GasItemHolder extends StatefulWidget {
  final GasItem gasItem;

  final void Function(int) notifyParent;

  final FlutterCart flutterCart;

  const GasItemHolder(
      {Key? key,
      required this.gasItem,
      required this.flutterCart,
      required this.notifyParent})
      : super(key: key);

  @override
  _GasItemHolderState createState() => _GasItemHolderState();
}

class _GasItemHolderState extends State<GasItemHolder> {
  late ArsProgressDialog progressDialog;

  var message;
  var gasIsInCat = -1;

  /// sample function
  addToCart(GasItem gasItem) {
    widget.flutterCart.addToCart(
        productId: (gasItem.id),
        unitPrice: int.parse(gasItem.price),
        quantity: 1,
        productDetailsObject: gasItem);

    widget.notifyParent(widget.flutterCart.getCartItemCount());

    int newId = widget.flutterCart.findItemIndexFromCart(widget.gasItem.id);
    setState(() {
      gasIsInCat = newId;
    });
  }

  removeItemFromCart(int index) {
        widget.flutterCart.decrementItemFromCart(index);
        widget.notifyParent(widget.flutterCart.getCartItemCount());
        int newId = widget.flutterCart.findItemIndexFromCart(widget.gasItem.id);
        setState(() {
          gasIsInCat = newId;
        });
  }

  addItemToCart(int index) {
    widget.flutterCart.incrementItemToCart(index);
    widget.notifyParent(widget.flutterCart.getCartItemCount());
    int newId = widget.flutterCart.findItemIndexFromCart(widget.gasItem.id);
    setState(() {
      gasIsInCat = newId;
    });
  }

  @override
  Widget build(BuildContext context) {
    gasIsInCat = widget.flutterCart.findItemIndexFromCart(widget.gasItem.id);
    print("hhhh $gasIsInCat");

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
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    imageUrl: widget.gasItem.url,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/gas_refill.jpg",
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                            tag: 'description${widget.gasItem.id}',
                            child: Text(
                                "${widget.gasItem.weight} KG ${widget.gasItem.classification}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(fontSizeFactor: 0.9))),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            if (widget.gasItem.initialPrice != null)
                              Text("Ksh ${widget.gasItem.initialPrice}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSizeFactor: 0.9,
                                          color: Colors.redAccent)),
                            if (widget.gasItem.initialPrice != null)
                              SizedBox(
                                width: 4,
                              ),
                            Text("Ksh ${widget.gasItem.price}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(
                                        color: Colors.green,
                                        fontSizeFactor: 0.9)),
                          ],
                        ),
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
                Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Hero(
                          tag: 'imageTag${widget.gasItem.id}',
                          child: Image.asset(
                            "assets/logo.jpeg",
                            width: 20,
                            height: 20,
                          )),
                      Hero(
                          tag: 'comapanyName${widget.gasItem.id}',
                          child: Text(
                            widget.gasItem.company_name,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 3,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if(gasIsInCat == null){
                            addToCart(widget.gasItem);
                          }else{
                            removeItemFromCart(gasIsInCat);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            gasIsInCat == null
                                ? "Add to Cart".toUpperCase()
                                : "Remove from Cart".toUpperCase(),
                            style: Theme.of(context).textTheme.subtitle1!.apply(
                                color: gasIsInCat == null ? primaryColorLight : Colors.red , fontSizeFactor: 0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
