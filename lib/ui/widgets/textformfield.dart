import 'package:flutter/material.dart';
import 'package:gas_delivery/ui/widgets/responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width =0;
  double _pixelRatio = 0;
  bool large = false;
  bool medium = false;


  CustomTextField(

    {required this.hint,
      required this.textEditingController,
      required this.keyboardType,
      required this.icon,
      this.obscureText= false,
     });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange[200], size: 20),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
