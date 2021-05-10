import 'package:flutter/material.dart';
import 'package:gas_delivery/pages/dashboard.dart';
import 'package:gas_delivery/ui/signin.dart';
import 'package:gas_delivery/utils/custom_methods.dart';
import 'package:gas_delivery/utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkLoggedIn() async{
    var userId = await getUserId();
    if(userId == null){
      navigateToPageRemoveHistory(context, SignInPage());
      // navigateToPageRemoveHistory(context, DashboardPage());

      return;
    }else{
      navigateToPageRemoveHistory(context, DashboardPage());
      return;
    }
  }


  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
