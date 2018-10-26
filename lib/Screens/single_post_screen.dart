import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Components/post_widget.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Components/comment_tree_expansion_tile.dart';
import 'package:reddit_clone_f/Models/post.dart';

class SinglePostScreen extends StatefulWidget {
  final RedditController redditController;
  final Post activePost;

  const SinglePostScreen({Key key, this.redditController, this.activePost})
      : super(key: key);

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen>
    with TickerProviderStateMixin {
  //CurrentScreen screen = CurrentScreen.singlePostScreen;

  List<CommentTree> commentTrees = [];
  AnimationController cardEntranceAnimationController;
  List<Animation> postTileAnimations;
  Animation fabAnimation;
  bool reloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.redditController.openPostScreen(widget.activePost);
  }

  setUpAnimations(List<CommentTree> _newCommentTrees) {
    print("yoo");
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    postTileAnimations = _newCommentTrees.map((commentTree) {
      int index = _newCommentTrees.indexOf(commentTree);
      double start = index < 5 ? index * 0.1 : .4;
      double duration = 0.6;
      double end = duration + start;
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: cardEntranceAnimationController,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();

    cardEntranceAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            }),
      ),
      body: StreamBuilder(
        initialData: widget.redditController.commentsBloc.getCurrentState(),
        stream: widget.redditController.commentsBloc.commentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(""),
            );
          }
          if (snapshot.data.loading) {
            reloading = true;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PostWidget(
                  newPost: widget.activePost,
                  isExpanded: true,
                  redditController: widget.redditController,
                ),
                CircularProgressIndicator()
              ],
            );
          }
          commentTrees = snapshot.data.commentTrees;
          // scrollController.jumpTo(0.0);
          // setUpAnimations(posts);
          if (reloading) {
            setUpAnimations(commentTrees);
            reloading = false;
          }
          return SingleChildScrollView(
              child: Column(
                  children: [
            PostWidget(
              newPost: widget.activePost,
              isExpanded: true,
              redditController: widget.redditController,
            ),
          ]..addAll(_buildPosts().toList())));
        },
      ),
    );
  }

  Iterable<Widget> _buildPosts() {
    return commentTrees.map((commentTree) {
      int index = commentTrees.indexOf(commentTree);
      return AnimatedBuilder(
        animation: cardEntranceAnimationController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0, /* horizontal: 8.0*/
          ),
          child: CommentTreeExpansionTile(
            commentTree: commentTree,
            redditController: widget.redditController,
          ),
        ),
        builder: (context, child) => new Transform.translate(
              offset: Offset(0.0, postTileAnimations[index].value),
              child: child,
            ),
      );
    });
  }
}
