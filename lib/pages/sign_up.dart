import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:leo_app/components/header_logo.dart';

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
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(_inputTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true, 
        iconTheme: IconThemeData(
          color: Colors.grey[600], //change your color here
        ),
        title: Text(
          '新規登録',
          style: TextStyle(
            color: Colors.grey[600]
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              headerWidget(context),
              Text(
                '$_errorMessage',
                style: TextStyle(
                  color: Colors.redAccent
                ),
              ),
              _buildInputTitle("ユーザー名"),
              const SizedBox(height: 6),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'ユーザー名',
                  isDense: true, 
                ),
                controller: _userNameEditingController,
              ),
              _buildInputTitle("メールアドレス"),
              const SizedBox(height: 6),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.mail_outline),
                  hintText: 'メールアドレス',
                  isDense: true, 
                ),
                controller: _mailEditingController,
              ),
              _buildInputTitle("パスワード"),
              const SizedBox(height: 6),
              TextField(
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: "パスワード",
                  isDense: true, 
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
              const SizedBox(height: 6),
              TextField(
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 30.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: "もう一度パスワードを入力ください",
                  isDense: true, 
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
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  child: Text(
                    "新規登録",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  color: AppColor.hexColor("#1E65DC"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  splashColor: Colors.blueGrey,
                  onPressed: (){
                    _signupButton(
                      _mailEditingController.text,
                      _passwordEditingController.text
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}