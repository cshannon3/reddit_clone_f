import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/comment_tree.dart';
import 'package:reddit_clone_f/Components/comment_tree_expansion_tile.dart';

class SinglePostScreen extends StatefulWidget {
  final RedditController redditController;

  const SinglePostScreen({Key key, this.redditController}) : super(key: key);

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  CurrentScreen screen = CurrentScreen.singlePostScreen;
  bool isOpen = false;
  List<CommentTree> commentTrees;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.redditController.addListener(() {
      if (widget.redditController.currentScreen == screen) {
        setState(() {
          commentTrees = widget.redditController.commentTrees;
          isOpen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? Scaffold(
            //  backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    setState(() {
                      isOpen = false;
                      widget.redditController.exitSinglePostScreen();
                    });
                  }),
            ),
            body: ListView(
              children: List.generate(commentTrees.length, (index) {
                return CommentTreeExpansionTile(
                  commentTree: commentTrees[index],
                  redditController: widget.redditController,
                );
              }),
            ))
        : Container();
  }
}
