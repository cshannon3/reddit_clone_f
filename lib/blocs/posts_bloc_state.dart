import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Models/post.dart';

class PostsBlocState {
  bool loading;
  List<Post> posts;

  PostsBlocState(
    this.loading,
    this.posts,
  );

  PostsBlocState.empty() {
    loading = false;
    posts = [];
  }
}
