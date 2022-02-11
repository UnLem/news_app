import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_app/main.dart';
import 'models.dart';

class Api {
  String url =
      "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=a939d56df3434f44bb874db695f2fb7b";

  Future<List<Article>> getArticle() async {
    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      maxLength = articles.length;
      return articles;
    } else {
      throw ('Connection problem');
    }
  }

  changeNews() {
    newsCount = 10;
    if (newsType != 'Tesla News') {
      newsType = 'Tesla News';
      logo = 'images/all.png';
      url =
          "https://newsapi.org/v2/everything?q=tesla&from=2022-01-11&sortBy=publishedAt&apiKey=a939d56df3434f44bb874db695f2fb7b";
    } else {
      newsType = 'All News';
      logo = 'images/tesla.png';
      url =
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=a939d56df3434f44bb874db695f2fb7b";
    }
  }
}
