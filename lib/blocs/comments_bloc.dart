import 'dart:async';

import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/blocs/comments_bloc_state.dart';

class CommentsBloc {
  CommentsBlocState _currentCommentsBlocState;

  StreamSubscription<List<CommentTree>> _fetchCommentsSubscription;

  final StreamController<CommentsBlocState> _commentsController =
      StreamController.broadcast();

  Stream<CommentsBlocState> get commentsStream => _commentsController.stream;

  CommentsBloc() {
    _currentCommentsBlocState = CommentsBlocState.empty();
  }

  CommentsBlocState getCurrentState() {
    return _currentCommentsBlocState;
  }

  loadingComments() {
    _fetchCommentsSubscription?.cancel();

    _currentCommentsBlocState.loading = true;
    _commentsController.add(_currentCommentsBlocState);
  }

  finishedLoading(List<CommentTree> _newComments) {
    _currentCommentsBlocState.commentTrees = _newComments;
    _currentCommentsBlocState.loading = false;
    _commentsController.add(_currentCommentsBlocState);
  }
}
