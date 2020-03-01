import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class AsimaNews extends StatefulWidget {
  static String id = 'asima_news';
  @override
  _AsimaNewsState createState() => _AsimaNewsState();
}

class _AsimaNewsState extends State<AsimaNews> {
  String url = "https://www.asima-online.net/";

  final webViewPlugin = new FlutterWebviewPlugin();

  @override
  void dispose() {
    super.dispose();
    webViewPlugin.dispose(); // disposing the webview widget
  }

  @override
  Widget build(BuildContext context) {
    webViewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      if (mounted) {
        const url = 'https://api.whatsapp.com/send?phone=905526250097';
        if (state.url == url) {
          webViewPlugin.goBack();
          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: true);
          } else {
            throw 'Could not launch $url';
          }
        }
      }
    });
    return WebviewScaffold(
      url: url,
      withJavascript: true, // run javascript
      withZoom: false,

      hidden:
          true, // show CircularProgressIndicator while waiting for the page to load

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "آخر الأخبار",
              style: TextStyle(color: Colors.grey[900], fontSize: 18),
            ),
            InkWell(
              onTap: () => webViewPlugin.reload(),
              child: Icon(
                Icons.refresh,
                color: Colors.grey[900],
              ),
            ),
            InkWell(
              onTap: () => webViewPlugin.goBack(),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
