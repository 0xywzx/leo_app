import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/pages/splash.dart';
import 'package:leo_app/components/side_drawer.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  static _HomeState of(BuildContext context) => context.findAncestorStateOfType<_HomeState>();

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class Article {
  int id;
  String title;
  String articleUrl;
  String ogImageUrl;
  String articleNote;
  bool isRead;
  int categoryId;
  String createdAt;

  Article(this.id, this.title, this.articleUrl, this.ogImageUrl, this.articleNote, this.isRead, this.categoryId, this.createdAt);

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    articleUrl = json['article_url'];
    ogImageUrl = json['og_image_url'];
    articleNote = json['article_note'];
    isRead = json['is_read'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
  }
}

class _HomeState extends State<Home> {
  static DotEnv _env = DotEnv();
  List<Article> articles;
  List<Category> categories;

  @override
  void initState() {
    super.initState();
    getArticles("0", "1");
  }

  void delete() {
    setState(() {
      articles = [];
    });
  }

  Future getArticles(String isRead, String categoryId) async {
    // 開発のためここでprfを定義。あとで消す
    UserToken().prefs = await SharedPreferences.getInstance();
    // final _userToken = UserToken().session();

    // indexeを渡せばもっとうまくかけるかも。
    if (isRead == "未読記事" || isRead == "既読記事") {
      if (isRead == "未読記事") {
        isRead = "0";
      } else {
        isRead = "1";
      }
    }

    var uri = Uri.parse(_env.env['MYSQL_URL'] + "/api/v1/categorised_articles");
    uri = uri.replace(queryParameters: <String, String>{'is_read': isRead, 'category_id': categoryId});
    final http.Response response = await http.get(
      uri, headers: <String, String>{
        'Authorization': "Token 5393cb620f0d652b0cc16753c094d095baec",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[       
          Expanded(
            child: ListView(
              children: articles?.map((item) => Container(
                padding: const EdgeInsets.all(12),
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
                      child: Text('写真'),
                      // child: Image.network(
                      //   articles[index].ogImageUrl,
                      // ),
                    ),
                  ],
                ),
              ))?.toList() ?? [],
            ),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: articles == null ? 0 : articles.length, 
      //   itemBuilder: (BuildContext context, int index) {
      //     return Container(
      //       padding: const EdgeInsets.all(12),
      //       child: Row(
      //         children: <Widget>[
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   padding: const EdgeInsets.only(bottom: 8),
      //                   child: 
      //                   Text(
      //                     articles[index].title,
      //                     overflow: TextOverflow.ellipsis,
      //                     maxLines: 2,
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                 ),
      //                 Text(
      //                   articles[index].articleNote,
      //                   overflow: TextOverflow.ellipsis,
      //                   maxLines: 3,
      //                   style: TextStyle(
      //                     color: Colors.grey[500],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(left: 12),
      //             height: 60,
      //             width: 120,
      //             child: Text('写真'),
      //             // child: Image.network(
      //             //   articles[index].ogImageUrl,
      //             // ),
      //           ),
      //         ],
      //       ),
      //     );
      //   }
      // ), 
    );
  }
}