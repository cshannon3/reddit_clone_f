import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/blocs/PostsBloc.dart';
import 'package:reddit_clone_f/login.dart';
import 'package:reddit_clone_f/postsScreen.dart';
import 'package:reddit_clone_f/providers/posts_bloc_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //PostsBloc bloc;
  RedditController redditcontroller;
  bool isInitialized = false;

  @override
  void initState() {
    redditcontroller = new RedditController();
    redditcontroller.addListener(() {
      if (redditcontroller.redditInitialized != isInitialized) {
        setState(() {
          isInitialized = redditcontroller.redditInitialized;
        });
      }
    });
    // bloc = PostsBloc(redditController: redditcontroller);
  }

  @override
  Widget build(BuildContext context) {
    if (!redditcontroller.redditInitialized) {
      return LoginWebView(redditController: redditcontroller);
    }
    return PostsScreen(
      redditController: redditcontroller,
    );
  }
}
