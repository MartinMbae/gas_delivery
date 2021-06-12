import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gas_delivery/pages/homepage.dart';
import 'package:gas_delivery/ui/widgets/clipshape.dart';
import 'package:gas_delivery/ui/widgets/customappbar.dart';
import 'package:gas_delivery/ui/widgets/responsive_ui.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:gas_delivery/utils/validator.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  late ArsProgressDialog _progressDialog;

  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50),
            child: Column(
              children: <Widget>[
                ClipShape(),
                form(),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: firstNameController,
                keyboardType: TextInputType.text,
                cursorColor: primaryColorLight,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.person, color: primaryColorLight, size: 20),
                  hintText: "First Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  value = value!.trim();
                  return Validator().validateName(value);
                },
              ),
            ),
            SizedBox(height: _height / 60.0),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: lastNameController,
                keyboardType: TextInputType.text,
                cursorColor: primaryColorLight,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.person, color: primaryColorLight, size: 20),
                  hintText: "Last Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  value = value!.trim();
                  return Validator().validateName(value);
                },
              ),
            ),
            SizedBox(height: _height / 60.0),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: primaryColorLight,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.email, color: primaryColorLight, size: 20),
                  hintText: "Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  value = value!.trim();
                  return Validator().validateEmail(value);
                },
              ),
            ),
            SizedBox(height: _height / 60.0),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                cursorColor: primaryColorLight,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.phone, color: primaryColorLight, size: 20),
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  value = value!.trim();
                  return Validator().validateMobile(value);
                },
              ),
            ),
            SizedBox(height: _height / 60.0),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                cursorColor: primaryColorLight,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.lock, color: primaryColorLight, size: 20),
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  value = value!.trim();
                  return Validator().validatePasswordLength(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: primaryColorLight,
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  checkBoxValue = newValue ?? false;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          if (!checkBoxValue) {
            Fluttertoast.showToast(
                msg: "You must first accept our terms and conditions",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            registerUser(
                firstNameController.text,
                lastNameController.text,
                emailController.text,
                phoneController.text,
                passwordController.text);
          }
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: primaryColor,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(SIGN_IN);
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: primaryColorLight,
                  fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  Future<void> registerUser(
    String firstName,
    String lastName,
    String email,
    String phone,
    String password,
  ) async {
    _progressDialog.show();
    String url = BASE_URL + 'api/register';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone': phone,
        'password': password,
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
      List<String> checks = [
        'firstname',
        'lastname',
        'email',
        'phone',
        'password'
      ];
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

      navigateToPageRemoveHistory(context, HomePage());
    } else {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText: responseAsJson['message']);
      return null;
    }
  }
}
