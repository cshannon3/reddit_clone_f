class CommentTree {
  final String id;
  final String body;
  final String linkid;
  List<CommentTree> replies;
  bool likes;
  String parentId;
  int score;
  int gilded;
  int depth;
  final String author;

  final DateTime postedTime;
  CommentTree({
    this.id,
    this.body,
    this.linkid,
    this.score,
    this.likes,
    this.gilded,
    this.parentId,
    this.replies,
    this.author,
    this.postedTime,
    this.depth,
  });

  String get fullId => "t1_" + id;

  CommentTree.fromJson(Map jsonMap, int depth)
      : id = jsonMap['id'],
        body = jsonMap['body'],
        linkid = jsonMap['link_id'],
        likes = jsonMap['likes'],
        score = jsonMap['score'],
        replies = (jsonMap['replies'] is String || jsonMap['replies'] == null)
            ? null
            : List.generate(
                (jsonMap['replies']['data']['children'] as List)
                    .where((_c) => (_c['kind'] == "t1"))
                    .length, (index) {
                /*  if (jsonMap['replies']['data']['children'][index]['kind'] ==
                    't1') {
                  print(jsonMap['replies']['data']['children'][index]);*/
                try {
                  return CommentTree.fromJson(
                      jsonMap['replies']['data']['children'][index]['data'],
                      depth + 1);
                } catch (e) {
                  print("hmm");
                }
                // }
              }),
        depth = depth,
        parentId = jsonMap['parent_id'],
        gilded = jsonMap['gilded'],
        author = jsonMap['author'],
        postedTime = (jsonMap['created_utc'] == null)
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                (jsonMap['created_utc'] * 1000).floor(),
                isUtc: true);
}
