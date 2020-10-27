import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:leo_app/components/header_logo.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  bool _showPassword = false;
  String _errorMessage ='';
  static DotEnv _env = DotEnv();
  final TextEditingController _mailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  Future _signinWidget(String _emai, String _passward) async {
    final http.Response response = await http.post(
      _env.env['MYSQL_URL'] + '/api/v1/signin',
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
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = "メールアドレスかパスワードが正しくありません";
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
        centerTitle: true, 
        iconTheme: IconThemeData(
          color: Colors.grey[600], //change your color here
        ),
        title: Text(
          'ログイン',
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
                validator: (value) => value.isEmpty ? 'メールアドレスを入力してください' : null,
                controller: _mailEditingController,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.75,
                child: RaisedButton(
                  child: Text(
                    "ログイン",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  color: AppColor.hexColor("#1E65DC"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  splashColor: Colors.blueGrey,
                  onPressed: (){
                    _signinWidget(
                      _mailEditingController.text,
                      _passwordEditingController.text
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: Text(
                  "新規登録",
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    '/sign_up',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}