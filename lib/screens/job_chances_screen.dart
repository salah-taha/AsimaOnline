import 'package:asima_online/models/job_chance_model.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobChancesScreen extends StatefulWidget {
  static String id = 'job_chances';

  @override
  _JobChancesScreenState createState() => _JobChancesScreenState();
}

class _JobChancesScreenState extends State<JobChancesScreen> {
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
              'فرص عمل',
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xfff2f2f2),
            elevation: 0,
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                future: DatabaseService.getJobChancesDocs(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      child: Text('لا يوجد فرص عمل الأن'),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      JobChance jobChance = JobChance.fromDoc(docs[index]);
                      return JobChanceCard(
                        jobChance: jobChance,
                        approved: false,
                      );
                    },
                  );
                },
              ),
              FutureBuilder(
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
                        approved: true,
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

class ViewJob extends StatelessWidget {
  final JobChance jobChance;
  final approved;
  ViewJob({this.jobChance, this.approved});

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
      floatingActionButton: !approved
          ? FloatingActionButton(
              onPressed: () async {
                await DatabaseService.approveJob(jobChance.id, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, JobChancesScreen.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.check,
                color: Colors.grey[800],
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                await DatabaseService.deleteJob(jobChance.id, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, JobChancesScreen.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.delete,
                color: Colors.grey[800],
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
  final approved;
  JobChanceCard({this.jobChance, this.approved});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewJob(
              jobChance: jobChance,
              approved: approved,
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
