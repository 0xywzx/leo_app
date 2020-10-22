import 'package:flutter/material.dart';
import 'dart:async';
import 'package:leo_app/pages/splash.dart';
import 'package:leo_app/pages/home.dart';
import 'package:leo_app/pages/sign_up.dart';
import 'package:leo_app/pages/sign_in.dart';
import 'package:leo_app/pages/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

Future main() async {
  // SharedPreferences.setMockInitialValues({});
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

   @override
  // _MyAppState createState() => _MyAppState();

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

// class _MyAppState extends State<MyApp> {
//   StreamSubscription _intentDataStreamSubscription;
//   List<SharedMediaFile> _sharedFiles;
//   String _sharedText;

//   @override
//   void initState() {
//     super.initState();
//      //アプリが起動されている状態で呼ばれた時、ここからURLが入ってくる
//     _intentDataStreamSubscription =
//         ReceiveSharingIntent.getTextStream().listen((String value) {
//       setState(() {
//         _sharedText = value;
//       });
//     }, onError: (err) {
//       print("getLinkStream error: $err");
//     });

//     // アプリが起動されていない状態で呼ばれた時、ここからURLが入ってくる
//     ReceiveSharingIntent.getInitialText().then((String value) {
//       setState(() {
//         _sharedText = value;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _intentDataStreamSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Text("Shared urls/text:", style: textStyleBold),
//               Text(_sharedText ?? "")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

