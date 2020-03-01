import 'dart:io';

import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/models/user.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/auth_services.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/services/storage_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<ProviderData>(context).currentUserId == null
        ? Scaffold(
            backgroundColor: Color(0xfff2f2f2),
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'الصفحة الشخصية',
                style: TextStyle(
                  color: Colors.grey[800],
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0xfff2f2f2),
              iconTheme: IconThemeData(
                color: Colors.grey[800],
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text('يجب تسجيل الدخول أولا'),
                ),
                FlatButton(
                  color: Colors.grey[800],
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ),
                    );
                    setState(() {});
                  },
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        : FutureBuilder(
            future: usersRef
                .document(Provider.of<ProviderData>(context).currentUserId)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              Widget _getBody() {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 80,
                          backgroundImage: snapshot
                                      .data.data['profileImageUrl'] ==
                                  ''
                              ? AssetImage('assets/Portrait_Placeholder.png')
                              : CachedNetworkImageProvider(
                                  snapshot.data.data['profileImageUrl'],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data.data['name'],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person_pin,
                              color:
                                  snapshot.data.data['userType'] == 'individual'
                                      ? Colors.blue
                                      : Colors.grey,
                              size: 50,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Icon(
                              Icons.group_work,
                              color:
                                  snapshot.data.data['userType'] != 'individual'
                                      ? Colors.blue
                                      : Colors.grey,
                              size: 50,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.grey[800],
                            onPressed: () {
                              AuthService.logout(context);
                            },
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
                          ),
                          FlatButton(
                            color: Colors.grey[800],
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    user: User.fromDoc(snapshot.data),
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'تعديل البيانات',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }

              return Scaffold(
                  backgroundColor: Color(0xfff2f2f2),
                  appBar: AppBar(
                    elevation: 0,
                    title: Text(
                      'الصفحة الشخصية',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                    centerTitle: true,
                    iconTheme: IconThemeData(
                      color: Colors.grey[800],
                    ),
                    backgroundColor: Color(0xfff2f2f2),
                  ),
                  body: _getBody());
            },
          );
  }
}

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name;
  File image;
  String imageUrl;
  String localImage;
  String type;
  bool isLoading = false;

  _handleImageSelection() async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = _image;
      });
      return _image.path;
    }
    return null;
  }

  _handleEditProfile(
      String mainName, String mainType, String mainImageUrl) async {
    if (image != null ||
        (type != mainType && type != null) ||
        (name != mainName && name != null)) {
      setState(() {
        isLoading = true;
      });
      if (image != null) {
        imageUrl = await StorageService.uploadUserProfileImage(image);
      }

      final User user = User(
          name: name ?? mainName,
          profileImageUrl: imageUrl ?? mainImageUrl,
          type: type ?? mainType,
          id: widget.user.id,
          email: widget.user.email);
      await DatabaseService.userUpdate(user);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'تعديل البيانات الشخصية',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          String _image = await _handleImageSelection();
                          setState(() {
                            localImage = _image;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 80,
                          backgroundImage: localImage != null
                              ? AssetImage(localImage)
                              : widget.user.profileImageUrl == ''
                                  ? AssetImage(
                                      'assets/Portrait_Placeholder.png',
                                    )
                                  : CachedNetworkImageProvider(
                                      widget.user.profileImageUrl,
                                    ),
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        initialValue: widget.user.name,
                        validator: (input) => input.isEmpty
                            ? 'اسم المستخدم غير مناسب أو موجود مسبقاً'
                            : null,
                        onChanged: (input) {
                          setState(() {
                            name = input;
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
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Theme(
                      data: ThemeData.dark(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            activeColor: Color(0xfff2f2f2),
                            value: 'individual',
                            groupValue: type,
                            onChanged: (choose) {
                              setState(() {
                                type = choose;
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
                            value: 'company',
                            groupValue: type,
                            onChanged: (choose) {
                              setState(() {
                                type = choose;
                              });
                            },
                          ),
                          new Text(
                            'شركة',
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FlatButton(
                      onPressed: () async {
                        await _handleEditProfile(widget.user.name,
                            widget.user.type, widget.user.profileImageUrl);
                      },
                      color: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'حفظ',
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
                  ],
                ),
              ),
            ),
    );
  }
}
