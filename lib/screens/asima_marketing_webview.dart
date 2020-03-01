import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class AsimaMarketing extends StatefulWidget {
  static String id = 'asima_marketing';
  @override
  _AsimaMarketingState createState() => _AsimaMarketingState();
}

class _AsimaMarketingState extends State<AsimaMarketing> {
  String url = "https://services.asima-online.net/";

  final webViewPlugin = new FlutterWebviewPlugin();
  @override
  void dispose() {
    super.dispose();
    webViewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    webViewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      if (mounted) {
        const url = 'https://api.whatsapp.com/send?phone=905312340097';
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
      withLocalStorage: true,
      withLocalUrl: true,
      ignoreSSLErrors: true,
      url: url,
      withJavascript: true,
      withZoom: false,
      hidden: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "العاصمة للتسويق الرقمي",
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
