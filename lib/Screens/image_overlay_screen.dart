import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/post.dart';

class ImageOverlayScreen extends StatefulWidget {
  final RedditController redditController;

  const ImageOverlayScreen({Key key, this.redditController}) : super(key: key);
  @override
  _ImageOverlayScreenState createState() => _ImageOverlayScreenState();
}

class _ImageOverlayScreenState extends State<ImageOverlayScreen> {
  CurrentScreen screen = CurrentScreen.imageOverlayScreen;
  bool showimage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.redditController.addListener(() {
      if (widget.redditController.currentScreen == screen) {
        setState(() {
          showimage = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showimage
        ? Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    setState(() {
                      showimage = false;
                      widget.redditController.clearpostImage();
                    });
                  }),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Opacity(
                  opacity: .8,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Image.network(widget.redditController.postImageSelected),
              ],
            ))
        : Container();
  }
}
