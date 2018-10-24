import 'package:flutter/material.dart';
import 'package:reddit_clone_f/blocs/PostsBloc.dart';


class PostsBlocProvider extends InheritedWidget {
  final PostsBloc bloc;
  final Widget child;

  PostsBlocProvider({this.bloc, this.child}) : super(child: child);

  static PostsBlocProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(PostsBlocProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
