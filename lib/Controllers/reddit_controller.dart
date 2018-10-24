import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/reddit_plugin/reddit.dart';
import 'package:reddit_clone_f/nolookie.dart' as NL;

class RedditController extends ChangeNotifier {
  Reddit reddit;
  bool _redditInitialized = false;
  ListingResult _currentData;
  String _postImageSelected;

  bool get redditInitialized => _redditInitialized;
  String get postImageSelected => _postImageSelected;

  clearpostImage() {
    _postImageSelected = null;
    notifyListeners();
  }

  initFirst(String code) async {
    reddit = Reddit(new Client());
    reddit.authSetup(NL.identifier, NL.secret);
    await reddit.authUrl("http://localhost:8080", scopes: ["*"], state: "TEST");
    await reddit.authFinish(code: code);
    _redditInitialized = true;
    notifyListeners();
  }

  Future<List<Post>> getSubredditPosts(String subreddit,
      {String sortby = "hot", String t_option = "week"}) async {
    if (_redditInitialized) {
      _currentData = sortby == "hot"
          ? await reddit.sub(subreddit).hot().limit(20).fetch()
          : sortby == "top"
              ? await reddit.sub(subreddit).top(t_option).limit(20).fetch()
              : await reddit.sub(subreddit).hot().limit(20).fetch();
      List d = _currentData['data']['children'];
      var list = d.map((_post) {
        return Post.fromJson(_post['data']);
      }).toList();
      if (list is List<Post>) {
        return list;
      }
      return null;
    }
  }

  Future<List<Post>> getFrontPage() async {
    if (_redditInitialized) {
      _currentData = await reddit.frontPage.best().limit(20).fetch();
      List d = _currentData['data']['children'];
      var list = d.map((_post) {
        return Post.fromJson(_post['data']);
      }).toList();
      if (list is List<Post>) {
        return list;
      }
      print("bad");
      return null;
    }
  }

  Future<List<Post>> fetchmore() async {
    if (_currentData != null) {
      var _newData = await _currentData.fetchMore();
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

  getComments(String id, String subreddit) async {
    if (_redditInitialized) {
      var data = await reddit.sub(subreddit).coments(id).fetch();
      List d = data['data']['children'];

      print(d);
    }
  }

  vote(String id, String direction) {
    // var data =
    reddit.vote(id, direction);
    /* data.forEach((a, b) {
      print(" $a and $b");
    });*/
  }

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
}

/*enum SortBy {
  hot,
  top,
  rising,
  newest,
}*/
final List Sortby_options = ["hot", "top", "new", "controversal"];

final List t_options = ["hour", "day", "week", "month", "year", "all"];
