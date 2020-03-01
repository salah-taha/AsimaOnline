import 'package:asima_online/screens/about_us.dart';
import 'package:asima_online/screens/asima_books.dart';
import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/screens/asima_marketing_webview.dart';
import 'package:asima_online/screens/asima_news.dart';
import 'package:asima_online/screens/asima_radio.dart';
import 'package:asima_online/screens/chat_screens.dart';
import 'package:asima_online/screens/contact_with_us.dart';
import 'package:asima_online/screens/currency_exchange.dart';
import 'package:asima_online/screens/ideas_investment_screen.dart';
import 'package:asima_online/screens/job_chances_screen.dart';
import 'package:asima_online/screens/profile_screen.dart';
import 'package:asima_online/screens/question_answer.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';

//home page screen

class HomePage extends StatefulWidget {
  static String id = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> audioStart() async {
    FlutterRadio.audioStart();
  }

  @override
  void initState() {
    super.initState();

    //initialize audio player
    audioStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //asima logo at top
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/New Capital.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: ExactAssetImage('assets/Logo.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange[800],
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ]),
                  ),
                ),
              ),

              Holder(
                firstChild: 'العاصمة للتسويق الرقمي',
                firstWidget: AsimaMarketing(),
                firstIcon: Icons.shopping_basket,
                secondChild: 'استماع فوري لإذاعة العاصمة',
                secondIcon: Icons.headset,
                secondWidget: RadioAsima(),
                thirdChild: 'آخر الأخبار',
                thirdWidget: AsimaNews(),
                thirdIcon: Icons.assignment,
              ),
              Holder(
                secondChild: 'أسعار العملات',
                secondIcon: Icons.monetization_on,
                secondWidget: CurrencyExchanger(),
                firstChild: 'دليل الأعمال',
                firstWidget: AsimaBusiness(),
                firstIcon: Icons.business_center,
                thirdChild: 'سؤال وجواب',
                thirdIcon: Icons.question_answer,
                thirdWidget: QuestionAnswerScreen(),
              ),
              Holder(
                firstChild: 'فرص عمل',
                firstWidget: JobChancesScreen(),
                firstIcon: Icons.search,
                secondChild: 'ملتقى الأفكار والاستثمار',
                secondIcon: Icons.attach_money,
                secondWidget: IdeasInvestmentScreen(),
                thirdChild: 'الدردشة',
                thirdWidget: ChatScreen(),
                thirdIcon: Icons.chat_bubble,
              ),
              Holder(
                secondChild: 'من نحن',
                secondIcon: Icons.error,
                secondWidget: AboutUs(),
                firstIcon: Icons.clear_all,
                firstChild: 'تواصل معنا',
                firstWidget: ContactWithUs(),
                thirdWidget: AsimaBooks(),
                thirdIcon: Icons.book,
                thirdChild: 'كتابك على باب منزلك',
              ),
              Holder(
                firstWidget: SignIn(),
                firstChild: 'تسجيل الدخول',
                firstIcon: Icons.input,
                secondChild: 'الصفحة الشخصية',
                secondIcon: Icons.person,
                secondWidget: ProfileScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//this is the 3 widgets holder
class Holder extends StatelessWidget {
  final Widget firstWidget;
  final Widget secondWidget;
  final IconData firstIcon;
  final IconData secondIcon;
  final String firstChild;
  final String secondChild;
  final Widget thirdWidget;
  final IconData thirdIcon;
  final String thirdChild;

  Holder(
      {this.firstWidget,
      this.secondWidget,
      this.secondChild,
      this.firstChild,
      this.firstIcon,
      this.secondIcon,
      this.thirdChild,
      this.thirdIcon,
      this.thirdWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => firstWidget,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xfff2f2f2),
              border: Border(
                left: BorderSide(color: Colors.grey, width: 0.2),
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            width: thirdWidget == null
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width * 0.33333,
            height: MediaQuery.of(context).size.width * 0.33333,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  firstChild ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  firstIcon,
                  color: Colors.blue[700],
                  size: 30,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => secondWidget,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xfff2f2f2),
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            width: thirdWidget == null
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width * 0.33333,
            height: MediaQuery.of(context).size.width * 0.33333,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  secondChild ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  secondIcon,
                  color: Colors.blue[700],
                  size: 30,
                )
              ],
            ),
          ),
        ),
        thirdWidget != null
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => thirdWidget,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff2f2f2),
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 0.2),
                      bottom: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.33333,
                  height: MediaQuery.of(context).size.width * 0.33333,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        thirdChild ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        thirdIcon,
                        color: Colors.blue[700],
                        size: 30,
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

// this is the old home widgets

//class Holder extends StatelessWidget {
//  final Widget firstWidget;
//  final Widget secondWidget;
//  final IconData firstIcon;
//  final IconData secondIcon;
//  final String firstChild;
//  final String secondChild;
//
//  Holder(
//      {this.firstWidget,
//      this.secondWidget,
//      this.secondChild,
//      this.firstChild,
//      this.firstIcon,
//      this.secondIcon});
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => firstWidget,
//                ),
//              );
//            },
//            child: Container(
//              decoration: BoxDecoration(
//                  color: Color(0xfff2f2f2),
//                  borderRadius: BorderRadius.circular(25),
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.white,
//                      offset: Offset(-3, -3),
//                      blurRadius: 3,
//                      spreadRadius: 3,
//                    ),
//                    BoxShadow(
//                      color: Colors.grey[300],
//                      offset: Offset(3, 3),
//                      blurRadius: 3,
//                      spreadRadius: 3,
//                    ),
//                  ]),
//              width: MediaQuery.of(context).size.width * 0.4,
//              height: MediaQuery.of(context).size.width * 0.3,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    firstChild ?? '',
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 18.0,
//                      color: Colors.blue[700],
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  Icon(
//                    firstIcon,
//                    color: Colors.blue[700],
//                    size: 30,
//                  )
//                ],
//              ),
//            ),
//          ),
//          GestureDetector(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => secondWidget,
//                ),
//              );
//            },
//            child: Container(
//              decoration: BoxDecoration(
//                  color: Color(0xfff2f2f2),
//                  borderRadius: BorderRadius.circular(25),
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.white,
//                      offset: Offset(-3, -3),
//                      blurRadius: 3,
//                      spreadRadius: 3,
//                    ),
//                    BoxShadow(
//                      color: Colors.grey[300],
//                      offset: Offset(3, 3),
//                      blurRadius: 3,
//                      spreadRadius: 3,
//                    ),
//                  ]),
//              width: MediaQuery.of(context).size.width * 0.4,
//              height: MediaQuery.of(context).size.width * 0.3,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    secondChild ?? '',
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 18.0,
//                      color: Colors.blue[700],
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  Icon(
//                    secondIcon,
//                    color: Colors.blue[700],
//                    size: 30,
//                  )
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//Scaffold(
//      backgroundColor: Color(0xfff2f2f2),
//      body: SafeArea(
//        child: Container(
//          child: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: 10,
//                ),
//                Holder(
//                  firstChild: 'العاصمة للتسويق الرقمي',
//                  firstWidget: AsimaMarketing(),
//                  firstIcon: Icons.shopping_basket,
//                  secondChild: 'استماع فوري لإذاعة العاصمة',
//                  secondIcon: Icons.headset,
//                  secondWidget: RadioAsima(),
//                ),
//                Holder(
//                  firstChild: 'آخر الأخبار',
//                  firstWidget: AsimaNews(),
//                  firstIcon: Icons.assignment,
//                  secondChild: 'أسعار العملات',
//                  secondIcon: Icons.monetization_on,
//                  secondWidget: CurrencyExchanger(),
//                ),
//                Holder(
//                  firstChild: 'دليل الأعمال',
//                  firstWidget: AsimaBusiness(),
//                  firstIcon: Icons.business_center,
//                  secondChild: 'سؤال وجواب',
//                  secondIcon: Icons.question_answer,
//                  secondWidget: QuestionAnswerScreen(),
//                ),
//                Holder(
//                  firstChild: 'فرص عمل',
//                  firstWidget: JobChancesScreen(),
//                  firstIcon: Icons.search,
//                  secondChild: 'ملتقى الأفكار والاستثمار',
//                  secondIcon: Icons.attach_money,
//                  secondWidget: IdeasInvestmentScreen(),
//                ),
//                Holder(
//                  firstChild: 'الدردشة',
//                  firstWidget: ChatScreen(),
//                  firstIcon: Icons.chat_bubble,
//                  secondChild: 'من نحن',
//                  secondIcon: Icons.error,
//                  secondWidget: AboutUs(),
//                ),
//                Holder(
//                  firstIcon: Icons.clear_all,
//                  firstChild: 'تواصل معنا',
//                  firstWidget: ContactWithUs(),
//                  secondWidget: AsimaBooks(),
//                  secondIcon: Icons.book,
//                  secondChild: 'كتابك على باب منزلك',
//                ),
//                Holder(
//                  firstWidget: SignIn(),
//                  firstChild: 'تسجيل الدخول',
//                  firstIcon: Icons.input,
//                  secondChild: 'الصفحة الشخصية',
//                  secondIcon: Icons.person,
//                  secondWidget: ProfileScreen(),
//                ),
//                SizedBox(
//                  height: 10,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
