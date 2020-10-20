import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leo_app/components/side_drawer.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key, this.title }) : super(key: key);
  static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();


  final String title;
  @override
  createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with WidgetsBindingObserver {
  List<String> _results = <String>[];
  String url;

  static const channel = const MethodChannel('app.channel.shared');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _results.add("testing");
    setState(() {
      url = "sample";
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getChannel();
    }
  }

  void getChannel() async {
    var message = await channel.invokeMethod("getSharedText");
    debugPrint(message);
    // var pageData = PageData.fromMap(message);
    // debugPrint(pageData.url);
    setState(() {
      url = message;
    });
  }

  void updateResults(String text) {
    setState(() {
      _results = [..._results, text];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      drawer: SideDrawer(),
      body: Column(
        children: [
          Text(url),
          Container(
            child: TextField(
              onSubmitted: (String text) {
                updateResults(text);
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _results.map((v) => Text(v)).toList(),
          )),
        ]
      ),
    );
  }
}

class PageData {

  PageData._({
    this.url,
    this.title
  });

  String url = '';
  String title = '';

  static PageData fromMap(dynamic message) {
    final Map<dynamic, dynamic> map = message;
    return PageData._(
      url: map['url'],
      title: map['title']
    );
  }
}