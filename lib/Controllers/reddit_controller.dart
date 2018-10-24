import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/reddit_plugin/reddit.dart';
import 'package:reddit_clone_f/nolookie.dart' as NL;

class RedditController extends ChangeNotifier {
  Reddit reddit;

  /* AUTH */
  bool _redditInitialized = false;
  bool get redditInitialized => _redditInitialized;

  initFirst(String code) async {
    reddit = Reddit(new Client());
    reddit.authSetup(NL.identifier, NL.secret);
    await reddit.authUrl("http://localhost:8080", scopes: ["*"], state: "TEST");
    await reddit.authFinish(code: code);
    _redditInitialized = true;
    notifyListeners();
  }

  /* POSTS && SUBREDDITS */

  /* VARIABLES */
  ListingResult _currentPostData;
  List<Post> _posts = [];
  String _currentSubreddit = "frontpage";
  bool _newPosts = false;

  Post activePost;
  List<CommentTree> comments;

  /* GETTERS AND SETTERS */
  List<Post> get posts => _posts;
  String get currentSubreddit => _currentSubreddit;
  bool get newPosts => _newPosts;

  String _postImageSelected;
  String get postImageSelected => _postImageSelected;

  set setCurrentSubreddit(String newSubreddit) {
    _currentSubreddit = newSubreddit;
    getSubredditPosts(_currentSubreddit);
  }

  postsRecieved() {
    _newPosts = false;
  }

  clearpostImage() {
    _postImageSelected = null;
    notifyListeners();
  }

  /* SUBREDDIT POSTS DATA */
  getSubredditPosts(String subreddit,
      {String sortby = "hot", String t_option = "week"}) async {
    _currentSubreddit = subreddit;
    _posts = [];
    if (_redditInitialized) {
      _currentPostData = sortby == "hot"
          ? await reddit.sub(subreddit).hot().limit(20).fetch()
          : sortby == "top"
              ? await reddit.sub(subreddit).top(t_option).limit(20).fetch()
              : await reddit.sub(subreddit).hot().limit(20).fetch();
      List d = _currentPostData['data']['children'];
      var list = d.map((_post) {
        return Post.fromJson(_post['data']);
      }).toList();
      if (list is List<Post>) {
        _posts = list;
        _newPosts = true;
        notifyListeners();
      }
    }
  }

  getFrontPage() async {
    _newPosts = true;
    if (_redditInitialized) {
      _currentPostData = await reddit.frontPage.best().limit(20).fetch();
      List d = _currentPostData['data']['children'];
      var list = d.map((_post) {
        return Post.fromJson(_post['data']);
      }).toList();
      if (list is List<Post>) {
        _posts = list;
        _newPosts = true;
        notifyListeners();
      }
    }
  }

  Future<List<Post>> fetchmore() async {
    if (_currentPostData != null) {
      var _newData = await _currentPostData.fetchMore();
      List d = _newData['data']['children'];
      print(d);
      var list = d.map((_post) {
        return Post.fromJson(_post['data']);
      }).toList();
      if (list is List<Post>) {
        return list;
      }
      return null;
    }
    print("Dammit");
  }

/* COMMENTS */
  comments(String sub, String id) async {
    // var data = await
    List<CommentTree> commentTrees = [];
    var data = await reddit.comments(sub, id);

    List comments = data[1]['data']['children'];
    comments.forEach((_commentTree) {
      commentTrees.add(CommentTree.fromJson(_commentTree['data'], 0));
    });

    commentTrees.forEach((_c) {
      print("${_c.depth} :   ${_c.body}");
      if (_c.replies != null) {
        _c.replies.forEach((_c2) {
          print("${_c2.depth} :   ${_c2.body}");
        });
      }
      //print(_c.replies.length);
    });
  }

  selectPostImage(String imageurl) {
    _postImageSelected = imageurl;
    notifyListeners();
  }
  /* USER ACTIONS */

  vote(String id, String direction) {
    // var data =
    reddit.vote(id, direction);
    /* data.forEach((a, b) {
      print(" $a and $b");
    });*/
  }
}

final List Sortby_options = ["hot", "top", "new", "controversal"];

final List t_options = ["hour", "day", "week", "month", "year", "all"];
