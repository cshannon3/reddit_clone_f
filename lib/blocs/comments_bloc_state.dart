import 'package:reddit_clone_f/Models/comment_tree.dart';

class CommentsBlocState {
  bool loading;
  List<CommentTree> commentTrees;

  CommentsBlocState(
    this.loading,
    this.commentTrees,
  );

  CommentsBlocState.empty() {
    loading = false;
    commentTrees = [];
  }
}
