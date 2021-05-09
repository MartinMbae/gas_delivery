import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gas_delivery/utils/colors.dart';


class SimpleRow extends StatelessWidget {

  final title, subtitle, subtitleColor;

  const SimpleRow({Key? key, @required this.title, @required this.subtitle, this.subtitleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: "$title : ", style: Theme.of(context).textTheme.subtitle1!.apply(fontSizeFactor: 0.8)),
            TextSpan(text: "$subtitle", style: TextStyle(color: subtitleColor == null ? primaryColor : subtitleColor)),
          ],
        ),
      ),
    );
  }
}


