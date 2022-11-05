import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewReviews extends StatefulWidget {
  const WebViewReviews({Key? key}) : super(key: key);

  @override
  _WebViewReviewsState createState() => _WebViewReviewsState();
}

class _WebViewReviewsState extends State<WebViewReviews> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: WebView(
        initialUrl:
            'https://www.google.com/search?q=virash+training+institute&oq=virash+tr&aqs=chrome.0.0i355i512j46i175i199i512j69i57j0i22i30.1765j0j7&sourceid=chrome&ie=UTF-8#lrd=0x3be7b04de8b57785:0x3a6c95c6cfe687ad,1',
      ),
    );
  }
}
