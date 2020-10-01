import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leo_app/components/app_color.dart';
import 'package:leo_app/store/user_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
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
  List articleList;
  List<Article> articles;

  Future getArticle(String isRead) async {
    UserToken().prefs = await SharedPreferences.getInstance();
    // final _userToken = UserToken().session();
    debugPrint(UserToken().session ?? '');
    var uri = Uri.parse("http://localhost:3000/api/v1/all_unread_or_read_articles");
    uri = uri.replace(queryParameters: <String, String>{'is_read': isRead});
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

  @override
  void initState() {
    super.initState();
    getArticle("0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: articles == null ? 0 : articles.length, 
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          articles[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        articles[index].articleNote,
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Image.network(
                    articles[index].ogImageUrl,
                  ),
                ),
              ],
            ),
          );
        }
      ), 
    );
  }
}