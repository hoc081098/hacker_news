import 'package:flutter/material.dart';
import 'package:hacker_news/blocs/stories_bloc/stories_bloc.dart';

class StoriesBlocProvider extends StatefulWidget {
  final StoriesBloc bloc;
  final Widget child;

  const StoriesBlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  }) : super(key: key);

  @override
  _StoriesBlocProviderState createState() => new _StoriesBlocProviderState();

  static StoriesBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_StoriesBlocProvider)
              as _StoriesBlocProvider)
          .bloc;
}

class _StoriesBlocProviderState extends State<StoriesBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return new _StoriesBlocProvider(
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

class _StoriesBlocProvider extends InheritedWidget {
  final StoriesBloc bloc;

  _StoriesBlocProvider({
    @required this.bloc,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
