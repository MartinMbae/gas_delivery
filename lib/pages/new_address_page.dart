import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class NewAddress extends StatefulWidget {
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {



  TextEditingController addressController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  late ArsProgressDialog _progressDialog;


  @override
  Widget build(BuildContext context) {


    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new address"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: addressController,
                  decoration: new InputDecoration(
                    labelText: "Address",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val!.length == 0) {
                      return "Address cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                controller: houseController,
                  decoration: new InputDecoration(
                    labelText: "House Number",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val!.length == 0) {
                      return "House Number cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
    controller: apartmentController,
                  decoration: new InputDecoration(
                    labelText: "Apartment/Estate",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val!.length == 0) {
                      return "Apartment/Estate cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
    controller: landmarkController,
                  decoration: new InputDecoration(
                    labelText: "Landmark",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val!.length == 0) {
                      return "Landmark cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 12,),
                OutlinedButton.icon(onPressed: () async{
                  if(_key.currentState!.validate()){
                    var user_id = await getUserId();
                    addNewAddress(addressController.text, houseController.text, apartmentController.text, landmarkController.text, user_id!);
                  }
                }, icon: Icon(Icons.send), label: Text("Submit")),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> addNewAddress(
      String address,
      String house_number,
      String apartment_estate,
      String landmark,
      String user_id,
      ) async {
    _progressDialog.show();
    String url = BASE_URL + 'api/add_address';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'user_id': user_id,
        'address': address,
        'house_number': house_number,
        'apartment_estate': apartment_estate,
        'landmark': landmark,
      }).timeout(Duration(seconds: 20));
    } on Exception {
      response = null;
    }
    _progressDialog.dismiss();

    if (response == null) {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText:
          "Page took so long to load. Check your internet access and try again.");
      return null;
    } else if (response.statusCode != 200) {
      Map<String, dynamic> responseError = jsonDecode(response.body);
      List<String> checks = ['address', 'house_number','apartment_estate','landmark'];
      String errorMessage = "";
      for (String check in checks) {
        if (responseError.containsKey(check)) {
          errorMessage = "$errorMessage, ${responseError[check][0]}";
        }
      }
      if (errorMessage.isNotEmpty) {
        if (errorMessage.trim().startsWith(",")) {
          errorMessage = errorMessage.replaceFirst(",", "");
        }
        errorMessage = errorMessage.trim();
        DangerAlertBox(
            context: context, title: "Error", messageText: errorMessage);
        return null;
      } else {
        DangerAlertBox(
            context: context,
            title: "Error",
            messageText:
            "An unknown error occurred. Please check your internet and try again.");
        return null;
      }
    }

    Map<String, dynamic> responseAsJson = jsonDecode(response.body);
    if (responseAsJson['success'] == true) {
      Navigator.pop(context);
      SuccessAlertBox(
          context: context,
          title: "Success",
          messageText: responseAsJson['message']);
    } else {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText: responseAsJson['message']);
      return null;
    }
  }
}
