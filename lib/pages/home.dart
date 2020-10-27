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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getArticles("0", "1", "My List");
  }

  Future getAllArticles(String isRead) async {
        // 記事情報の取得
    var uri = Uri.parse(_env.env['MYSQL_URL'] + "/api/v1/all_unread_or_read_articles");
    uri = uri.replace(queryParameters: <String, String>{'is_read': isRead});
    final http.Response response = await http.get(
      uri, headers: <String, String>{
        'Authorization': "Token " + UserToken().session ?? '',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      if (list is List) {
        setState(() {
          articles = list.map((post) => Article.fromJson(post)).toList();
          loading = false;
        });
      }
    } else {
      // 記事を取得できなかった場合は何か表示する
    }
  }

  Future getArticles(String isRead, String categoryId, String _homeTitle) async {
    // 開発のためここでprfを定義。あとで消す
    // UserToken().prefs = await SharedPreferences.getInstance();
    // indexを渡せばもっとうまくかけるかも。
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
        'Authorization': "Token " + UserToken().session ?? '',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      if (list is List) {
        setState(() {
          articles = list.map((post) => Article.fromJson(post)).toList();
          loading = false;
        });
      }
    } else {
      // 記事を取得できなかった場合は何か表示する
    }
  }
  
  // タップしたら記事にとぶ
  _launchURL(String _url, int _articleId) async {
    if (await canLaunch(_url)) {
      await launch(_url);
      var uri = Uri.parse(_env.env['MYSQL_URL'] + "/api/v1/articles/" + _articleId.toString() + "/update_is_read");
      // uri = uri.replace(queryParameters: <String, String>{'is_read': '1'});
      final http.Response response = await http.put(
        uri, 
        headers: <String, String>{
          'Authorization': "Token 12ec991db7a9d24ad9c0d97bda27b87a1458",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'is_read': '1',
        }),
      );
    } else {
      throw 'Could not Launch $_url';
    }
  }

  // 同じ日に保存したかの確認
  _sameDate(int _index) {
    debugPrint(articles[_index].createdAt);
    return articles[_index-1].createdAt.substring(0, 10) != articles[_index].createdAt.substring(0, 10);
  }

  // 保存した日時の表示
  Widget _buildSavedDateWidget(String _date) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 6),
      child: Text(
        _date.substring(0, 10),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.right
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.grey[600], //change your color here
        ),
        title: Row(
          children: <Widget>[
            Icon(Icons.book),
            SizedBox(width: 8),
            Text(
              homeTitle,
              style: TextStyle(
                color: Colors.grey[600]
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: SideDrawer(),
      body: loading ? Text("Loading ... ")
      : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0 ? _buildSavedDateWidget(articles[index].createdAt) : 
                  _sameDate(index) ? _buildSavedDateWidget(articles[index].createdAt) : Container(),
                Container(),
                GestureDetector(
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
                                articles[index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              articles[index].articleNote,
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
                        // child: Text(articles[index].ogImageUrl),
                        child: articles[index].ogImageUrl == "/images/leo_icon_header.svg" ? 
                          Image.asset('images/leo_icon_header.png')
                          : Image.network(
                          articles[index].ogImageUrl,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    _launchURL(articles[index].articleUrl, articles[index].id);
                  },
                ),
                Divider(
                  color: Colors.black
                )
              ],
            ),
          );
        }
      ),
            // ListView(
            //   children: articles.asMap().entries.map((item) => Container(
            //     padding: const EdgeInsets.all(12),
            //     child: Column(
            //       children: <Widget>[
            //         item.key == 0 ? Text(item.value.createdAt) : 
            //           _sameDate(item.key) ? Text(item.value.createdAt) : Container(),
            //         Container(),
            //         GestureDetector(
            //           child: Row(
            //             children: <Widget>[
            //               Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Container(
            //                       padding: const EdgeInsets.only(bottom: 8),
            //                       child: 
            //                       Text(
            //                         item.value.title,
            //                         overflow: TextOverflow.ellipsis,
            //                         maxLines: 2,
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                     ),
            //                     Text(
            //                       item.value.articleNote,
            //                       overflow: TextOverflow.ellipsis,
            //                       maxLines: 3,
            //                       style: TextStyle(
            //                         color: Colors.grey[500],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Container(
            //                 margin: EdgeInsets.only(left: 12),
            //                 height: 60,
            //                 width: 120,
            //                 // child: Text(item.value.ogImageUrl),
            //                 child: item.value.ogImageUrl == "/images/leo_icon_header.svg" ? 
            //                   Image.asset('images/leo_icon_header.png')
            //                   : Image.network(
            //                   item.value.ogImageUrl,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           onTap: () {
            //             _launchURL(item.value.articleUrl);
            //           },
            //         ),
            //       ],
            //     ),
            //   )).toList(),
            // ),
    );
  }
}