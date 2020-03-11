import 'dart:io';

import 'package:asima_online/models/country.dart';
import 'package:asima_online/models/job_chance_model.dart';
import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:asima_online/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class JobChancesScreen extends StatefulWidget {
  static String id = 'job_chances';

  @override
  _JobChancesScreenState createState() => _JobChancesScreenState();
}

class _JobChancesScreenState extends State<JobChancesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'فرص عمل',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJobScreen(),
            ),
          );
          Navigator.popAndPushNamed(context, JobChancesScreen.id);
        },
        child: Icon(
          Icons.add,
          color: Colors.grey[800],
        ),
        splashColor: Colors.grey[600],
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: FutureBuilder(
        future: DatabaseService.getJobChancesDocs(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text('لا يوجد فرص عمل الأن'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              JobChance jobChance = JobChance.fromDoc(docs[index]);
              return JobChanceCard(
                jobChance: jobChance,
              );
            },
          );
        },
      ),
    );
  }
}

class ViewJob extends StatelessWidget {
  final JobChance jobChance;
  ViewJob({this.jobChance});

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
          jobChance.title,
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
                    image: NetworkImage(jobChance.image),
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
                            '${jobChance.country},${jobChance.city}',
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
                            '${jobChance.country},${jobChance.city}',
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
                            jobChance.companyName,
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
                            jobChance.companyName,
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
                      'وصف الشاغر',
                      style: TextStyle(
                        color: Color(0xfff2f2f2),
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        jobChance.description,
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
                        jobChance.email,
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
                        jobChance.phoneNumber ?? '-',
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
                      'الراتب',
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${jobChance.salary}\$' ?? '-',
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
            ],
          ),
        ),
      ),
    );
  }
}

class JobChanceCard extends StatelessWidget {
  final JobChance jobChance;
  JobChanceCard({this.jobChance});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewJob(
              jobChance: jobChance,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[800],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[800],
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: Colors.grey[700],
                          offset: Offset(-1, -1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xfff2f2f2),
                      image: DecorationImage(
                        image: NetworkImage(jobChance.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.52,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          jobChance.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          jobChance.companyName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${jobChance.city},${jobChance.country}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          jobChance.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  Countries countriesClass = Countries();
  final _formController = GlobalKey<FormState>();
  String selectedCountry;
  int selectedCountryNum = 0;
  String selectedState;
  String _companyName;
  String _jobTitle;
  String _jobDescription;
  File _imageFile;
  String _imageUrl;
  String _salary;
  String _phoneNumber;
  String _companyEmail;
  bool error = false;
  bool isLoading = false;

  _handleUploadJob() async {
    if (_formController.currentState.validate()) {
      _formController.currentState.save();
      setState(() {
        isLoading = true;
      });
      StorageTaskSnapshot taskSnapshot =
          await StorageService.uploadBusinessImage(_imageFile);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      JobChance _jobChance = JobChance(
          salary: _salary,
          description: _jobDescription,
          image: imageUrl,
          title: _jobTitle,
          phoneNumber: _phoneNumber,
          email: _companyEmail,
          companyName: _companyName,
          country: selectedCountry,
          city: selectedState);
      DatabaseService.uploadJobChance(_jobChance);
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
        backgroundColor: Color(0xfff2f2f2),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'إضافة فرصة عمل',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Provider.of<ProviderData>(context).currentUserId == null
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
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'مكان العمل',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
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
                              future:
                                  countriesClass.getStates(selectedCountryNum),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
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
                                    ? 'يجب ادخال اسم الشركة'
                                    : null,
                                onSaved: (input) {
                                  _companyName = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'اسم الشركة',
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
                                    ? 'يجب ادخال ايميل الشركة'
                                    : null,
                                onSaved: (input) {
                                  _companyEmail = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'ايميل الشركة',
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
                                    ? 'يجب ادخال عنوان للشاغر'
                                    : null,
                                onSaved: (input) {
                                  _jobTitle = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'عنوان الشاغر',
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
                                    ? 'يجب ادخال وصف الشاغر'
                                    : null,
                                onSaved: (input) {
                                  _jobDescription = input;
                                },
                                maxLines: 10,
                                maxLength: 350,
                                decoration: InputDecoration(
                                  hintText: 'وصف الشاغر',
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
                                horizontal: 20.0,
                                vertical: 8,
                              ),
                              child: TextFormField(
                                onSaved: (input) {
                                  _salary = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText:
                                      'الراتب بالدولار الأمريكي ( اختياري )',
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
                                onSaved: (input) {
                                  _phoneNumber = input;
                                },
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'رقم الهاتف ( اختياري )',
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
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
