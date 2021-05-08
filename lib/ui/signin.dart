import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:gas_delivery/pages/dashboard.dart';
import 'package:gas_delivery/ui/widgets/custom_shape.dart';
import 'package:gas_delivery/ui/widgets/responsive_ui.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';
import 'package:gas_delivery/utils/validator.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  late ArsProgressDialog _progressDialog;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    _progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: Color(0x33000000),
    );

    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: _height / 12),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[200] ?? Colors.orange,
                    Colors.pinkAccent
                  ],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange[200] ?? Colors.orange,
                    Colors.pinkAccent
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.orange[200],
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.email, color: Colors.orange[200], size: 20),
                  hintText: "Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  Validator().validateEmail(value!);
                },
              ),
            ),
            SizedBox(height: _height / 40.0),
            Material(
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                cursorColor: Colors.orange[200],
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.lock, color: Colors.orange[200], size: 20),
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Provide password';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        if (_key.currentState!.validate()) {
          loginUser(emailController.text, passwordController.text);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.orange[200] ?? Colors.orange,
              Colors.pinkAccent
            ],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SIGN_UP);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> loginUser(
    String email,
    String password,
  ) async {
    _progressDialog.show();
    String url = BASE_URL + 'api/login';
    dynamic response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'email': email,
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
      List<String> checks = ['email', 'password'];
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

      navigateToPageRemoveHistory(context, DashboardPage());
    } else {
      DangerAlertBox(
          context: context,
          title: "Error",
          messageText: responseAsJson['message']);
      return null;
    }
  }
}
