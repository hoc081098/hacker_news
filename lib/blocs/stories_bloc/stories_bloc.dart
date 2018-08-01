import 'dart:async';

import 'package:hacker_news/data/models/item.dart';
import 'package:hacker_news/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc {
  final Repository _repo;

  final _storiesSubject = new BehaviorSubject<List<Future<Item>>>();

  Stream<List<Future<Item>>> get stories => _storiesSubject.stream;

  StoriesBloc(this._repo);

  Future<Null> fetchStories() async {
    var list = await _repo.getTopStories();
    _storiesSubject.add(list);
  }

  void dispose() {
    _storiesSubject.close();
  }
}
