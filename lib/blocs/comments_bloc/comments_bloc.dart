import 'dart:async';

import 'package:hacker_news/data/models/item.dart';
import 'package:hacker_news/data/repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final Repository _repo;
  final _idsSubject = new PublishSubject<int>();
  final _commentsSubject = new BehaviorSubject<Map<int, Future<Item>>>();

  Stream<Map<int, Future<Item>>> get itemWithComments =>
      _commentsSubject.stream;

  void Function(int) get fetchItemWithComments => _idsSubject.add;

  CommentsBloc(this._repo) {
    _idsSubject.asyncMap(_convertAsyncMap).pipe(_commentsSubject);
  }

  void dispose() {
    _commentsSubject.close();
    _idsSubject.close();
  }

  Future<Map<int, Future<Item>>> _convertAsyncMap(int id) async {
    var itemFuture = _repo.getItemById(id);
    var item = await itemFuture;
    if (item.kids.isEmpty) {
      return {item.id: itemFuture};
    }
    var map = item.kids.map(_convertAsyncMap);
    var wait = await Future.wait(map);
    return wait
        .reduce((acc, e) => acc..addAll(e))
        ..addAll({item.id: itemFuture});
  }
}
