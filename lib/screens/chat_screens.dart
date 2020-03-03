import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800],
          ),
          title: Text(
            'صفحة الدردشة',
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xfff2f2f2),
          elevation: 0,
        ),
        body: Provider.of<ProviderData>(context).currentUserId == null
            ? Column(
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
              )
            : Container(
                color: Color(0xfff2f2f2),
                child: FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder:
                      // ignore: missing_return
                      (context, AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.data.get('first_chat_open') == null ||
                        snapshot.data.get('first_chat_open') == true) {
                      return WelcomeScreen();
                    } else if (!snapshot.data.get('first_chat_open')) {
                      return ChatList();
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ));
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'الدردشة فرصة لقضاء الحوائج وتبادل الأفكار: يتم متابعة جميع الرسائل وسيتم حذف أي مراسلات غير اخلاقية او غير قانونية وحظر أصحابها ويكون لوحده مسؤولا عنها لحين حذفها.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              color: Colors.white,
              child: Text('الدخول لغرفة الدردشة'),
              onPressed: () async {
                SharedPreferences _pref = await SharedPreferences.getInstance();
                _pref.setBool('first_chat_open', false);
                Navigator.pushReplacementNamed(context, ChatScreen.id);
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

final FocusNode _focusNode = new FocusNode();
final TextEditingController _messageField = new TextEditingController();
String message;

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder(
            stream:
                chatRoomRef.orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        userData: snapshot.data.documents[index]);
                  },
                ),
              );
            },
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  DatabaseService.sendMessage(
                      message,
                      Provider.of<ProviderData>(context, listen: false)
                          .currentUserId);
                  _messageField.clear();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                color: Colors.blue,
              ),
              Expanded(
                child: TextField(
                  onChanged: (input) {
                    message = input;
                  },
                  controller: _messageField,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    labelText: 'أرسل رسالة',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final userData;
  MessageTile({this.userData});

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ProviderData>(context).currentUserId;
    String sender = userData['author'].toString().trim();
    return FutureBuilder(
        future: DatabaseService.getUserInfo(sender),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(),
            );
          }
          return Align(
            alignment:
                userId == sender ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: userId == sender
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Text(
                    snapshot.data['name'],
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: userId.trim() == sender
                            ? Radius.circular(15)
                            : Radius.circular(0),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: userId == sender
                            ? Radius.circular(0)
                            : Radius.circular(15),
                      ),
                      color: userId == sender ? Colors.blue : Colors.grey[300],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userData['message'],
                        style: TextStyle(
                          color: userId == sender
                              ? Colors.white
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
