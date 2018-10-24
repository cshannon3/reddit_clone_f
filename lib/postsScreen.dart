import 'package:flutter/material.dart';
import 'package:reddit_clone_f/Components/post_widget.dart';
import 'package:reddit_clone_f/blocs/PostsBloc.dart';
import 'package:reddit_clone_f/Models/post.dart';
import 'package:reddit_clone_f/generic/custom_expansion_tile.dart';
import 'package:reddit_clone_f/providers/posts_bloc_provider.dart';

class PostsScreen extends StatefulWidget {
//  final RedditController redditController;

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
  List<Animation> ticketAnimations;
  Animation fabAnimation;

  AppBar _buildAppBar(PostsBloc bloc) {
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
              bloc.redditController.clearpostImage();
              showimage = false;
            });
            // bloc.redditController.vote("t3_"+posts[0].id);
            // bloc.redditController
            //    .getComments(posts[0].id, posts[0].subreddit);
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            bloc.fetchmore();
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

  Iterable<Widget> _buildTickets() {
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
            redditController:
                PostsBlocProvider.of(context).bloc.redditController,
          ),
        ),
        builder: (context, child) => new Transform.translate(
              offset: Offset(0.0, ticketAnimations[index].value),
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
          redditController: PostsBlocProvider.of(context).bloc.redditController,
        ),
      ));
    });
    return postWidgets;
  }

  @override
  Widget build(BuildContext context) {
    PostsBloc bloc = PostsBlocProvider.of(context).bloc;
    if (bloc.getCurrentState().posts.isEmpty ||
        bloc.getCurrentState().posts == null) {
      bloc.frontPage();
    } else {
      posts = bloc.getCurrentState().posts;
    }
    bloc.redditController.addListener(() {
      if (bloc.redditController.postImageSelected != null) {
        setState(() {
          showimage = true;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(bloc),
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
                      bloc.Subreddit(subReddits[index]);
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
            child: StreamBuilder(
                initialData: bloc.getCurrentState(),
                stream: bloc.postsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        /* child: Text(AppLocalizations.of(context).get('something_wrong'/),*/
                        );
                  }
                  if (snapshot.data.loading) {
                    return Center();
                  }

                  posts = snapshot.data.posts;
                  if (showimage) {
                    return SingleChildScrollView(
                      child: new Column(
                        children: _buildUnanimated(),
                      ),
                    );
                  }
                  cardEntranceAnimationController = new AnimationController(
                    vsync: this,
                    duration: Duration(milliseconds: 1100),
                  );
                  ticketAnimations = posts.map((post) {
                    int index = posts.indexOf(post);
                    double start = index < 5 ? index * 0.1 : .4;
                    double duration = 0.6;
                    double end = duration + start;
                    return new Tween<double>(begin: 800.0, end: 0.0).animate(
                        new CurvedAnimation(
                            parent: cardEntranceAnimationController,
                            curve: new Interval(start, end,
                                curve: Curves.decelerate)));
                  }).toList();
                  fabAnimation = new CurvedAnimation(
                      parent: cardEntranceAnimationController,
                      curve: Interval(0.7, 1.0, curve: Curves.decelerate));
                  cardEntranceAnimationController.forward();
                  return SingleChildScrollView(
                    child: new Column(
                      children: _buildTickets().toList(),
                    ),
                  );
                }),
          ),
          showimage
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
              : Container(),
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

/*class PostsScreen extends StatefulWidget {
  final RedditController redditController;

  const PostsScreen({Key key, this.redditController}) : super(key: key);

  @override
  PostsScreenState createState() {
    return new PostsScreenState();
  }
}

class PostsScreenState extends State<PostsScreen> {
  List<Post> posts = [];

  List<String> subReddits = [
    "Popular",
    "All",
    "AskReddit",
    "ADHD",
    "bestof",
    "books",
    "Politics",
    "Soccer",
    "2irl4mirl"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frontpage();
  }

  frontpage() async {
    var stream = await widget.redditController.FrontPage();
    stream.listen((_post) => setState(() {
          print("Hey");
          posts.add(_post);
        }));
  }

  @override
  Widget build(BuildContext context) {
    /*PostsBloc bloc = PostsBlocProvider.of(context).bloc;
    if (bloc.getCurrentState().posts.isEmpty ||
        bloc.getCurrentState().posts == null) {
      bloc.frontPage();
    } else {
      posts = bloc.getCurrentState().posts;
      print(posts);
    }*/
    return Scaffold(
        appBar: new AppBar(
          leading: Icon(Icons.menu),
          title: Column(
            children: <Widget>[
              Text("AskReddit"),
              Text("Hot"),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_hdr),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                //bloc.fetchmore();
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                //setState(() {});
              },
            ),
          ],
        ),
        body:
            /*StreamBuilder(
          initialData: bloc.getCurrentState(),
          stream: bloc.postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                /* child: Text(AppLocalizations.of(context).get('something_wrong'/),*/
              );
            }
            if (snapshot.data.loading) {
              return Center();
            }
            posts = snapshot.data.posts;
            return */
            Column(
          children: <Widget>[
            Container(
              height: 40.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(subReddits.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        print(subReddits[index]);
                        // bloc.Subreddit(subReddits[index]);
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
            Expanded(
              child: new ListView(
                children: List.generate(posts.length, (_postindex) {
                  Post newPost = posts[_postindex];
                  Duration timesincepost =
                      DateTime.now().toUtc().difference(newPost.postedTime);
                  return Container(
                    height: 130.0,
                    color: Colors.blue,
                    child: Column(children: [
                      Text(
                        newPost.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          newPost.stickied
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
                          newPost.gilded > 0
                              ? Icon(
                                  Icons.monetization_on,
                                )
                              : Container(),
                          newPost.over18
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
                            newPost.subreddit,
                            style: TextStyle(color: Colors.red),
                          ),
                          Icon(Icons.alarm),
                          Text(timesincepost.inMinutes > 60
                              ? timesincepost.inHours.toString() + "h"
                              : timesincepost.inMinutes.toString() + "m"),
                          Icon(Icons.person),
                          Text(newPost.author),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.menu),
                          Icon(Icons.chat_bubble),
                          Text(newPost.numcomments.toString()),
                          Icon(Icons.arrow_upward),
                          Text(newPost.score < 1000
                              ? newPost.score.toString()
                              : newPost.score < 10000
                                  ? (newPost.score / 1000)
                                          .toStringAsPrecision(2) +
                                      "k"
                                  : (newPost.score / 1000).floor().toString() +
                                      "k"),
                          Icon(Icons.arrow_downward),
                          Icon(Icons.more_vert),
                        ],
                      )
                    ]),
                  );
                }),
              ),
            ),
          ],
        )
        //  }),
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

*/
