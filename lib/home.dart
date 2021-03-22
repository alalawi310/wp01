import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wp01/categoryScreen.dart';
import 'package:wp01/post.dart';
import 'package:wp01/wp-api.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  var newstitle = '';

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('news application'),
        ),
        drawer: Drawer(
          child: CategoryScreen(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: FutureBuilder(
              future: fetchWpPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map posts = snapshot.data[index];
                      var title = posts['title']['rendered'];
                      var desc = posts['excerpt']['rendered'];
                      var content = posts['content']['rendered'];
                      var date = posts['date'];
                      // var categories = posts['custom']['categories']['name'];
                      var imgUrl =
                          posts['_embedded']['wp:featuredmedia'][0]['source_url'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostScreen(
                                title: title,
                                desc: desc,
                                imgUrl: imgUrl,
                                content: content,
                              ),
                            ),
                          );
                        },
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 11),
                                child: Card(
                                  child: ListTile(
                                    title: Text(title),
                                    leading: Image.network(
                                      imgUrl,
                                      fit: BoxFit.fitWidth,
                                      width: 120,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class PostTile extends StatefulWidget {
//   final String href, title, desc, content;
//
//   const PostTile({Key key, this.href, this.title, this.desc, this.content})
//       : super(key: key);
//
//   @override
//   _PostTileState createState() => _PostTileState();
// }
//
// class _PostTileState extends State<PostTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Container(
//         child: Column(
//           children: [
//             FutureBuilder(
//                 future: fetchWpPosts(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemBuilder: (BuildContext context, int index) {
//                         Map postImage = snapshot.data[index];
//                         var imgUrl = postImage['custom']['featured_image'];
//                         return Image.network(imgUrl);
//                       },
//                     );
//                   }
//                   return CircularProgressIndicator();
//                 }),
//             Text(
//               widget.title,
//               style: TextStyle(fontSize: 20.0, color: Colors.red),
//             ),
//             Text(widget.desc),
//           ],
//         ),
//       ),
//     );
//   }
// }
