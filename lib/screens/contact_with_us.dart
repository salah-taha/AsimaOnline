import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWithUs extends StatelessWidget {
  static String id = 'contact_with_us';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'نرحب بتواصلكم مع إدارة مؤسسة العاصمة اونلاين مباشرة عبر الإيميل:',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              ' info@asima-online.net',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () async {
                const url = 'https://wa.me/905526250097';

                if (await canLaunch(url)) {
                  await launch(url, forceSafariVC: true);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'أو اضغط هنا للتواصل عبر واتساب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
