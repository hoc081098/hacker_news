import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacker_news/blocs/comments_bloc/comments_bloc_provider.dart';
import 'package:hacker_news/comment.dart';
import 'package:hacker_news/data/models/item.dart';

class NewsDetail extends StatefulWidget {
  final Item item;

  const NewsDetail({Key key, @required this.item}) : super(key: key);

  @override
  _NewsDetailState createState() => new _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  Item item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CommentsBlocProvider.of(context).fetchItemWithComments(item.id);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = CommentsBlocProvider.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Detail'),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new StreamBuilder<Map<int, Future<Item>>>(
          stream: bloc.itemWithComments,
          builder: (BuildContext context,
              AsyncSnapshot<Map<int, Future<Item>>> snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }

            return new RefreshIndicator(
              child: buildList(snapshot.data, context),
              onRefresh: () async {
                bloc.fetchItemWithComments(item.id);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildTitle(Item item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text.rich(
        new TextSpan(children: [
          new TextSpan(
            text: item.title,
            style: Theme
                .of(context)
                .textTheme
                .subhead
                .copyWith(fontSize: 24.0, color: Colors.white),
          ),
          new TextSpan(text: '\n'),
          new TextSpan(
            text:
                '${item.score} points \u{2022} by ${item.by} \u{2022} ${Comment
                .dateFormat.format(item.time)}',
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                  color: Colors.white,
                ),
          ),
          new TextSpan(text: '\n'),
          new TextSpan(
            text: item.text ?? '...',
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
          ),
        ]),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildList(Map<int, Future<Item>> items, BuildContext context) {
    var children = <Widget>[
      buildTitle(item, context),
    ];
    Iterable<Widget> comments = item.kids.map((id) {
      return new Card(child: new Comment(itemId: id, items: items));
    });
    children.addAll(comments);

    return new ListView(
      children: children,
    );
  }
}
