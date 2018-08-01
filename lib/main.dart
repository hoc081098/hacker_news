import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacker_news/blocs/comments_bloc/comments_bloc.dart';
import 'package:hacker_news/blocs/comments_bloc/comments_bloc_provider.dart';
import 'package:hacker_news/blocs/stories_bloc/stories_bloc.dart';
import 'package:hacker_news/blocs/stories_bloc/stories_bloc_provider.dart';
import 'package:hacker_news/data/models/item.dart';
import 'package:hacker_news/data/repository.dart';
import 'package:hacker_news/news_detail.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  final repo = new Repository();

  runApp(
    new MyApp(repo: repo),
  );
}

class MyApp extends StatelessWidget {
  final Repository repo;

  const MyApp({Key key, @required this.repo}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoriesBlocProvider(
      bloc: new StoriesBloc(repo),
      child: new CommentsBlocProvider(
        bloc: new CommentsBloc(repo),
        child: new MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
            fontFamily: 'SF-Pro-Display',
            primarySwatch: Colors.blue,
          ),
          home: new MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    StoriesBlocProvider.of(context).fetchStories();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesBlocProvider.of(context);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Top news'),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new StreamBuilder<List<Future<Item>>>(
          stream: bloc.stories,
          builder: (BuildContext context,
              AsyncSnapshot<List<Future<Item>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: new CircularProgressIndicator(),
              );
            }
            final items = snapshot.data;
            return new RefreshIndicator(
              child: new ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return new FutureBuilder<Item>(
                    future: items[index],
                    builder:
                        (BuildContext context, AsyncSnapshot<Item> snapshot) {
                      return !snapshot.hasData
                          ? _buildPlaceholder(context)
                          : _buildItem(context, snapshot.data);
                    },
                  );
                },
              ),
              onRefresh: bloc.fetchStories,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return new Shimmer.fromColors(
      period: Duration(milliseconds: 800),
      child: new ListTile(
        trailing: new Container(
          constraints: new BoxConstraints.expand(width: 24.0, height: 48.0),
          color: Colors.grey[350],
        ),
        title: new Container(
          constraints: new BoxConstraints.expand(
            height: 12.0,
          ),
          color: Colors.grey[350],
        ),
        subtitle: new Container(
          constraints: new BoxConstraints.expand(
            height: 8.0,
          ),
          color: Colors.grey[350],
        ),
      ),
      highlightColor: Colors.grey[200],
      baseColor: Colors.grey[350],
    );
  }

  Widget _buildItem(BuildContext context, Item item) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return new NewsDetail(item: item);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Card(
          elevation: 4.0,
          child: new ListTile(
            title: new Text(
              item.title,
            ),
            subtitle: new Text('${item.score} points'),
            trailing: new Column(
              children: <Widget>[
                new Icon(Icons.comment),
                new Text(item.descendants.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
