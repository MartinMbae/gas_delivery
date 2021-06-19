import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:gas_delivery/models/accessory.dart';
import 'package:gas_delivery/utils/colors.dart';

class AccessoryHolder extends StatefulWidget {
  final Accessory accessory;
  final FlutterCart flutterCart;
  final Function(int) notifyParent;

  const AccessoryHolder(
      {Key? key,
      required this.accessory,
      required this.flutterCart,
      required this.notifyParent})
      : super(key: key);

  @override
  _AccessoryHolderState createState() => _AccessoryHolderState();
}

class _AccessoryHolderState extends State<AccessoryHolder> {
  late ArsProgressDialog progressDialog;

  var accessoryIsInCat = -1;

  /// sample function
  addToCart(Accessory accessory) {
    widget.flutterCart.addToCart(
        productId: (accessory.id),
        unitPrice: int.parse(accessory.price),
        quantity: 1,
        productDetailsObject: accessory);

    int newId = widget.flutterCart.findItemIndexFromCart(widget.accessory.id);
    setState(() {
      accessoryIsInCat = newId;
    });
    widget.notifyParent(widget.flutterCart.getCartItemCount());

  }

  removeItemFromCart(int index) {
    widget.flutterCart.decrementItemFromCart(index);
    widget.notifyParent(widget.flutterCart.getCartItemCount());
    setState(() {
      accessoryIsInCat = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = "imageHero${widget.accessory.id}";

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: 200,
        width: 200,
        child: Column(
          children: [
            Hero(
              tag: heroTag,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SingleImageScreen(
                        tag: heroTag, imageUrl: widget.accessory.url);
                  }));
                },
                child: Image.network(
                  widget.accessory.url,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 100,
                      child: Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  // height: 180,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.accessory.title,
              style:
                  Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),
              maxLines: 1,
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.accessory.initialPrice != null)
                  Text("Ksh ${widget.accessory.initialPrice}",
                      style: Theme.of(context).textTheme.caption!.apply(
                          decoration: TextDecoration.lineThrough,
                          fontSizeFactor: 0.9,
                          color: Colors.redAccent)),
                if (widget.accessory.initialPrice != null)
                  SizedBox(
                    width: 4,
                  ),
                Text("Ksh ${widget.accessory.price}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .apply(color: Colors.green, fontSizeFactor: 0.9)),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (accessoryIsInCat == -1) {
                  addToCart(widget.accessory);
                } else {
                  removeItemFromCart(accessoryIsInCat);
                }
              },
              child: Container(
                width: double.infinity,
                color: accessoryIsInCat == -1 ? primaryColorLight : Colors.red,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(accessoryIsInCat == -1 ? CupertinoIcons.cart_badge_plus : CupertinoIcons.cart_badge_minus, color: Colors.white),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        accessoryIsInCat == -1
                            ? 'Add to Cart'
                            : "Remove from Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    );
  }
}

class SingleImageScreen extends StatelessWidget {
  final imageUrl, tag;

  const SingleImageScreen({Key? key, @required this.imageUrl, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: tag,
            child: Image.network(
              imageUrl,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
