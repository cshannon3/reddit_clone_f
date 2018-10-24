import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'dart:async';
import 'package:reddit_clone_f/reddit_plugin/reddit.dart';
import 'package:reddit_clone_f/blocs/PostsBlocState.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/nolookie.dart' as NL;

class PostsBloc {
  PostsBlocState _currentPostsBlocState;
  StreamSubscription<List<Post>> _fetchPostsSubscription;

  Reddit reddit;
  final RedditController redditController;

  bool redditInitialized = false;

  final StreamController<PostsBlocState> _postsController =
      StreamController.broadcast();

  Stream<PostsBlocState> get postsStream => _postsController.stream;

  PostsBloc({this.redditController}) {
    _currentPostsBlocState = PostsBlocState.empty();
  }

  PostsBlocState getCurrentState() {
    return _currentPostsBlocState;
  }

  /* initializeRedditApi() async {
    reddit = Reddit(new Client());
    reddit.authSetup(NL.identifier, NL.secret);
    //await reddit.authFinish(username: NL.username, password: NL.pw);
    /*await reddit
        .authUrl("http://localhost:8080", scopes: ["identity" "mysubreddits"]);
    print("H");*/
    redditInitialized = true;
  }

  fetchUserInfo() async {
    var t = await reddit.subscribedSubreddits().fetch();
    List g = t['data']['children'];
    g.forEach((_h) {
      print(_h);
    });
  }*/

  frontPage() async {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _postsController.add(_currentPostsBlocState);

    _currentPostsBlocState.posts = await redditController.getFrontPage();
    _currentPostsBlocState.loading = false;
    _postsController.add(_currentPostsBlocState);
  }

  Subreddit(String subreddit) async {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _postsController.add(_currentPostsBlocState);

    _currentPostsBlocState.posts =
        await redditController.getSubredditPosts(subreddit);
    _currentPostsBlocState.loading = false;
    _postsController.add(_currentPostsBlocState);
  }

  initFirst(String code) async {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _postsController.add(_currentPostsBlocState);
    /* reddit = Reddit(new Client());
    reddit.authSetup(NL.identifier, NL.secret);
    await reddit.authUrl("http://localhost:8080", scopes: ["*"], state: "TEST");
    await reddit.authFinish(code: code);
    redditInitialized = true;
    */
    _currentPostsBlocState.posts =
        await redditController.getSubredditPosts("AskReddit");

    /*

    _currentData = await reddit.frontPage.top("day").limit(20).fetch();
    List d = _currentData['data']['children'];
    var list = d.map((_post) {
      return Post.fromJson(_post['data']);
    }).toList();
    if (list is List<Post>) {
      _currentPostsBlocState.posts = list;
    }
    */
    _currentPostsBlocState.loading = false;
    _postsController.add(_currentPostsBlocState);
  }

  /*fetchSubredditPosts(String subreddit) async {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _postsController.add(_currentPostsBlocState);

    if (!redditInitialized) {
      await initializeRedditApi();
    }
    //  _currentData = await reddit.frontPage.hot().fetch();
    _currentData = await reddit.sub("AskReddit").hot().limit(20).fetch();
    List d = _currentData['data']['children'];
    var list = d.map((_post) {
      return Post.fromJson(_post['data']);
    }).toList();
    if (list is List<Post>) {
      _currentPostsBlocState.posts = list;
    }
    _currentPostsBlocState.loading = false;
    _postsController.add(_currentPostsBlocState);
  }
*/
  fetchmore() async {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _postsController.add(_currentPostsBlocState);

    var _newPosts = await redditController.fetchmore();
    if (_newPosts is List<Post>) {
      print("HI");
      _currentPostsBlocState.posts.addAll(_newPosts);
    }
/*
    if (_currentData != null) {
      _currentData.fetchMore().then((_newData) {
        List d = _newData['data']['children'];
        var list = d.map((_post) {
          return Post.fromJson(_post['data']);
        }).toList();
        if (list is List<Post>) {
          _currentPostsBlocState.posts.addAll(list);
        }
      });
    }*/
    _currentPostsBlocState.loading = false;
    _postsController.add(_currentPostsBlocState);
  }
}
