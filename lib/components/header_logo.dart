import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

Widget headerWidget(BuildContext context) {
  return Column(
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Image.asset(
          'images/leo_icon_header.png',
          filterQuality: FilterQuality.medium
        )
      ),
    ],
  );
}