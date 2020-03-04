import 'dart:io';

import 'package:asima_online/models/business_card_model.dart';
import 'package:asima_online/models/country.dart';
import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/models/user.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/services/storage_service.dart';
import 'package:asima_online/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

//asima business screen
class AsimaBusiness extends StatefulWidget {
  static String id = 'asima_business';
  @override
  _AsimaBusinessState createState() => _AsimaBusinessState();
}

class _AsimaBusinessState extends State<AsimaBusiness> {
  //selected country and state variables
  Countries countriesClass = Countries();
  var selectedCountry;
  var selectedCountryNum = 0;
  String selectedState;
  String selectedType;
  //cards reference from firebase
  Future<QuerySnapshot> _cards =
      cardsRef.orderBy('timestamp', descending: true).getDocuments();

  //converting countries list to dropdown items
  List<DropdownMenuItem<String>> _convertToItems(List<dynamic> data) {
    List<DropdownMenuItem<String>> items =
        data.map<DropdownMenuItem<String>>((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
    return items;
  }

  @override
  void dispose() {
    super.dispose();
    selectedType = null;
    selectedState = null;
    selectedCountry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Color(0xfff2f2f2),
              size: 30,
            ),
            elevation: 3,
            backgroundColor: Colors.grey[800],
            onPressed: () async {
              //goes to adding business screen
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddingBusinessCardPage(),
                  ));
              setState(() {});
            },
          ),
          SizedBox(
            height: 10,
          ),
          selectedType != null ||
                  selectedState != null ||
                  selectedCountry != null
              ? FloatingActionButton(
                  child: Icon(
                    Icons.clear,
                    color: Color(0xfff2f2f2),
                    size: 30,
                  ),
                  elevation: 3,
                  backgroundColor: Colors.grey[800],
                  onPressed: () {
                    setState(() {
                      selectedState = null;
                      selectedCountry = null;
                      selectedType = null;
                    });
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
                      offset: Offset(-1, -4),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ]),
              height: 70,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: FutureBuilder(
                      future: countriesClass.getCountries(),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        List<DropdownMenuItem<String>> items =
                            _convertToItems(snapshot.data);
                        return DropdownButtonHideUnderline(
                          child: Container(
                            height: 60,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedCountry == null
                                        ? Colors.grey
                                        : Colors.blue,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                hint: Text('كل الدول'),
                                isExpanded: true,
                                value: selectedCountry,
                                items: items,
                                onChanged: (countryName) {
                                  setState(() {
                                    int num = 0;
                                    selectedCountry = countryName;
                                    for (String item in snapshot.data) {
                                      if (item == selectedCountry) {
                                        break;
                                      }
                                      num++;
                                    }
                                    selectedCountryNum = num;
                                    selectedState = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: FutureBuilder(
                      future: countriesClass.getStates(selectedCountryNum),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        List<DropdownMenuItem<String>> items =
                            _convertToItems(snapshot.data);

                        return DropdownButtonHideUnderline(
                          child: Container(
                            height: 60,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedState == null
                                        ? Colors.grey
                                        : Colors.blue,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                hint: Text('كل المدن'),
                                isExpanded: true,
                                value: selectedState ?? null,
                                items: items,
                                onChanged: (index) {
                                  setState(() {
                                    selectedState = index;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        height: 60,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: selectedType == null
                                    ? Colors.grey
                                    : Colors.blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            hint: Text('كل الأنشطة'),
                            isExpanded: true,
                            value: selectedType ?? null,
                            items: ['فرد', 'شركة']
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (index) {
                              setState(() {
                                selectedType = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.729,
            child: FutureBuilder(
              future: _cards,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List docs = List();
                snapshot.data.documents.forEach((doc) {
                  if (doc['address'][0].contains(selectedState ?? '') &&
                      doc['address'][1].contains(selectedCountry ?? '') &&
                      doc['type'].contains(selectedType ?? '') &&
                      doc['approved'] == true) {
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
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    BusinessCardModel _businessCardModel =
                        BusinessCardModel.fromDoc(docs[index]);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardInfo(_businessCardModel),
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
          )
        ],
      ),
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
  CardInfo(this.cardModel);
  @override
  Widget build(BuildContext context) {
    _userInfo() async {
      DocumentSnapshot userDoc =
          await DatabaseService.getUserInfo(cardModel.author);
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

class Images {
  File imageFile;
  String imageUrl;
  Images({this.imageFile, this.imageUrl});
}

class AddingBusinessCardPage extends StatefulWidget {
  @override
  _AddingBusinessCardPageState createState() => _AddingBusinessCardPageState();
}

class _AddingBusinessCardPageState extends State<AddingBusinessCardPage> {
  final _formKey = GlobalKey<FormState>();

  Countries countriesClass = Countries();
  var selectedCountry;
  var selectedCountryNum = 0;
  String selectedState;
  String selectedType;
  String mainPhotoUrl;
  File mainImageFile;
  String photo1Url;
  File photo1File;
  String photo2Url;
  File photo2File;
  String photo3Url;
  File photo3File;
  String url_1;
  String url_2;
  String url_3;
  String serviceName;
  String serviceDescription;
  bool isUploading = false;

  List<DropdownMenuItem<String>> _convertToItems(List<dynamic> data) {
    List<DropdownMenuItem<String>> items =
        data.map<DropdownMenuItem<String>>((value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
    return items;
  }

  void _handleServiceAddition(BuildContext context) async {
    if (selectedCountry == null ||
        selectedState == null ||
        selectedType == null ||
        (photo1File == null && photo2File == null && photo3File == null)) {
      Dialog fancyDialog = Dialog(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'يجب اختيار العنوان ونوع الخدمة واضافة صورة ثانوية واحدة علي الأقل',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('تم'),
                ),
              )
            ],
          ),
        ),
      );
      showDialog(
          context: context, builder: (BuildContext context) => fancyDialog);
    } else if (_formKey.currentState.validate() && mainImageFile != null) {
      _formKey.currentState.save();
      setState(() {
        isUploading = true;
      });

      StorageTaskSnapshot taskSnapshot =
          await StorageService.uploadBusinessImage(mainImageFile);

      mainPhotoUrl = await taskSnapshot.ref.getDownloadURL();
      if (photo1File != null) {
        taskSnapshot = await StorageService.uploadBusinessImage(photo1File);

        photo1Url = await taskSnapshot.ref.getDownloadURL();
      }
      if (photo2File != null) {
        taskSnapshot = await StorageService.uploadBusinessImage(photo2File);

        photo2Url = await taskSnapshot.ref.getDownloadURL();
      }
      if (photo3File != null) {
        taskSnapshot = await StorageService.uploadBusinessImage(photo3File);

        photo3Url = await taskSnapshot.ref.getDownloadURL();
      }
      BusinessCardModel model = BusinessCardModel(
          author:
              Provider.of<ProviderData>(context, listen: false).currentUserId,
          id: Uuid().v4(),
          links: [url_1 ?? '', url_2 ?? '', url_3 ?? ''],
          title: serviceName,
          type: selectedType,
          description: serviceDescription,
          mainImage: mainPhotoUrl,
          address: [selectedState, selectedCountry],
          secondaryImages: _handleSecondaryImages());
      DatabaseService.uploadBusinessCard(model, context);
    }
  }

  List _handleSecondaryImages() {
    return [
      photo1Url ?? photo2Url ?? photo3Url ?? '',
      photo1Url == null && photo2Url == null
          ? ''
          : photo2Url ?? photo3Url ?? '',
      photo2Url == null ? '' : photo3Url ?? ''
    ];
  }

  // ignore: missing_return
  Future<Images> _handleImageSelection() async {
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      String _imageUrl = _imageFile.path.toString();

      return new Images(imageUrl: _imageUrl, imageFile: _imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget urlField(Function onSaved) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextFormField(
          onSaved: onSaved,
          decoration: InputDecoration(
            hintText: 'رابط توضيحي',
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: Icon(Icons.link),
            filled: true,
            fillColor: Color(0xfff2f2f2),
          ),
          textDirection: TextDirection.ltr,
        ),
      );
    }

    List<Widget> addUrl = [
      urlField((input) {
        setState(() {
          url_1 = input;
        });
      }),
      urlField((input) {
        setState(() {
          url_2 = input;
        });
      }),
      urlField((input) {
        setState(() {
          url_3 = input;
        });
      }),
    ];

    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          title: Text(
            'إضافة دليل أعمال جديد',
            style: TextStyle(color: Colors.grey[800]),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xfff2f2f2),
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey[800],
          ),
        ),
        body: Provider.of<ProviderData>(context).currentUserId == null ||
                Provider.of<ProviderData>(context).currentUserId == ''
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'يجب تسجيل الدخول أولا',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    FlatButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignIn(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      color: Colors.grey[800],
                    )
                  ],
                ),
              )
            : !isUploading
                ? Container(
                    color: Color(0xfff2f2f2),
                    child: Flex(
                        direction: Axis.vertical,
                        verticalDirection: VerticalDirection.down,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Images image =
                                            await _handleImageSelection();
                                        setState(() {
                                          if (image != null) {
                                            mainPhotoUrl = image.imageUrl;
                                            mainImageFile = image.imageFile;
                                          }
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          image: mainPhotoUrl != null
                                              ? DecorationImage(
                                                  image:
                                                      AssetImage(mainPhotoUrl),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: mainPhotoUrl == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.add_a_photo,
                                                    size: 50,
                                                    color: Colors.grey[800],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'اضغط لإضافة الصورة الرئيسية',
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey[800],
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        onPressed: () {
                                          Dialog fancyDialog = Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              height: 250.0,
                                              width: 300.0,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15.0),
                                                    child: Text(
                                                      'اضافة صور ثانوية',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              Images image =
                                                                  await _handleImageSelection();
                                                              if (image !=
                                                                  null) {
                                                                setState(() {
                                                                  photo1Url = image
                                                                      .imageUrl;
                                                                  photo1File = image
                                                                      .imageFile;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 80,
                                                              width: 80,
                                                              child:
                                                                  Image.asset(
                                                                photo1Url ??
                                                                    'assets/image-placeholder.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              Images image =
                                                                  await _handleImageSelection();
                                                              if (image !=
                                                                  null) {
                                                                setState(() {
                                                                  photo2Url = image
                                                                      .imageUrl;
                                                                  photo2File = image
                                                                      .imageFile;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 80,
                                                              height: 80,
                                                              child:
                                                                  Image.asset(
                                                                photo2Url ??
                                                                    'assets/image-placeholder.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              Images image =
                                                                  await _handleImageSelection();
                                                              if (image !=
                                                                  null) {
                                                                setState(() {
                                                                  photo3Url = image
                                                                      .imageUrl;
                                                                  photo3File = image
                                                                      .imageFile;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 80,
                                                              height: 80,
                                                              child:
                                                                  Image.asset(
                                                                photo3Url ??
                                                                    'assets/image-placeholder.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('تم'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  fancyDialog);
                                        },
                                        color: Color(0xfff2f2f2),
                                        splashColor: Colors.grey[900],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'اضغط لإضافة صور ثانوية',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: FutureBuilder(
                                            future:
                                                countriesClass.getCountries(),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              List<DropdownMenuItem<String>>
                                                  items = _convertToItems(
                                                      snapshot.data);
                                              return DropdownButtonHideUnderline(
                                                child: Container(
                                                  height: 40,
                                                  decoration: ShapeDecoration(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              selectedCountry ==
                                                                      null
                                                                  ? Colors.grey
                                                                  : Colors.blue,
                                                          width: 1.0,
                                                          style: BorderStyle
                                                              .solid),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DropdownButton(
                                                      hint: Text('الدولة'),
                                                      isExpanded: true,
                                                      value: selectedCountry,
                                                      items: items,
                                                      onChanged: (countryName) {
                                                        setState(() {
                                                          int num = 0;
                                                          selectedCountry =
                                                              countryName;
                                                          for (String item
                                                              in snapshot
                                                                  .data) {
                                                            if (item ==
                                                                selectedCountry) {
                                                              break;
                                                            }
                                                            num++;
                                                          }
                                                          selectedCountryNum =
                                                              num;
                                                          selectedState = null;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: FutureBuilder(
                                            future: countriesClass
                                                .getStates(selectedCountryNum),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              List<DropdownMenuItem<String>>
                                                  items = _convertToItems(
                                                      snapshot.data);

                                              return DropdownButtonHideUnderline(
                                                child: Container(
                                                  height: 40,
                                                  decoration: ShapeDecoration(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              selectedState ==
                                                                      null
                                                                  ? Colors.grey
                                                                  : Colors.blue,
                                                          width: 1.0,
                                                          style: BorderStyle
                                                              .solid),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DropdownButton(
                                                      hint: Text('المدينة'),
                                                      isExpanded: true,
                                                      value:
                                                          selectedState ?? null,
                                                      items: items,
                                                      onChanged: (index) {
                                                        setState(() {
                                                          selectedState = index;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.28,
                                          child: DropdownButtonHideUnderline(
                                            child: Container(
                                              height: 40,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color:
                                                          selectedType == null
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: DropdownButton(
                                                  hint: Text('النشاط'),
                                                  isExpanded: true,
                                                  value: selectedType ?? null,
                                                  items: ['فرد', 'شركة'].map<
                                                      DropdownMenuItem<
                                                          String>>((value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (index) {
                                                    setState(() {
                                                      selectedType = index;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: TextFormField(
                                              validator: (input) => input
                                                      .isEmpty
                                                  ? 'اسم الخدمة يجب ألا يكون فارغاً'
                                                  : null,
                                              onSaved: (input) {
                                                setState(() {
                                                  serviceName = input;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'اسم الخدمة',
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                prefixIcon:
                                                    Icon(Icons.assignment),
                                                filled: true,
                                                fillColor: Color(0xfff2f2f2),
                                              ),
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: TextFormField(
                                              validator: (input) => input
                                                          .trim()
                                                          .length <
                                                      1
                                                  ? 'يجب ألا يكون وصف الخدمة فارغا'
                                                  : null,
                                              onSaved: (input) {
                                                setState(() {
                                                  serviceDescription = input;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'وصف الخدمة',
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.blue,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                prefixIcon:
                                                    Icon(Icons.description),
                                                filled: true,
                                                fillColor: Color(0xfff2f2f2),
                                              ),
                                              textDirection: TextDirection.ltr,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            children: addUrl,
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              _handleServiceAddition(context);
                                            },
                                            color: Colors.grey[900],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'اضافة الخدمة',
                                                style: TextStyle(
                                                  color: Color(0xfff2f2f2),
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(30),
                                              side: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )
                : Container(
                    color: Color(0xfff2f2f2),
                    child: Center(child: CircularProgressIndicator())));
  }
}
