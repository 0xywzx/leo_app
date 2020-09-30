import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leo_app/main.dart';
import 'package:leo_app/store/user_token.dart';

class Splash extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> {

  @override
  initState() {
    super.initState();
    move();
  }

  move() async {
    // sharedPreferenceのインスタンスを保存しておく
    UserToken().prefs = await SharedPreferences.getInstance();

    Future.wait([
      _delay(),
    ]).whenComplete(() async {
      debugPrint(UserToken().session ?? '');
      if ((UserToken().session ?? '').isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/sign_in');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;
    final double windowHeight = MediaQuery.of(context).size.height;
    // ロゴ 縦横比が約 1:1.75
    final double logoWidth = windowWidth * 0.67;
    final double logoHeight = logoWidth / 1.75;

    return Scaffold(
      body: Container(
        width: windowWidth,
        height: windowHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: (windowWidth - logoWidth) / 2,
              top: windowHeight / 2 - (logoHeight / 1.35), // 1.35は微調整のため
              width: logoWidth,
              child: Image.asset('images/leo_icon.png'),
            ),
          ],
        ),
      ),
    );
  }

  // 最低でもDuration秒は表示する
  Future<void> _delay() {
    return Future.delayed(const Duration(milliseconds: 1000));
  }
}
