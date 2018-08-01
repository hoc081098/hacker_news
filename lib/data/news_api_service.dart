import 'dart:async';
import 'dart:convert';

import 'package:hacker_news/data/models/item.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const _baseUrl = 'hacker-news.firebaseio.com';
  final _client = new http.Client();

  Future<List<int>> getTopStoriesIds() async {
    final url = Uri.https(
      _baseUrl,
      '/v0/topstories.json',
      {'print': 'pretty'},
    );
    final body = await _client.read(url);
    final decoded = json.decode(body);
    return (decoded as Iterable).take(100).cast<int>().toList(growable: false);
  }

  Future<Item> getItem(int id) async {
    final url = Uri.https(
      _baseUrl,
      '/v0/item/$id.json',
      {'print': 'pretty'},
    );
    final body = await _client.read(url);
    final decoded = json.decode(body);
    return new Item.fromJson(decoded);
  }
}
