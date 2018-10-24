class Post {
  final String id;
  final String title;
  final String subreddit;
  final String url;
  bool likes;
  int score;
  int numcomments;
  int gilded;
  final String author;
  final bool over18;
  bool stickied;
  final DateTime postedTime;
  Post({
    this.id,
    this.title,
    this.url,
    this.subreddit,
    this.score,
    this.likes,
    this.numcomments,
    this.over18,
    this.gilded,
    this.stickied,
    this.author,
    this.postedTime,
  });

  String get fullId => "t3_" + id;

  Post.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        title = jsonMap['title'],
        url = jsonMap['url'],
        subreddit = jsonMap['subreddit'],
        likes = jsonMap['likes'],
        score = jsonMap['score'],
        numcomments = jsonMap['num_comments'],
        gilded = jsonMap['gilded'],
        author = jsonMap['author'],
        over18 = jsonMap['over_18'],
        stickied = jsonMap['stickied'],
        postedTime = DateTime.fromMillisecondsSinceEpoch(
            (jsonMap['created_utc'] * 1000).floor(),
            isUtc: true);
}
