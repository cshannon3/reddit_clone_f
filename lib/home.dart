import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone_f/blocs/PostsBloc.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/providers/posts_bloc_provider.dart';
import 'package:reddit_clone_f/reddit_plugin/reddit.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final bloc = PostsBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PostsBlocProvider(
          bloc: bloc, child: MyHomePage(title: 'Flutter Demo Home Page')),
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
  bool _firstLoad = true;
  String authCode;
  List<Post> posts = [];
  List<String> subReddits = [
    "Popular",
    "All",
    "AskReddit",
    "ADHD",
    "bestof",
    "books",
    "Politics",
    "Soccer",
    "2irl4mirl"
  ];
  final String authurl =
      "https://www.reddit.com/api/v1/authorize?client_id=dVQroB7sWdX7NA&response_type=code&state=TEST&redirect_uri=" +
          "http://localhost:8080" +
          //  "https://www.reddit.com" +
          "&scope=*";

  // Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = new TextEditingController(text: "");

  final _codeCtrl =
      new TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {});

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print(url);
          if (url.contains("?code=") || url.contains("&code=")) {
            Uri uri = Uri.parse(url);
            authCode = uri.queryParameters["code"];
            print(authCode);
            flutterWebviewPlugin.close();
          }
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onScrollYChanged =
        flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  Y Direction: $y");
        });
      }
    });

    _onScrollXChanged =
        flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  X Direction: $x");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          print(state.url);
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PostsBloc bloc = PostsBlocProvider.of(context).bloc;

    if (_firstLoad && authCode != null) {
      bloc.initFirst(authCode);
      print("oh");
      //  bloc.fetchSubredditPosts("AskReddit");
      // bloc.initializeRedditApi();
      _firstLoad = false;
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: Icon(Icons.menu),
        title: Column(
          children: <Widget>[
            Text("AskReddit"),
            Text("Hot"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_hdr),
            onPressed: () {
              flutterWebviewPlugin.launch(authurl);
              //setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                if (!_firstLoad && authCode != null) {
                  // bloc.fetchUserInfo();
                }
                //else bloc.fetchmore();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              //setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder(
          initialData: bloc.getCurrentState(),
          stream: bloc.postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  /* child: Text(AppLocalizations.of(context).get('something_wrong'/),*/
                  );
            }
            if (snapshot.data.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            posts = snapshot.data.posts;
            return Column(
              children: <Widget>[
                Container(
                  height: 40.0,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(subReddits.length, (index) {
                        return Container(
                          height: 40.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(subReddits[index]),
                          ),
                        );
                      })),
                ),
                Expanded(
                  child: new ListView(
                    children: List.generate(posts.length, (_postindex) {
                      Post newPost = posts[_postindex];
                      Duration timesincepost =
                          DateTime.now().toUtc().difference(newPost.postedTime);
                      return Container(
                        height: 130.0,
                        color: Colors.blue,
                        child: Column(children: [
                          Text(
                            newPost.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              newPost.stickied
                                  ? Container(
                                      height: 20.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(2.0)),
                                      child: Center(
                                        child: Text(
                                          "STICKY",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                  : Container(),
                              newPost.gilded > 0
                                  ? Icon(
                                      Icons.monetization_on,
                                    )
                                  : Container(),
                              newPost.over18
                                  ? Container(
                                      height: 20.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(2.0)),
                                      child: Center(
                                        child: Text(
                                          "NSFW",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                newPost.subreddit,
                                style: TextStyle(color: Colors.red),
                              ),
                              Icon(Icons.alarm),
                              Text(timesincepost.inMinutes > 60
                                  ? timesincepost.inHours.toString() + "h"
                                  : timesincepost.inMinutes.toString() + "m"),
                              Icon(Icons.person),
                              Text(newPost.author),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.menu),
                              Icon(Icons.chat_bubble),
                              Text(newPost.numcomments.toString()),
                              Icon(Icons.arrow_upward),
                              Text(newPost.score < 1000
                                  ? newPost.score.toString()
                                  : newPost.score < 10000
                                      ? (newPost.score / 1000)
                                              .toStringAsPrecision(2) +
                                          "k"
                                      : (newPost.score / 1000)
                                              .floor()
                                              .toString() +
                                          "k"),
                              Icon(Icons.arrow_downward),
                              Icon(Icons.more_vert),
                            ],
                          )
                        ]),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
