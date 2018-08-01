import 'dart:async';

import 'package:hacker_news/data/models/item.dart';
import 'package:hacker_news/data/news_api_service.dart';

class Repository {
  final _apiService = new NewsApiService();

  Future<List<Future<Item>>> getTopStories() async {
    final topStoriesIds = await _apiService.getTopStoriesIds();
    final tasks =
        topStoriesIds.map(_apiService.getItem).toList(growable: false);
    return tasks;
  }

  Future<Item> getItemById(int id) {
    return _apiService.getItem(id);
  }
}
