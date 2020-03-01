import 'package:flutter/material.dart';

//about us screen

class AboutUs extends StatelessWidget {
  static String id = 'about_us';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '''إن شركة العاصمة اونلاين هي شركة دولية تقدم خدمات الإعلام والتسويق داخل تركيا وخارجها بشكل (اونلاين) لامركزي، انطلقت من سوريا بتاريخ نيسان 2012 على شكل إذاعة بدأت بثها الإخباري والمعرفي والترفيهي مستمراً حتى اللحظة دون انقطاع، حيث يمكن الاستماع لأثير راديو العاصمة اونلاين 24/7 حول العالم من خلال أي تطبيق راديو محلي او عالمي، ليصل شغف الرسالة والإبداع لمحيط اقليمي ودولي متمثل في 160 حول العالم، واستمرت برحلة النجاح مع جمهورها المكون من مئات آلاف المستمعين حول العالم، لتتوسع أنشطة شركة العاصمة اونلاين إلى خدمات التسويق الرقمي منذ عام 2017.

- خدمات بيع الكتب وشحنها (متجر كتابك على باب منزلك) منذ عام2018.

- خدمات المسؤولية الاجتماعية وبناء المشاريع وملتقيات الاستثمار والتوظيف
(الجالية الاسطنبولية - مقهى العاصمة اونلاين) منذ عام 2016.

* أسسها ويديرها الإعلامي السوري صهيب محمد اردوغان.''',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
// this is a button which goes to facebook page

//              GestureDetector(
//                onTap: () async {
//                  const url = 'https://fb.me/sohayb.mhd1';
//
//                  if (await canLaunch(url)) {
//                    await launch(url, forceSafariVC: true);
//                  } else {
//                    throw 'Could not launch $url';
//                  }
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(30),
//                    color: Colors.blue,
//                  ),
//                  width: MediaQuery.of(context).size.width * 0.6,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(
//                      'رابط صفحته على فيسبوك',
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 18.0,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 25,
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
