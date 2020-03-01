import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signup_screen.dart';
import 'package:asima_online/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  static String id = 'Sign_in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formController = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isLoading = false;
  _handleSignInWithEmail() {
    if (_formController.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formController.currentState.save();
      //login
      AuthService.signInWithEmail(context, _email, _password);
    }
  }

  _signInWithGoogle() {
    setState(() {
      isLoading = true;
    });
    AuthService.signWithGoogle(context);
  }

  _signInWithFacebook() {
    setState(() {
      isLoading = true;
    });
    AuthService.signWithFacebook(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: Color(0xfff2f2f2),
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Provider.of<ProviderData>(context).currentUserId != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'تم تسجيل الدخول بنجاح',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () => AuthService.logout(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    color: Colors.red,
                  ),
                ],
              )
            : isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[900],
                      child: Form(
                        key: _formController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Color(0xfff2f2f2),
                              child: Image.asset(
                                'assets/Alasima Online Logo.png',
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                validator: (input) => !input.contains('@')
                                    ? 'بريد الكتروني غير صالح'
                                    : null,
                                onSaved: (input) {
                                  setState(() {
                                    _email = input;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'البريد الإلكتروني',
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  prefixIcon: Icon(Icons.mail_outline),
                                  filled: true,
                                  fillColor: Color(0xfff2f2f2),
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                validator: (input) => input.length < 6
                                    ? 'يجب أن تكون كلمة السر اكثر من 6 أحرف بدون مسافة'
                                    : null,
                                onSaved: (input) {
                                  setState(() {
                                    _password = input;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'كلمة السر',
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  prefixIcon: Icon(Icons.lock_outline),
                                  filled: true,
                                  fillColor: Color(0xfff2f2f2),
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.pushReplacementNamed(
                                    context, SignUp.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'إنشاء حساب جديد',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FlatButton(
                              onPressed: () => _handleSignInWithEmail(),
                              color: Colors.grey[900],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    color: Color(0xfff2f2f2),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30),
                                side: BorderSide(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: _signInWithFacebook,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xfff2f2f2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/facebook.png',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                GestureDetector(
                                  onTap: _signInWithGoogle,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xfff2f2f2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/google.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
