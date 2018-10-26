import 'package:flutter/material.dart';

const double baseHeight = 650.0;

double screenAwareSize(double size, BuildContext context) {
  double drawingHeight =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  return size * drawingHeight / baseHeight;
}

String formattedScore(int score) {
  return (score < 1000)
      ? score.toString()
      : (score < 10000)
          ? ((score / 1000).toStringAsPrecision(2) + "k")
          : ((score / 1000).floor().toString() + "k");
}

Widget voteIconButton(
    {@required bool upvote,
    @required bool likes,
    @required Function(String way, bool newlikes, bool add) onVote}) {
  String way;
  bool newlikes;
  bool add;
  Widget icon;
  if (upvote) {
    if (likes == null || !likes) {
      way = "1";
      newlikes = true;
      add = true;
    } else {
      way = "0";
      newlikes = null;
      add = false;
    }
    icon = Icon(
      Icons.arrow_upward,
      color: (likes == null || !likes) ? Colors.grey[500] : Colors.green,
      size: 20.0,
    );
  } else {
    if (likes == null || likes) {
      way = "-1";
      newlikes = false;
      add = false;
    } else {
      way = "0";
      newlikes = null;
      add = true;
    }

    icon = Icon(
      Icons.arrow_downward,
      color: (likes == null || likes) ? Colors.grey[500] : Colors.red,
      size: 20.0,
    );
  }

  return IconButton(
      onPressed: () {
        onVote(way, newlikes, add);
      },
      icon: icon);
}

String timeSince(
  DateTime postedTime,
) {
  Duration timesince = DateTime.now().toUtc().difference(postedTime);
  return timesince.inMinutes < 60
      ? timesince.inMinutes.toString() + "m"
      : (timesince.inHours < 24)
          ? timesince.inHours.toString() + "h"
          : timesince.inDays.toString() + "d";
}

Text LeftPostRowText({@required String text, bool isSubredditName = false}) {
  return Text(
    text,
    style: (isSubredditName)
        ? TextStyle(
            color: Colors.red, fontSize: 10.0, fontWeight: FontWeight.bold)
        : TextStyle(color: Colors.grey, fontSize: 12.0),
  );
}

Widget LeftPostRowIcon({IconData icon}) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0),
    child: Icon(
      icon,
      color: Colors.grey[400],
      size: 14.0,
    ),
  );
}
