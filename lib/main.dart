import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_delivery/fragments/dashboard.dart';
import 'package:gas_delivery/pages/splash.dart';
import 'package:gas_delivery/ui/signin.dart';
import 'package:gas_delivery/ui/signup.dart';
import 'package:gas_delivery/utils/colors.dart';
import 'package:gas_delivery/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    HttpOverrides.global = new MyHttpOverrides();
    runApp(MyApp());
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        final isValidHost =
            [BASE_URL].contains(host); // <-- allow only hosts in array
        return isValidHost;
      });
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return  MaterialApp(
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       primaryColor: primaryColor,
       primaryColorDark: primaryColorDark,
       primaryColorLight: primaryColorLight,
       accentColor: accentColor,
       textTheme: GoogleFonts.montserratTextTheme(
         Theme.of(context).textTheme,
       ),
     ),
     routes: <String, WidgetBuilder>{
       SIGN_IN: (BuildContext context) => SignInPage(),
       SIGN_UP: (BuildContext context) => SignUpScreen(),
       SPLASHSCREEN: (BuildContext context) => SplashScreen(),
     },
     initialRoute: SPLASHSCREEN,
   );
  }
}
