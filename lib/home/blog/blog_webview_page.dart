import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlogWebviewPage extends StatefulWidget {
  final String url;
  const BlogWebviewPage({Key? key, required this.url}) : super(key: key);

  @override
  _BlogWebviewPageState createState() => _BlogWebviewPageState();
}

class _BlogWebviewPageState extends State<BlogWebviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
        ),
      ),
    );
  }
}
