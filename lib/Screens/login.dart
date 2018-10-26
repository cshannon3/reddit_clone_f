import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:reddit_clone_f/Controllers/reddit_controller.dart';
import 'package:reddit_clone_f/nolookie.dart' as NL;

class LoginWebView extends StatefulWidget {
  final RedditController redditController;

  const LoginWebView({Key key, this.redditController}) : super(key: key);
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final String authurl =
      "https://www.reddit.com/api/v1/authorize?client_id=${NL.identifier}&response_type=code&state=TEST&redirect_uri=" +
          "http://localhost:8080" +
          "&scope=*";

  CurrentScreen screen = CurrentScreen.loginScreen;

  // Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  final _urlCtrl = new TextEditingController(text: "");

  final _history = [];

  bool isOpen = true;

  @override
  void initState() {
    flutterWebviewPlugin.close();
    widget.redditController.addListener(() {
      if (widget.redditController.currentScreen == screen) {
        setState(() {
          isOpen = true;
        });
      }
    });
    setupWebviewStreams();
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  setupWebviewStreams() {
    _urlCtrl.addListener(() {});

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print(url);
          if (url.contains("?code=") || url.contains("&code=")) {
            Uri uri = Uri.parse(url);
            String authCode = uri.queryParameters["code"];
            widget.redditController.initFirst(authCode);
            setState(() {
              isOpen = false;
            });
            flutterWebviewPlugin.close();
          }
          _history.add('onUrlChanged: $url');
        });
      }
    });
    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isOpen
        ? Scaffold(
            body: Center(
              child: RaisedButton(onPressed: () {
                flutterWebviewPlugin.launch(authurl);
              }),
            ),
          )
        : Container();
  }
}
