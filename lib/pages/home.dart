import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/side_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/pages/splash.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:leo_app/model/article.dart';
import 'package:leo_app/model/category.dart';

class Home extends StatefulWidget {
  static _HomeState of(BuildContext context) => context.findAncestorStateOfType<_HomeState>();

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  static DotEnv _env = DotEnv();
  List<Article> articles;
  List<Category> categories;
  String homeTitle = "";
  String titleIcon = "";

  @override
  void initState() {
    super.initState();
    getArticles("0", "1", "My List");
  }

  Future getArticles(String isRead, String categoryId, String _homeTitle) async {
    // 開発のためここでprfを定義。あとで消す
    UserToken().prefs = await SharedPreferences.getInstance();

    // indexeを渡せばもっとうまくかけるかも。
    if (isRead == "未読記事" || isRead == "既読記事") {
      if (isRead == "未読記事") {
        isRead = "0";
      } else {
        isRead = "1";
      }
    }

    // タイトルをカテゴリーの名前に変更
    homeTitle = _homeTitle;
    if (isRead == "0") {
      titleIcon = "book";
    } else {
      titleIcon = "bookmark";
    }

    // 記事情報の取得
    var uri = Uri.parse(_env.env['MYSQL_URL'] + "/api/v1/categorised_articles");
    uri = uri.replace(queryParameters: <String, String>{'is_read': isRead, 'category_id': categoryId});
    final http.Response response = await http.get(
      uri, headers: <String, String>{
        'Authorization': "Token 5393cb620f0d652b0cc16753c094d095baec",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final list = json.decode(response.body);
      if (list is List) {
        setState(() {
          articles = list.map((post) => Article.fromJson(post)).toList();
        });
      }
    } else {
      // 記事を取得できなかった場合は何か表示する
    }
  }
  
  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not Launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.book),
        title: Row(
          children: <Widget>[
            Icon(Icons.book),
            SizedBox(width: 8),
            Text(homeTitle),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[       
          Expanded(
            child: ListView(
              children: articles?.map((item) => Container(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: 
                              Text(
                                item.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              item.articleNote,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        height: 60,
                        width: 120,
                        // child: Text(item.ogImageUrl),
                        child: item.ogImageUrl == "/images/leo_icon_header.svg" ? 
                          Image.asset('images/leo_icon_header.png')
                          : Image.network(
                          item.ogImageUrl,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _launchURL(item.articleUrl);
                  },
                ),
              ))?.toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }
}