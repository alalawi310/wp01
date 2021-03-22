import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wp01/home.dart';

class CatPostScreen extends StatefulWidget {
  final String title, desc, imgUrl,content;

  const CatPostScreen({Key key, this.title, this.desc,this.imgUrl,this.content}) : super(key: key);
  @override
  _CatPostScreenState createState() => _CatPostScreenState();
}

class _CatPostScreenState extends State<CatPostScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(widget.desc)
                // SizedBox(height: 20,),
                // // Image.network(widget.imgUrl),
                // SizedBox(height: 20,),
                // HtmlWidget(widget.content.trim()),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
