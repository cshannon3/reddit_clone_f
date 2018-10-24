import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Components/post_widget.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/blocs/PostsBloc.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/generic/custom_expansion_tile.dart';
import 'package:reddit_clone_f/providers/posts_bloc_provider.dart';

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
  List<Post> posts = [];
  String currentSubreddit = "frontpage";
  bool showimage = false;

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
  AnimationController cardEntranceAnimationController;
  List<Animation> postTileAnimations;
  Animation fabAnimation;

  @override
  void initState() {
    super.initState();

    widget.redditController.addListener(() {
      /* if (widget.redditController.currentSubreddit != currentSubreddit) {
        print("hey");
        widget.redditController.setCurrentSubreddit=currentSubreddit;
        widget.redditController.getSubredditPosts(currentSubreddit);
      }*/
      if (widget.redditController.newPosts) {
        widget.redditController.posts;
        print("huh");
        setUpAnimations();
        setState(() {
          cardEntranceAnimationController.forward();
        });
      }
    });
    widget.redditController.getFrontPage();
  }

  setUpAnimations() {
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    postTileAnimations = widget.redditController.posts.map((post) {
      int index = widget.redditController.posts.indexOf(post);
      double start = index < 5 ? index * 0.1 : .4;
      double duration = 0.6;
      double end = duration + start;
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: cardEntranceAnimationController,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();
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
            setState(() {
              widget.redditController.clearpostImage();
              showimage = false;
            });
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
            CustomExpansionTile(
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

  Iterable<Widget> _buildPosts() {
    return widget.redditController.posts.map((post) {
      int index = widget.redditController.posts.indexOf(post);
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

  List<Widget> _buildUnanimated() {
    List<Widget> postWidgets = [];
    posts.forEach((post) {
      postWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0, /* horizontal: 8.0*/
        ),
        child: PostWidget(
          newPost: post,
          redditController: widget.redditController,
        ),
      ));
    });
    return postWidgets;
  }

  @override
  Widget build(BuildContext context) {
    //PostsBloc bloc = PostsBlocProvider.of(context).bloc;
    /*if (widget.redditController.posts.isEmpty) {
      widget.redditController.getFrontPage();
    } else {
      posts = widget.redditController.posts;
    }*/
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
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SingleChildScrollView(
              child: new Column(
                children: _buildPosts().toList(),
              ),
            ),
          ),
          /*showimage
              ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Opacity(
                      opacity: .8,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                    Image.network(bloc.redditController.postImageSelected),
                  ],
                )
              : Container(),*/
        ],
      ),
      drawer: _buildDrawer(),
    );
  }
}

class ExpandableMenuItem extends StatelessWidget {
  final Widget title;
  final Widget leading;

  const ExpandableMenuItem({Key key, this.title, this.leading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            leading,
            title,
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ],
    );
  }
}
