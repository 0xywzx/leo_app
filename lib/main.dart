import 'package:flutter/material.dart';
import 'package:leo_app/pages/splash.dart';
import 'package:leo_app/pages/home.dart';
import 'package:leo_app/pages/sign_up.dart';
import 'package:leo_app/pages/sign_in.dart';
import 'package:leo_app/pages/test.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/home': (context) => Home(),
        '/sign_up': (context) => SignUp(),
        '/sign_in': (context) => SignIn(),
      },
    );
  }
}

