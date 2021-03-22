import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wp01/CategoryModel.dart';
import 'package:wp01/post.dart';
import 'package:wp01/wp-api.dart';
import 'package:http/http.dart' as http;

import 'article.dart';

class CategoryPosts extends StatefulWidget {
  final id;

  const CategoryPosts({Key key, this.id}) : super(key: key);
  @override
  _CategoryPostsState createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts> {
  var newstitle = '';
  List<dynamic> categoryArticles = [];
  Future<List<dynamic>> _futureCategoryArticles;
  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;


  @override
  void initState() {
    super.initState();
    _futureCategoryArticles = fetchCategoryArticles(1);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  Category category = Category();

  Future<List<dynamic>> fetchCategoryArticles(int page) async {
    try {
      var response = await http.get(
          "https://studio-press.pro/wp-json/wp/v2/posts?categories[]=" +
              widget.id.toString() +
              "&page=$page&per_page=10&_fields=id,date,title,content,custom,link");

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            categoryArticles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
            if (categoryArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });

          return categoryArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return categoryArticles;
  }

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureCategoryArticles = fetchCategoryArticles(page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var id = ['id'];
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('أخبار كل قسم'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          child: Container(
            child: categoryPosts(_futureCategoryArticles),
          )
        ),
      ),
    );
  }



  Widget categoryPosts(Future<List<dynamic>> categoryArticles) {
    return FutureBuilder<List<dynamic>>(
      future: categoryArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data.length == 0) return Container();
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data.map((item) {
                    final heroId = item.id.toString() + "-categorypost";
                    return InkWell(
                      // onTap: () {
                      //   SystemChrome.setSystemUIOverlayStyle(
                      //     SystemUiOverlayStyle(
                      //       statusBarColor: kBackColor,
                      //     ),
                      //   );
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => SingleArticle(item, heroId),
                      //     ),
                      //   );
                      // },
                      child: Text(category.id.toString()),
                    );
                  }).toList()),
              !_infiniteStop
                  ? Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: CircularProgressIndicator(),
              )
                  : Container()
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${articleSnapshot.error}"));
        }
        return Container(
          alignment: Alignment.center,
          height: 400,
          child: CircularProgressIndicator(),
        );
      },
    );
  }


}