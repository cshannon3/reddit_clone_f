import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/Screens/image_overlay_screen.dart';
import 'package:reddit_clone_f/Screens/post_web_view.dart';
import 'package:reddit_clone_f/Screens/single_post_screen.dart';
import 'package:reddit_clone_f/widget_utils.dart';

class PostWidget extends StatefulWidget {
  final Post newPost;
  final RedditController redditController;
  //final Function onLinkClicked;
  final bool isExpanded;

  const PostWidget({
    Key key,
    @required this.newPost,
    @required this.redditController,
    this.isExpanded = false,
    // @required this.onLinkClicked,
  }) : super(key: key);

  @override
  PostWidgetState createState() {
    return new PostWidgetState();
  }
}

class PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.newPost.url.contains(".jpg")) {
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              widget.redditController.selectPostImage(widget.newPost.url);
            },
            child: Image.network(widget.newPost.url),
          ),
          PostTile()
        ],
      );
    }
    return PostTile();
  }

  Widget PostTile() {
    return GestureDetector(
      onTap: () {}, // => onClicked(newPost.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 20.0,
                  offset: Offset(5.0, 5.0)),
            ]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.newPost.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              _specialLabelsRow(),
              _leftInfoRow(),
              (widget.isExpanded && widget.newPost.postType == PostType.self)
                  ? _selfTextContainer()
                  : Container(),
              _bottomInputsRow()
            ]),
      ),
    );
  }

  Widget _selfTextContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Text(widget.newPost.selftext),
      ),
    );
  }

  Row _bottomInputsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        (widget.newPost.postType == PostType.self)
            ? Icon(
                Icons.menu,
                color: Colors.grey[400],
                size: 14.0,
              )
            : IconButton(
                onPressed: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (_) => PostWebView(
                              activePost: widget.newPost,
                            ))),
                icon: Icon(
                  Icons.link,
                  color: Colors.grey[500],
                  size: 20.0,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 3.0),
          child: IconButton(
            onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (_) => SinglePostScreen(
                          activePost: widget.newPost,
                          redditController: widget.redditController,
                        ))),
            icon: Icon(
              Icons.chat_bubble,
              color: Colors.grey[500],
              size: 20.0,
            ),
          ),
        ),
        Text(
          widget.newPost.numcomments.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: voteIconButton(
                upvote: true,
                likes: widget.newPost.likes,
                onVote: (way, newlikes, add) {
                  setState(() {
                    widget.newPost.likes = newlikes;
                    widget.newPost.score += (add) ? 1 : -1;
                    widget.redditController.vote(widget.newPost.fullId, way);
                  });
                })),
        Text(
          formattedScore(widget.newPost.score),
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 12.0),
          child: voteIconButton(
              upvote: false,
              likes: widget.newPost.likes,
              onVote: (way, newlikes, add) {
                setState(() {
                  widget.newPost.likes = newlikes;
                  widget.newPost.score += (add) ? 1 : -1;
                  widget.redditController.vote(widget.newPost.fullId, way);
                });
              }),
        ),
        Icon(
          Icons.more_vert,
          color: Colors.grey[500],
          size: 20.0,
        ),
      ],
    );
  }

  Row _leftInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        LeftPostRowText(text: widget.newPost.subreddit, isSubredditName: true),
        LeftPostRowIcon(icon: Icons.alarm),
        LeftPostRowText(text: timeSince(widget.newPost.postedTime)),
        LeftPostRowIcon(icon: Icons.person),
        LeftPostRowText(text: widget.newPost.author),
      ],
    );
  }

  Row _specialLabelsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.newPost.stickied
            ? Container(
                height: 20.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2.0)),
                child: Center(
                  child: Text(
                    "STICKY",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            : Container(),
        widget.newPost.gilded > 0
            ? Icon(
                Icons.monetization_on,
                size: 14.0,
                color: Colors.yellow,
              )
            : Container(),
        widget.newPost.over18
            ? Container(
                height: 20.0,
                width: 50.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2.0)),
                child: Center(
                  child: Text(
                    "NSFW",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            : Container(),
      ],
    );
  }
}
