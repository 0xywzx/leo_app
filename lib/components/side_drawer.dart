import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/pages/home.dart';
import 'package:leo_app/pages/test.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerState();
  }
}

class Category {
  int id;
  String categoryName;

  Category(this.id, this.categoryName);

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }
}

class _SideDrawerState extends State<SideDrawer> {
  List<Category> categories;

  Future getCategories() async {
    // あとで消す
    UserToken().prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse("http://localhost:3000/api/v1/categories");
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': "Token 5393cb620f0d652b0cc16753c094d095baec",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      if (list is List) {
        setState(() {
          categories = list.map((post) => Category.fromJson(post)).toList();
        });
      }
    } else {
      // ToDo: エラーハンドリング
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: categories == null ? 0 : categories.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(categories[index].categoryName),
            onTap: () {
              // TestPage.of(context).updateResults("ssss");
              // TestPageState().updateResults("sss");
              Home.of(context).delete();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}