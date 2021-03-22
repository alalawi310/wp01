import 'package:http/http.dart' as http;
import 'dart:convert';


var siteUrl = 'https://studio-press.pro/index.php/wp-json/wp/v2/posts?_embed';

Future<List> fetchWpPosts() async {
  final response =
      await http.get(siteUrl, headers: {"Accept": "application/json"});
  var convertData = jsonDecode(response.body);
  return convertData;

}


Future<List> fetchCategory(id) async {
  var catUrl = 'https://studio-press.pro/index.php/wp-json/wp/v2/categories/$id';

  final response =
  await http.get(catUrl, headers: {"Accept": "application/json"});
  var convertData = jsonDecode(response.body);
  return convertData;
}

Future<List> fetchCategoryPosts(id) async {
  var catUrl = 'https://studio-press.pro/index.php/wp-json/wp/v2/posts?categories=$id';

  final response =
  await http.get(catUrl, headers: {"Accept": "application/json"});
  var convertData = jsonDecode(response.body);
  return convertData;
}



