import 'package:asima_online/models/business_card_model.dart';
import 'package:asima_online/models/user.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//asima business screen
class AsimaBusiness extends StatefulWidget {
  static String id = 'asima_business';
  @override
  _AsimaBusinessState createState() => _AsimaBusinessState();
}

class _AsimaBusinessState extends State<AsimaBusiness> {
  //cards reference from firebase
  Future<QuerySnapshot> _cards = businessRef.getDocuments();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Text(
                  'بإنتظار الموافقة',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'تمت الموافقة',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[800],
            ),
            title: Text(
              'دليل الأعمال',
              style: TextStyle(color: Colors.grey[800]),
            ),
            centerTitle: true,
            backgroundColor: Color(0xfff2f2f2),
            elevation: 0,
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                future: _cards,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List docs = List();
                  snapshot.data.documents.forEach((doc) {
                    if (doc['approved'] == false) {
                      docs.add(doc);
                    }
                  });
                  if (docs.length == 0) {
                    return Center(
                      child: Text('لا يوجد خدمات الأن'),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      BusinessCardModel _businessCardModel =
                          BusinessCardModel.fromDoc(docs[index]);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardInfo(
                                  _businessCardModel,
                                  approved: false,
                                ),
                              ));
                        },
                        child: BusinessCardWidget(
                          isGroup:
                              _businessCardModel.type == 'فرد' ? false : true,
                          title: _businessCardModel.title,
                          address: _businessCardModel.address[0] +
                              ',' +
                              _businessCardModel.address[1],
                          imageSource: _businessCardModel.mainImage,
                          description: _businessCardModel.description,
                        ),
                      );
                    },
                  );
                },
              ),
              FutureBuilder(
                future: _cards,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List docs = List();
                  snapshot.data.documents.forEach((doc) {
                    if (doc['approved'] == true) {
                      docs.add(doc);
                    }
                  });
                  if (docs.length == 0) {
                    return Center(
                      child: Text('لا يوجد خدمات الأن'),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      BusinessCardModel _businessCardModel =
                          BusinessCardModel.fromDoc(docs[index]);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardInfo(
                                  _businessCardModel,
                                  approved: true,
                                ),
                              ));
                        },
                        child: BusinessCardWidget(
                          isGroup:
                              _businessCardModel.type == 'فرد' ? false : true,
                          title: _businessCardModel.title,
                          address: _businessCardModel.address[0] +
                              ',' +
                              _businessCardModel.address[1],
                          imageSource: _businessCardModel.mainImage,
                          description: _businessCardModel.description,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}

//business card
class BusinessCardWidget extends StatelessWidget {
  final isGroup;
  final String imageSource;
  final title;
  final address;
  final description;
  BusinessCardWidget(
      {this.isGroup = true,
      this.imageSource,
      this.address,
      this.title,
      this.description});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          width: width * 0.9,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(
              0xfff2f2f2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(1, 3),
                blurRadius: 6,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-1, -3),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width * 0.3,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(1, 3),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-1, -3),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imageSource),
                    fit: BoxFit.cover,
                  ),
                  color: Color(0xfff2f2f2),
                ),
              ),
              Container(
                width: width * 0.47,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      isGroup ? Icons.group : Icons.person,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class CardInfo extends StatelessWidget {
  final BusinessCardModel cardModel;
  final approved;
  CardInfo(this.cardModel, {this.approved});
  @override
  Widget build(BuildContext context) {
    _userInfo() async {
      DocumentSnapshot userDoc = await DatabaseService.getUserInfo('admin');
      User user = User.fromDoc(userDoc);
      return user;
    }

    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        title: Text(
          cardModel.title,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
      ),
      floatingActionButton: !approved
          ? FloatingActionButton(
              onPressed: () async {
                await DatabaseService.approveBusiness(cardModel.id, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AsimaBusiness.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.check,
                color: Colors.grey[800],
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                await DatabaseService.deleteBusiness(cardModel.id, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AsimaBusiness.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.delete,
                color: Colors.grey[800],
              ),
            ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  cardModel.mainImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  color: Color(
                    0xfff2f2f2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                        blurRadius: 4),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -3),
                        spreadRadius: 2,
                        blurRadius: 4),
                  ]),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    cardModel.secondaryImages[0] != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                cardModel.secondaryImages[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : null,
                    cardModel.secondaryImages[1] != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                cardModel.secondaryImages[1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : null,
                    cardModel.secondaryImages[2] != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                cardModel.secondaryImages[2],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : null,
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: _userInfo(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(
                        0xfff2f2f2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 4),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -3),
                            spreadRadius: 2,
                            blurRadius: 4),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      CircleAvatar(
                        backgroundImage: snapshot.data.profileImageUrl.isEmpty
                            ? AssetImage('assets/Portrait_Placeholder.png')
                            : CachedNetworkImageProvider(
                                snapshot.data.profileImageUrl,
                              ),
                        radius: MediaQuery.of(context).size.width * 0.09,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(snapshot.data.name),
                            Text(snapshot.data.type == 'individual'
                                ? 'فرد'
                                : 'شركة'),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(
                    0xfff2f2f2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                        blurRadius: 4),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -3),
                        spreadRadius: 2,
                        blurRadius: 4),
                  ]),
              child: Column(
                children: <Widget>[
                  Text('الوصف: '),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 10,
                    ),
                    child: Text(
                      cardModel.description,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Text('العنوان: '),
                        Text(cardModel.address[0] + ',' + cardModel.address[1]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
