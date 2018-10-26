import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/blocs/comments_bloc.dart';
import 'package:reddit_clone_f/blocs/posts_bloc.dart';
import 'package:reddit_clone_f/reddit_plugin/reddit.dart';
import 'package:reddit_clone_f/nolookie.dart' as NL;

class RedditController extends ChangeNotifier {
  Reddit reddit;
  CurrentScreen _currentScreen = CurrentScreen.loginScreen;

  CurrentScreen get currentScreen => _currentScreen;

  final _postsBloc = PostsBloc();
  final _commentsBloc = CommentsBloc();

  PostsBloc get postsBloc => _postsBloc;
  CommentsBloc get commentsBloc => _commentsBloc;
  /* AUTH */
  bool _redditInitialized = false;
  bool get redditInitialized => _redditInitialized;

  initFirst(String code) async {
    _currentScreen = CurrentScreen.postsScreen;
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
  // List<Post> _posts = [];
  String _currentSubreddit = "frontpage";
  // bool _newPosts = false;
  String _postImageSelected;

  Post _activePost;
  //List<CommentTree> _commentTrees;

  /* GETTERS AND SETTERS */
  // List<Post> get posts => _posts;
  String get currentSubreddit => _currentSubreddit;
  // bool get newPosts => _newPosts;
  //List<CommentTree> get commentTrees => _commentTrees;
  String get activeUrl => _activePost.url;

  set setCurrentSubreddit(String newSubreddit) {
    _currentSubreddit = newSubreddit;
    getSubredditPosts(_currentSubreddit);
  }

  set setActivePost(Post newActivePost) {
    _activePost = newActivePost;
    notifyListeners();
  }

  exitSinglePostScreen() {
    //_commentTrees = [];
    _activePost = null;
    _currentScreen = CurrentScreen.postsScreen;
    notifyListeners();
  }

/*  postsRecieved() {
    _newPosts = false;
  }
*/
  String get postImageSelected => _postImageSelected;

  selectPostImage(String imageurl) {
    _postImageSelected = imageurl;
    _currentScreen = CurrentScreen.imageOverlayScreen;
    notifyListeners();
  }

  clearpostImage() {
    _postImageSelected = null;
    _currentScreen = CurrentScreen.postsScreen;
    notifyListeners();
  }

  /* SUBREDDIT POSTS DATA */
  getSubredditPosts(String subreddit,
      {String sortby = "hot", String t_option = "week"}) async {
    _currentSubreddit = subreddit;
    if (subreddit == "frontpage") {
      await getFrontPage();
      return;
    }
    //_posts = [];
    _postsBloc.loadingPosts();
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
        // _posts = list;
        _postsBloc.finishedLoading(list);
        // _newPosts = true;
        // notifyListeners();
      }
    }
  }

  getFrontPage() async {
    // _newPosts = true;
    // if (_redditInitialized) {
    _postsBloc.loadingPosts();
    _currentPostData = await reddit.frontPage.best().limit(20).fetch();
    List d = _currentPostData['data']['children'];
    var list = d.map((_post) {
      return Post.fromJson(_post['data']);
    }).toList();
    if (list is List<Post>) {
      //  _posts = list;
      // _newPosts = true;
      _postsBloc.finishedLoading(list);
      //  notifyListeners();
    }
    //  }
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
  }

/* SINGLEPOSTPAGE*/
  openPostScreen(Post newActivePost) async {
    _currentScreen = CurrentScreen.singlePostScreen;
    _activePost = newActivePost;
    await comments(newActivePost.subreddit, newActivePost.id);
    notifyListeners();
  }

  comments(String sub, String id) async {
    // var data = await
    // _commentTrees = [];
    _commentsBloc.loadingComments();
    var data = await reddit.comments(sub, id);
    List comments = data[1]['data']['children'];
    var list = comments.map((_commentTree) {
      return CommentTree.fromJson(_commentTree['data'], 0);
    }).toList();
    if (list is List<CommentTree>) {
      _commentsBloc.finishedLoading(list);
    }
  }

  /* WEBVIEW PAGE */

  /* USER ACTIONS */

  vote(String fullId, String direction) {
    reddit.vote(fullId, direction);
  }
}

final List Sortby_options = ["hot", "top", "new", "controversal"];

final List t_options = ["hour", "day", "week", "month", "year", "all"];

enum CurrentScreen {
  postsScreen,
  singlePostScreen,
  imageOverlayScreen,
  loginScreen,
  webviewScreen,
}
