import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacker_news/data/models/item.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<Item>> items;
  static final dateFormat = DateFormat.yMd().add_Hms();
  static final colorsByDepth = <int, int>{
    0: 900,
    1: 800,
    2: 700,
    3: 600,
    4: 500,
    5: 400,
    6: 300,
    7: 200,
    8: 100,
    9: 50,
  }.map((k, v) => new MapEntry(k, Colors.teal[v]));
  int depth;

  Comment({
    Key key,
    @required this.itemId,
    @required this.items,
    this.depth: 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Item>(
      future: items[itemId],
      builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
        return !snapshot.hasData
            ? _buildPlaceholder(context)
            : _buildItem(context, snapshot.data);
      },
    );
  }

  Widget _buildItem(BuildContext context, Item item) {
    var iterable = item.kids.map((id) {
      return new Comment(
        itemId: id,
        items: items,
        depth: depth + 1,
      );
    });

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          new Container(
            child: new ListTile(
              title: new Text(
                item.text ?? '...',
              ),
              subtitle: new Text(
                'by ${item.by} \u{2022} ${dateFormat.format(item.time)}',
                style: new TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            margin: new EdgeInsets.only(left: depth > 10 ? depth * 4.0 : depth * 8.0)
            decoration: new BoxDecoration(
              border: new Border(
                left: new BorderSide(
                  color: colorsByDepth[depth] ?? Colors.teal[50],
                  width: 2.0,
                ),
              ),
            ),
          ),
        ]..addAll(iterable),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return new ListTile(
      title: Text('Loading comment $itemId...'),
    );
  }
}
