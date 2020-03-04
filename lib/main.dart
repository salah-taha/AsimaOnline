import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/screens/chat_screens.dart';
import 'package:asima_online/screens/home.dart';
import 'package:asima_online/screens/ideas_investment_screen.dart';
import 'package:asima_online/screens/job_chances_screen.dart';
import 'package:asima_online/screens/question_answer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
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
        AsimaBusiness.id: (context) => AsimaBusiness(),
        QuestionAnswerScreen.id: (context) => QuestionAnswerScreen(),
        JobChancesScreen.id: (context) => JobChancesScreen(),
        IdeasInvestmentScreen.id: (context) => IdeasInvestmentScreen(),
        HomePage.id: (context) => HomePage(),
      },
    );
  }
}
