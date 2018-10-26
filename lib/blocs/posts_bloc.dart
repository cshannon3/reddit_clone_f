import 'package:reddit_clone_f/Models/post.dart';

import 'posts_bloc_state.dart';

import 'dart:async';
class PostsBloc {

  PostsBlocState _currentPostsBlocState;

  StreamSubscription<List<Post>> _fetchPostsSubscription;



  final StreamController<PostsBlocState> _PostsController =
  StreamController.broadcast();

  Stream<PostsBlocState> get postsStream => _PostsController.stream;

  PostsBloc() {
    _currentPostsBlocState = PostsBlocState.empty();
  }

  PostsBlocState getCurrentState() {
    return _currentPostsBlocState;
  }

  loadingPosts() {
    _fetchPostsSubscription?.cancel();

    _currentPostsBlocState.loading = true;
    _PostsController.add(_currentPostsBlocState);

  }

  finishedLoading(List<Post> _newPosts){
    _currentPostsBlocState.posts = _newPosts;
    _currentPostsBlocState.loading = false;
    _PostsController.add(_currentPostsBlocState);
  }

}