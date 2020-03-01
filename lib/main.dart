import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/about_us.dart';
import 'package:asima_online/screens/asima_books.dart';
import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/screens/asima_news.dart';
import 'package:asima_online/screens/asima_radio.dart';
import 'package:asima_online/screens/chat_screens.dart';
import 'package:asima_online/screens/contact_with_us.dart';
import 'package:asima_online/screens/home.dart';
import 'package:asima_online/screens/ideas_investment_screen.dart';
import 'package:asima_online/screens/job_chances_screen.dart';
import 'package:asima_online/screens/profile_screen.dart';
import 'package:asima_online/screens/question_answer.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/asima_marketing_webview.dart';
import 'screens/currency_exchange.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//  Widget _isUserSigned() {
//    return StreamBuilder<FirebaseUser>(
//      stream: FirebaseAuth.instance.onAuthStateChanged,
//      // ignore: missing_return
//      builder: (BuildContext context, snapshot) {
//        if (snapshot.hasData) {
//          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
//        } else {
////          TODO remove user
//        }
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => ProviderData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale: Locale("fa", "IR"),
        title: 'العاصمة اونلاين',
        initialRoute: HomePage.id,
        routes: {
          ChatScreen.id: (context) => ChatScreen(),
          SignIn.id: (context) => SignIn(),
          CurrencyExchanger.id: (context) => CurrencyExchanger(),
          AsimaMarketing.id: (context) => AsimaMarketing(),
          AsimaNews.id: (context) => AsimaNews(),
          RadioAsima.id: (context) => RadioAsima(),
          SignUp.id: (context) => SignUp(),
          ProfileScreen.id: (context) => ProfileScreen(),
          AsimaBusiness.id: (context) => AsimaBusiness(),
          QuestionAnswerScreen.id: (context) => QuestionAnswerScreen(),
          JobChancesScreen.id: (context) => JobChancesScreen(),
          IdeasInvestmentScreen.id: (context) => IdeasInvestmentScreen(),
          ContactWithUs.id: (context) => ContactWithUs(),
          AboutUs.id: (context) => AboutUs(),
          AsimaBooks.id: (context) => AsimaBooks(),
          HomePage.id: (context) => HomePage(),
        },
      ),
    );
  }
}

//TODO: set provider at app start

Future<String> getUserId(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Provider.of<ProviderData>(context).currentUserId =
      sharedPreferences.getString('userId');
  return sharedPreferences.getString('userId');
}
