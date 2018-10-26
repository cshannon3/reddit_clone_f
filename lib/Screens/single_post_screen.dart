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

class _SinglePostScreenState extends State<SinglePostScreen> {
  //CurrentScreen screen = CurrentScreen.singlePostScreen;

  List<CommentTree> commentTrees = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.redditController.openPostScreen(widget.activePost);
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
            return PostWidget(
              newPost: widget.activePost,
              isExpanded: true,
              redditController: widget.redditController,
            );
          }
          commentTrees = snapshot.data.commentTrees;
          // scrollController.jumpTo(0.0);
          // setUpAnimations(posts);
          return SingleChildScrollView(
              child: Column(
                  children: [
            PostWidget(
              newPost: widget.activePost,
              isExpanded: true,
              redditController: widget.redditController,
            ),
          ]..addAll(
                      List.generate(commentTrees.length, (index) {
                        return CommentTreeExpansionTile(
                          commentTree: commentTrees[index],
                          redditController: widget.redditController,
                        );
                      }),
                    )));
        },
      ),
    );
  }
}
