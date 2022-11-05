import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeveloperWebviewPage extends StatefulWidget {
  final String url;
  const DeveloperWebviewPage({Key? key, required this.url}) : super(key: key);

  @override
  _DeveloperWebviewPageState createState() => _DeveloperWebviewPageState();
}

class _DeveloperWebviewPageState extends State<DeveloperWebviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
