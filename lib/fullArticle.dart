import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models.dart';

class FullArticle extends StatelessWidget {
  Article article;

  FullArticle(this.article, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (article.urlToImage != null) {
      imageUrl = article.urlToImage;
    } else {
      imageUrl =
          'https://www.dominiqueanselny.com/wp-content/themes/da-ny/img/menu/news.png';
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Back to news')),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
            child: Image.network(imageUrl, fit: BoxFit.fitHeight, errorBuilder:
                (BuildContext context, Object exception,
                    StackTrace stackTrace) {
              return Image.asset('images/news.png', fit: BoxFit.fitHeight);
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (article.source.name != null)
                Text('Source: ' + article.source.name,
                    textAlign: TextAlign.left),
              if (article.author != null)
                Text('Author: ' + article.author, textAlign: TextAlign.right),
              if (article.publishedAt != null)
                Text('Publishing time: ' + article.publishedAt,
                    textAlign: TextAlign.left)
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.all(5),
            child: _mainText(article.title),
          ),
          if (article.description != null)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.all(5),
              child: _mainText(article.description),
            ),
          if (article.content != null)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.all(5),
              child: _mainText(article.content),
            ),
          if (article.url != null)
            TextButton(
              onPressed: () {
                _launchURL(article.url);
              },
              child:
                  const Text('Link to source', style: TextStyle(fontSize: 18)),
            )
        ],
      ),
    );
  }

  _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Widget _mainText(String _s) {
    return Container(
        margin: const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 3),
        child: Text(_s, style: const TextStyle(fontSize: 18)));
  }
}
