import 'dart:io';

import 'package:asima_online/models/country.dart';
import 'package:asima_online/models/idea_model.dart';
import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class IdeasInvestmentScreen extends StatefulWidget {
  static String id = 'ideas_investment_screen';

  @override
  _IdeasInvestmentScreenState createState() => _IdeasInvestmentScreenState();
}

class _IdeasInvestmentScreenState extends State<IdeasInvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
        title: Text(
          'ملتقى الأفكار والاستثمار',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      floatingActionButton:
          Provider.of<ProviderData>(context).currentUserId != '' &&
                  Provider.of<ProviderData>(context).currentUserId != null
              ? FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddIdeaScreen(),
                      ),
                    );
                    setState(() {});
                  },
                  splashColor: Colors.grey[800],
                  backgroundColor: Color(0xfff2f2f2),
                  child: Icon(
                    Icons.add,
                    color: Colors.grey[800],
                  ),
                )
              : null,
      body: Provider.of<ProviderData>(context).currentUserId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'يجب تسجيل الدخول أولا',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                    ),
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
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: DatabaseService.getIdeas(),
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
                    child: Text('لا يوجد أفكار حتي الأن'),
                  );
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Idea idea = Idea.fromDoc(docs[index]);
                    return IdeaCard(
                      idea: idea,
                    );
                  },
                );
              },
            ),
    );
  }
}

class IdeaCard extends StatefulWidget {
  final Idea idea;
  IdeaCard({this.idea});
  @override
  _IdeaCardState createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8,
      ),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewIdea(
                idea: widget.idea,
              ),
            ),
          );
          setState(() {});
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.23,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey[800],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.idea.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.idea.projectHolder,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'من',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('${widget.idea.minBudget}\$'),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'الي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('${widget.idea.maxBudget}\$'),
                    )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.idea.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddIdeaScreen extends StatefulWidget {
  @override
  _AddIdeaScreenState createState() => _AddIdeaScreenState();
}

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  Countries countriesClass = Countries();
  final _formController = GlobalKey<FormState>();
  String selectedCountry;
  int selectedCountryNum = 0;
  String selectedState;
  String _holderName;
  String _ideaTitle;
  String _ideaDescription;
  File _imageFile;
  String _imageUrl;
  String _minBudget;
  String _maxBudget;
  String _holderExp;
  String _notes;
  String _phoneNumber;
  String _holderEmail;
  bool error = false;
  bool isLoading = false;

  _handleUploadJob() async {
    if (_formController.currentState.validate()) {
      _formController.currentState.save();
      setState(() {
        isLoading = true;
      });
      StorageTaskSnapshot taskSnapshot =
          await StorageService.uploadIdeaImage(_imageFile);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      Idea _idea = Idea(
        title: _ideaTitle,
        description: _ideaDescription,
        country: selectedCountry,
        suggestedCity: selectedState,
        minBudget: _minBudget,
        maxBudget: _maxBudget,
        imageUrl: imageUrl,
        phoneNumber: _phoneNumber,
        email: _holderEmail,
        projectHolder: _holderName,
        holderExp: _holderExp,
        notes: _notes,
      );
      DatabaseService.uploadIdea(_idea);
      Navigator.pop(context);
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
                          'اضافة صور ثانوية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'تم ارسال العمل وبإنتظار الموافقة عليه من قبل الإدارة',
                          textAlign: TextAlign.center,
                        ),
                      ),
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
              ));
    }
  }

  _handleImageSelection() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      setState(() {
        _imageUrl = _imageFile.path.toString();
      });
    }
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'فكرة جديدة',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _handleImageSelection(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey[800],
                        image: DecorationImage(
                          image: AssetImage(
                            _imageUrl ?? 'assets/image-placeholder.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
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
                                    hint: Text('اختر الدولة'),
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
                        width: MediaQuery.of(context).size.width * 0.4,
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
                                    hint: Text('اختر المدينة'),
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
                    ],
                  ), //select place dropdown menu
                  Form(
                    key: _formController,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: TextFormField(
                            validator: (input) => input.trim().isEmpty
                                ? 'يجب ادخال اسم صاحب المشروع'
                                : null,
                            onSaved: (input) {
                              _holderName = input;
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'اسم صاحب المشروع',
                              labelStyle: TextStyle(color: Colors.white),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: TextFormField(
                            validator: (input) => !input.contains('@')
                                ? 'يجب ادخال ايميل صاحب المشروع'
                                : null,
                            onSaved: (input) {
                              _holderEmail = input;
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'ايميل صاحب المشروع',
                              labelStyle: TextStyle(color: Colors.white),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: TextFormField(
                            validator: (input) => input.trim().isEmpty
                                ? 'يجب ادخال عنوان المشروع'
                                : null,
                            onSaved: (input) {
                              _ideaTitle = input;
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'عنوان المشروع',
                              labelStyle: TextStyle(color: Colors.white),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                            validator: (input) => input.trim().isEmpty
                                ? 'يجب ادخال وصف المشروع'
                                : null,
                            onSaved: (input) {
                              _ideaDescription = input;
                            },
                            maxLines: 10,
                            maxLength: 350,
                            decoration: InputDecoration(
                              hintText: 'وصف المشروع',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                            validator: (input) => input.trim().isEmpty
                                ? 'يجب ادخال خبرات صاحب المشروع'
                                : null,
                            onSaved: (input) {
                              _holderExp = input;
                            },
                            maxLines: 10,
                            maxLength: 350,
                            decoration: InputDecoration(
                              hintText: 'خبرات صاحب المشروع',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15),
                          child: TextFormField(
                            onSaved: (input) {
                              _notes = input;
                            },
                            maxLines: 10,
                            maxLength: 350,
                            decoration: InputDecoration(
                              hintText: 'ملاحظات اضافية',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'ميزانية المشروع (بالدولار)',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                onSaved: (input) {
                                  _minBudget = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'من',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                onSaved: (input) {
                                  _maxBudget = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'الي',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8,
                          ),
                          child: TextFormField(
                            validator: (input) => input.trim().isEmpty
                                ? 'يجب ادخال رقم الهاتف'
                                : null,
                            onSaved: (input) {
                              _phoneNumber = input;
                            },
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: 'رقم الهاتف',
                              labelStyle: TextStyle(color: Colors.white),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          if (selectedCountry == null ||
                              selectedState == null ||
                              _imageFile == null) {
                            setState(() {
                              error = true;
                            });
                          } else {
                            _handleUploadJob();
                          }
                        },
                        color: Colors.grey[800],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'نشر',
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
                      error
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Center(
                                  child: Text(
                                    'يجب ملئ كافة الحقول الإجبارية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
    );
  }
}

class ViewIdea extends StatelessWidget {
  final Idea idea;
  ViewIdea({this.idea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        centerTitle: true,
        title: Text(
          idea.title,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(idea.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            '${idea.country},${idea.suggestedCity}',
                            style: TextStyle(
                              fontSize: 15,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.5
                                ..color = Colors.grey[800],
                            ),
                          ),
                          // Solid text as fill.
                          Text(
                            '${idea.country},${idea.suggestedCity}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            idea.projectHolder,
                            style: TextStyle(
                              fontSize: 30,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.grey[800],
                            ),
                          ),
                          // Solid text as fill.
                          Text(
                            idea.projectHolder,
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(-3, -3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'وصف المشروع',
                      style: TextStyle(
                        color: Color(0xfff2f2f2),
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        idea.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'خبرات صاحب المشروع',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        idea.holderExp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[900],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(-3, -3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'ملاحظات اضافية',
                      style: TextStyle(
                        color: Color(0xfff2f2f2),
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        idea.notes,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(3, 3),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -3),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                    ]),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'بريد التواصل',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        idea.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(-3, -3),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'رقم الهاتف',
                      style: TextStyle(
                        color: Color(0xfff2f2f2),
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        idea.phoneNumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(3, 3),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -3),
                        spreadRadius: 3,
                        blurRadius: 3,
                      ),
                    ]),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    Text(
                      'الميزانية',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'من',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                '${idea.minBudget}\$',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'الي',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                '${idea.maxBudget}\$',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
