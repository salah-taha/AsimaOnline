import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        body: Container(
          color: Color(0xfff2f2f2),
          child: ChatList(),
        ));
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
                  DatabaseService.sendMessage(message, 'admin');
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
    String userId = 'admin';
    String sender = userData['author'].toString().trim();
    return FutureBuilder(
        future: DatabaseService.getUserInfo(sender),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(),
            );
          }
          return GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: 200.0,
                    width: 300.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            'تحذير',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'مسح هذه الرسالة ؟؟ ${userData['message']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  DatabaseService.deleteMessage(
                                      userData.documentID, context);
                                  Navigator.pop(context);
                                },
                                child: Text('مسح'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('الغاء'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Align(
              alignment: userId == sender
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: userId == sender
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
                    child: Text(
                      snapshot.data['name'],
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
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
                        color:
                            userId == sender ? Colors.blue : Colors.grey[300],
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
            ),
          );
        });
  }
}
