import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:reddit_clone_f/Components/post_widget.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/Screens/post_web_view.dart';
import 'package:reddit_clone_f/generic/menu_items_expansion_tile.dart';

class PostsScreen extends StatefulWidget {
  final RedditController redditController;

  const PostsScreen({Key key, this.redditController}) : super(key: key);

  @override
  PostsScreenState createState() {
    return new PostsScreenState();
  }
}

class PostsScreenState extends State<PostsScreen>
    with TickerProviderStateMixin {
  String currentSubreddit = "frontpage";
  bool first = true;
  bool reloading = true;
  //CurrentScreen screen = CurrentScreen.postsScreen;
  List<Post> posts = [];

  List<String> subReddits = [
    "frontpage",
    "Popular",
    "All",
    "AskReddit",
    "ADHD",
    "bestof",
    "books",
    "Politics",
    "Soccer",
    "pics",
    "2irl4mirl"
  ];
  ScrollController scrollController = ScrollController();
  AnimationController cardEntranceAnimationController;
  List<Animation> postTileAnimations;
  Animation fabAnimation;

  @override
  void initState() {
    super.initState();
    widget.redditController.addListener(() {
      if (first && widget.redditController.redditInitialized) {
        widget.redditController.getFrontPage();
        setState(() {
          first = false;
        });
      }
    });
  }

  setUpAnimations(List<Post> _newposts) {
    print("yoo");
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    postTileAnimations = _newposts.map((post) {
      int index = _newposts.indexOf(post);
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
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            height: 40.0,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(subReddits.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      print(subReddits[index]);
                      currentSubreddit = subReddits[index];
                      widget.redditController.setCurrentSubreddit =
                          subReddits[index];
                    },
                    child: Container(
                      height: 40.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Text(subReddits[index]),
                      ),
                    ),
                  );
                })),
          ),
          StreamBuilder(
            initialData: widget.redditController.postsBloc.getCurrentState(),
            stream: widget.redditController.postsBloc.postsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(""),
                );
              }
              if (snapshot.data.loading) {
                reloading = true;
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              posts = snapshot.data.posts;
              // scrollController.jumpTo(0.0);
              if (reloading) {
                setUpAnimations(posts);
                reloading = false;
              }
              return Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SingleChildScrollView(
                  //controller: scrollController,
                  child: new Column(
                    children: _buildPosts().toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Iterable<Widget> _buildPosts() {
    return posts.map((post) {
      int index = posts.indexOf(post);
      return AnimatedBuilder(
        animation: cardEntranceAnimationController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0, /* horizontal: 8.0*/
          ),
          child: PostWidget(
            newPost: post,
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

  AppBar _buildAppBar() {
    return new AppBar(
      leading: Icon(Icons.menu),
      title: Column(
        children: <Widget>[
          Text(currentSubreddit),
          Text("Hot"),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_hdr),
          onPressed: () {
            setState(() {});
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            // bloc.fetchmore();
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            setState(() {});
          },
        ),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("J");
              },
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '_fuzz_',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        )
                      ],
                    )),
              ),
            ),
            MenuItemsExpansionTile(
              backgroundColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('My profile'),
              children: <Widget>[
                ListTile(
                  title: Text('Saved'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Comments'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Submitted'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Mail'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Go to'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.bug_report,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Report bug'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text('Multireddits'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Subreddit or domain",
                ),
              ),
              trailing: Icon(Icons.create),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ]..addAll(
              List.generate(subReddits.length, (index) {
                return ListTile(
                  title: Text(subReddits[index]),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              }),
            )),
    );
  }
}
