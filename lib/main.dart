import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/fullArticle.dart';
import 'api.dart';
import 'models.dart';

int maxLength;
int newsCount = 10;

String newsType = 'All News';
String logo = 'images/tesla.png';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Api api = Api();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          if (newsCount + 10 <= maxLength) {
            newsCount += 10;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsType, style: const TextStyle(fontSize: 20)),
        actions: [
          FloatingActionButton(
              elevation: 0,
              onPressed: () {
                setState(() {
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut);

                  api.changeNews();
                });
              },
              child: Image.asset(
                logo,
                fit: BoxFit.cover,
              )),
          IconButton(onPressed: () {
            SystemNavigator.pop();
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: FutureBuilder(
          future: api.getArticle(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              List<Article> articles = snapshot.data;
              return ListView.builder(
                itemCount: newsCount,
                controller: _scrollController,
                itemBuilder: (context, index) => _newsCont(articles[index]),
              );
            } else {
              return const Center(
                  child: Text(
                'Loading...',
                style: TextStyle(fontSize: 30),
              ));
            }
          }),
    );
  }

  Widget _newsCont(Article article) {
    String imageUrl;
    if (article.urlToImage != null) {
      imageUrl = article.urlToImage;
    } else {
      imageUrl =
          'https://www.dominiqueanselny.com/wp-content/themes/da-ny/img/menu/news.png';
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => FullArticle(article)));
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.75,
            color: Colors.amber,
            child: Text(article.title,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.justify),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.22,
            child: Image.network(imageUrl, fit: BoxFit.fitHeight, errorBuilder:
                (BuildContext context, Object exception,
                    StackTrace stackTrace) {
              return Image.asset('images/news.png', fit: BoxFit.fitHeight);
            }),
          )
        ],
      ),
    );
  }
}
