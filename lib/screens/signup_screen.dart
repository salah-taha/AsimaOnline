import 'package:asima_online/services/auth_services.dart';
import 'package:flutter/material.dart';

enum Type { individual, company }

class SignUp extends StatefulWidget {
  static String id = 'Sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formController = GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  bool isLoading = false;
  Type _type = Type.individual;
  _handleSignUp() {
    String type;
    _type == Type.company ? type = 'company' : type = 'individual';

    if (_formController.currentState.validate()) {
      _formController.currentState.save();
      setState(() {
        isLoading = true;
      });
      //signUp user
      AuthService.signUpWithEmail(context, _name, _email, _password, type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Center(
          child: Text(
            'مستخدم جديد',
            style: TextStyle(
              color: Color(0xfff2f2f2),
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
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
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            validator: (input) =>
                                input.isEmpty || input.contains('admin')
                                    ? 'اسم المستخدم غير مناسب أو موجود مسبقاً'
                                    : null,
                            onSaved: (input) {
                              setState(() {
                                _name = input;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'اسم المستخدم',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              prefixIcon: Icon(Icons.person_outline),
                              filled: true,
                              fillColor: Color(0xfff2f2f2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            validator: (input) => !input.contains('@')
                                ? 'بريد الكتروني غير صالح'
                                : null,
                            onSaved: (input) {
                              setState(() {
                                _email = input.trim();
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
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            validator: (input) => input.trim().length < 6
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
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
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
                        Theme(
                          data: ThemeData.dark(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                activeColor: Color(0xfff2f2f2),
                                value: Type.individual,
                                groupValue: _type,
                                onChanged: (choose) {
                                  setState(() {
                                    _type = choose;
                                  });
                                },
                              ),
                              new Text(
                                'فرد',
                                style: new TextStyle(
                                    fontSize: 16.0, color: Color(0xfff2f2f2)),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              new Radio(
                                activeColor: Color(0xfff2f2f2),
                                value: Type.company,
                                groupValue: _type,
                                onChanged: (choose) {
                                  setState(() {
                                    _type = choose;
                                  });
                                },
                              ),
                              new Text(
                                'شركة',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xfff2f2f2),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FlatButton(
                          onPressed: () => _handleSignUp(),
                          color: Colors.grey[900],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'تسجيل',
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
                          height: 80,
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
