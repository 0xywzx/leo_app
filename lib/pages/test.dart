import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leo_app/components/side_drawer.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key, this.title}) : super(key: key);
  static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();


  final String title;
  @override
  createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _results = <String>[];

  @override
  void initState() {
    super.initState();
    _results.add("testing");
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
      body: Column(children: [
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
      ]),
    );
  }
}