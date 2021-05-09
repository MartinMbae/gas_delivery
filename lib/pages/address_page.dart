import 'package:flutter/material.dart';
import 'package:gas_delivery/pages/new_address_page.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/custom_methods.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Delivery Address"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Select an address".toUpperCase(), style: Theme.of(context).textTheme.bodyText2!.apply(decoration: TextDecoration.underline),),
            SizedBox(height: 10,),
            OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add New Address"),
              onPressed: (){
                navigateToPage(context, NewAddress());
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(size.width, 40),
                side: BorderSide(width: 2.0, color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
