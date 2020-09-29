import 'package:flutter/material.dart';
import 'package:leo_app/pages/sign_up.dart';
import 'package:leo_app/pages/sign_in.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SignIn(),
        '/sign_up': (context) => SignUp(),
        '/sign_in': (context) => SignIn(),
      },
    );
  }
}


class HomePage extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, 
          ),
          backgroundColor: Color(0xffFAFAFA),
          elevation: 0.0,
          title: Text(''),
        ),
      ),
    );
  }
}

