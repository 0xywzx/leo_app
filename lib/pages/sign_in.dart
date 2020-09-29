import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  bool _showPassword = false;
  final TextEditingController _mailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 85),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("メールアドレス"),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'メールアドレス',
              ),
              controller: _mailEditingController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("パスワード"),
            ),
            TextField(
              obscureText: !_showPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                hintText: "パスワード",
                suffixIcon: IconButton(
                  icon: Icon(_showPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                  onPressed: () {
                    this.setState((){
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              controller: _passwordEditingController,
            ),
            const SizedBox(height: 16),
            RaisedButton(
              child: Text(
                "ログイン",
                style: TextStyle(color: Colors.white),
              ),
              color: AppColor.hexColor("#1E65DC"),
              onPressed: (){
                _signinWidget(
                  _mailEditingController.text,
                  _passwordEditingController.text
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<http.Response> _signinWidget(String _emai, String _passward) async {
  final http.Response response = await http.post(
    'https://leodb.sakigake.tech/api/v1/signin',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': _emai,
      'password': _passward
    }),
  );
  if (response.statusCode == 200) {
    UserToken().setUserToken(json.decode(response.body));
  } else {
    throw Exception('Failed to post sign in data');
  }
}