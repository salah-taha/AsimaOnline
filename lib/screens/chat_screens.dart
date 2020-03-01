import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  future: chatRoomsRef.getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ChatCard.fromDoc(snapshot.data.documents[index]);
                      },
                    );
                  },
                ),
              ));
  }
}

class ChatCard extends StatelessWidget {
  final image;
  final title;
  final docId;

  ChatCard({this.title, this.image, this.docId});

  factory ChatCard.fromDoc(DocumentSnapshot doc) {
    return ChatCard(
      image: doc['image'],
      title: doc['name'],
      docId: doc.documentID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatList(
                        docId: docId,
                        roomName: title,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(
                0xfff2f2f2,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[400],
                    offset: Offset(3, 3),
                    blurRadius: 4,
                    spreadRadius: 2),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 4,
                    spreadRadius: 2),
              ]),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: MediaQuery.of(context).size.width * 0.1,
                  backgroundImage: CachedNetworkImageProvider(image),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatList extends StatefulWidget {
  final docId;
  final roomName;
  ChatList({
    this.docId,
    this.roomName,
  });

  @override
  _ChatListState createState() => _ChatListState();
}

final FocusNode _focusNode = new FocusNode();
final TextEditingController _messageField = new TextEditingController();
String message;

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder(
              stream: chatRoomsRef
                  .document(widget.docId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
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
                        widget.docId,
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
