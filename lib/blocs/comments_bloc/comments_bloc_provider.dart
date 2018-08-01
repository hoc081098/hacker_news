import 'package:flutter/material.dart';
import 'package:hacker_news/blocs/comments_bloc/comments_bloc.dart';

class CommentsBlocProvider extends StatefulWidget {
  final CommentsBloc bloc;
  final Widget child;

  const CommentsBlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  @override
  _CommentsBlocProviderState createState() => new _CommentsBlocProviderState();

  static CommentsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_CommentsBlocProvider)
              as _CommentsBlocProvider)
          .bloc;
}

class _CommentsBlocProviderState extends State<CommentsBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return new _CommentsBlocProvider(
      bloc: widget.bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _CommentsBlocProvider extends InheritedWidget {
  final CommentsBloc bloc;

  _CommentsBlocProvider({
    @required this.bloc,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
