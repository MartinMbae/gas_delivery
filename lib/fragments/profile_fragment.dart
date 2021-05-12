import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  Future<void> getUserDetails() async{
    String? n =  await getName();
    String? e =  await getEmail();
    String? p =  await getPhoneNumber();
    setState((){
      nameController.text = "$n";
      emailController.text = "$e";
      phoneController.text = "$p";

    });
  }


  late ArsProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {

    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );

    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 20),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 30),
                  children: [

                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Your name",
                      ),
                      validator: (value){
                        value = value!.trim();
                        if(value.isEmpty){
                          return "Please fill this value";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Your Email Address",
                      ),
                      validator: (value){
                        value = value!.trim();
                        if(value.isEmpty){
                          return "Please fill this value";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Your Phone Number",
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      validator: (value){
                        value = value!.trim();
                        if(value.isEmpty){
                          return "Please fill this value";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            updateProfile(nameController.text, emailController.text, phoneController.text);
                          }
                        },icon: Icon(Icons.send), label: Text("Update Profile".toUpperCase())
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile(
      String name,
      String email,
      String phone,
      ) async {
    _progressDialog.show();
    var user_id = await getUserId();
    String url = BASE_URL + 'api/update_user/$user_id';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'email': email,
        'name': name,
        'phone': phone,
      }).timeout(Duration(seconds: 20));
    } catch(e) {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText: e.toString());
      return null;
    }
    _progressDialog.dismiss();

    if (response == null) {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText:
          "Page took so long to load. Check your internet access and try again.");
      return null;
    }else if(response.statusCode == 500){
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText:
          "Server Error. Try again later");
    }
    else if (response.statusCode != 200) {
      Map<String, dynamic> responseError = jsonDecode(response.body);
      List<String> checks = ['email', 'phone', 'name'];
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
      var name = responseAsJson['user']['name'];
      var id = responseAsJson['user']['id'];
      var email = responseAsJson['user']['email'];
      var phone = responseAsJson['user']['phone'];
      await setName(name);
      await setEmail(email);
      await setUserId("$id");
      await setPhoneNumber(phone);
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
