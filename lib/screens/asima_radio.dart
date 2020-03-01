import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioAsima extends StatefulWidget {
  static String id = 'radio_asima';

  @override
  _RadioAsimaState createState() => _RadioAsimaState();
}

class _RadioAsimaState extends State<RadioAsima> {
  String url = "https://asima.out.airtime.pro/asima_a";
  String switcher;
  @override
  void initState() {
    super.initState();
    _initializeSwitcher();
  }

  _initializeSwitcher() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String switcher = preferences.getString('switch') ?? 'false';
    setState(() {
      this.switcher = switcher;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'استماع فوري إلى إذاعة العاصمة اونلاين',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  switcher == 'true'
                      ? 'أنت الأن تستمع إلى إذاعة العاصمة اونلاين'
                      : 'استمع إلى إذاعة العاصمة اونلاين',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: switcher == 'true' ? Colors.blue : Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Center(
                child: FlatButton(
                  shape: Border(),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (switcher == 'true') {
                      FlutterRadio.stop();
                      setState(() {
                        switcher = 'false';
                        pref.setString('switch', 'false');
                      });
                    } else {
                      FlutterRadio.playOrPause(url: url);
                      setState(() {
                        switcher = 'true';
                        pref.setString('switch', 'true');
                      });
                    }
                  },
                  color: switcher == 'true' ? Colors.blue : Colors.grey[900],
                  child: Icon(
                    switcher == 'true' ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
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
