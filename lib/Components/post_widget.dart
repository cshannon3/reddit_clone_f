import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/Screens/image_overlay_screen.dart';
import 'package:reddit_clone_f/Screens/post_web_view.dart';
import 'package:reddit_clone_f/Screens/single_post_screen.dart';

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
  Widget PostTile() {
    Duration timesincepost =
        DateTime.now().toUtc().difference(widget.newPost.postedTime);
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
              Row(
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.newPost.subreddit,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Icon(
                      Icons.alarm,
                      color: Colors.grey[400],
                      size: 14.0,
                    ),
                  ),
                  Text(
                    timesincepost.inMinutes > 60
                        ? timesincepost.inHours.toString() + "h"
                        : timesincepost.inMinutes.toString() + "m",
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[400],
                      size: 14.0,
                    ),
                  ),
                  Text(
                    widget.newPost.author,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
              (widget.isExpanded && widget.newPost.postType == PostType.self)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        child: Text(widget.newPost.selftext),
                      ),
                    )
                  : Container(),
              Row(
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
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.newPost.likes == null ||
                              !widget.newPost.likes) {
                            widget.redditController
                                .vote(widget.newPost.fullId, "1");
                            widget.newPost.likes = true;
                            widget.newPost.score += 1;
                          } else {
                            widget.redditController
                                .vote(widget.newPost.fullId, "0");
                            widget.newPost.likes = null;
                            widget.newPost.score -= 1;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.arrow_upward,
                        color: (widget.newPost.likes == null ||
                                !widget.newPost.likes)
                            ? Colors.grey[500]
                            : Colors.green,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Text(
                    widget.newPost.score < 1000
                        ? widget.newPost.score.toString()
                        : widget.newPost.score < 10000
                            ? (widget.newPost.score / 1000)
                                    .toStringAsPrecision(2) +
                                "k"
                            : (widget.newPost.score / 1000).floor().toString() +
                                "k",
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.newPost.likes == null ||
                              widget.newPost.likes) {
                            widget.redditController
                                .vote(widget.newPost.fullId, "-1");
                            widget.newPost.likes = false;
                            widget.newPost.score -= 1;
                          } else {
                            widget.redditController
                                .vote(widget.newPost.fullId, "0");
                            widget.newPost.likes = null;
                            widget.newPost.score += 1;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.arrow_downward,
                        color: (widget.newPost.likes == null ||
                                widget.newPost.likes)
                            ? Colors.grey[500]
                            : Colors.red,
                        size: 20.0,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.grey[500],
                    size: 20.0,
                  ),
                ],
              )
            ]),
      ),
    );
  }

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
}
