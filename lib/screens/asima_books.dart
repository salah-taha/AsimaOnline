import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

//asima books screen

class AsimaBooks extends StatefulWidget {
  static String id = 'asima_books';
  @override
  _AsimaBooksState createState() => _AsimaBooksState();
}

class _AsimaBooksState extends State<AsimaBooks> {

  //url for asima books website
  String url = " https://kitabk.asima.website";

  final webViewPlugin = new FlutterWebviewPlugin();

  @override
  void dispose() {
    super.dispose();
    webViewPlugin.dispose(); // disposing the webView widget
  }

  @override
  Widget build(BuildContext context) {
    //state for launching whatsapp if it's button clicked in the website
    webViewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      if (mounted) {
        const url =
            'https://api.whatsapp.com/send?phone=905525163167&text=%d8%a3%d8%aa%d8%ad%d8%af%d8%ab%20%d9%85%d8%b9%d9%83%d9%85%20%d9%85%d9%86%20%d8%a3%d8%ac%d9%84%20%d8%b4%d8%b1%d8%a7%d8%a1%20%d9%87%d8%b0%d8%a7%20%d8%a7%d9%84%d9%83%d8%aa%d8%a7%d8%a8%20%d8%a3%d9%88%20%d9%83%d8%aa%d8%a8%20%d9%85%d8%b4%d8%a7%d8%a8%d9%87%d8%a9%20%d9%84%d9%87%3a%20https%3a%2f%2fkitabk.asima.website%2f&source=&data=';
        if (state.url == url) {
          //prevent the webView from going to the whatsapp link but it will go to the application
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
      enableAppScheme: true,

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "كتابك على باب منزلك",
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
