import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  bool _showPassword = false;
  String _errorMessage ='';
  final TextEditingController _userNameEditingController = TextEditingController();
  final TextEditingController _mailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationEditingController = TextEditingController();

  Future _signupButton(String _email, String _passward) async {
    Map userData = {
      'user' : {
        'name': _userNameEditingController.text,
        'email': _mailEditingController.text,
        'password': _passwordEditingController.text,
        'password_confirmation': _passwordConfirmationEditingController.text
      },
    };
    final http.Response response = await http.post(
      'http://localhost:3000/api/v1/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      UserToken().setUserToken(json.decode(response.body));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = "入力内容をもう一度ご確認ください";
      });
    }
  }

  Widget _buildInputTitle(String _inputTitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(_inputTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('新規登録'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 85),
            Text(
              '$_errorMessage',
              style: TextStyle(
                color: Colors.redAccent
              ),
            ),
            _buildInputTitle("ユーザー名"),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: 'ユーザー名',
              ),
              controller: _userNameEditingController,
            ),
            _buildInputTitle("メールアドレス"),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'メールアドレス',
              ),
              controller: _mailEditingController,
            ),
            const SizedBox(height: 16),
            _buildInputTitle("パスワード"),
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
            _buildInputTitle("パスワード確認"),
            TextField(
              obscureText: !_showPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                hintText: "もう一度パスワードを入力ください",
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
              controller: _passwordConfirmationEditingController,
            ),
            const SizedBox(height: 16),
            RaisedButton(
              child: Text(
                "新規登録",
                style: TextStyle(color: Colors.white),
              ),
              color: AppColor.hexColor("#1E65DC"),
              onPressed: (){
                _signupButton(
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