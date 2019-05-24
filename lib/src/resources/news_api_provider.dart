import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';
import '../models/item_model.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();
    Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json');
    final ids = json.decode(response.body);
    return ids.cast<int>(); // casting ids as integers as at this point dart doesn't know what tpye ids is
  }
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/v0/item/$id.json');
    final parsedJson = json.decode(response.body);

    return ItemModel.fromJson(parsedJson);
  }
}