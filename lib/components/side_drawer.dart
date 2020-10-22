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
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class _SideDrawerState extends State<SideDrawer> with SingleTickerProviderStateMixin {
  List<Category> categories;
  static DotEnv _env = DotEnv();

  Future getCategories() async {
    // あとで消す
    UserToken().prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(_env.env['MYSQL_URL'] + "/api/v1/categories");
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
    _tabController = TabController(length: tabs.length, vsync: this);
    getCategories();
  }

  TabController _tabController;

  final List<Tab> tabs = <Tab>[
    Tab(
      text:'既読記事', 
      icon: Icon(Icons.book),
    ),
    Tab(
      text:'未読記事',
      icon: Icon(Icons.bookmark)
    ),
  ];
  
  Widget _createTabView(Tab tab){
    debugPrint(tab.text);
    return ListView(
      children: categories?.map((item) => ListTile(
        title: Text(item.categoryName),
        onTap: () {
          Home.of(context).getArticles("0", item.id.toString());
          Navigator.pop(context);
        },
      ))?.toList() ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            TabBar(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: tabs,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabs.map((tab) {
                  return _createTabView(tab);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}