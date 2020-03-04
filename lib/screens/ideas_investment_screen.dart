import 'package:asima_online/models/idea_model.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:flutter/material.dart';

class IdeasInvestmentScreen extends StatefulWidget {
  static String id = 'ideas_investment_screen';

  @override
  _IdeasInvestmentScreenState createState() => _IdeasInvestmentScreenState();
}

class _IdeasInvestmentScreenState extends State<IdeasInvestmentScreen> {
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
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                future: DatabaseService.getIdeas(),
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
                      child: Text('لا يوجد أفكار حتي الأن'),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      Idea idea = Idea.fromDoc(docs[index]);
                      return IdeaCard(
                        idea: idea,
                        approved: false,
                      );
                    },
                  );
                },
              ),
              FutureBuilder(
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

class IdeaCard extends StatefulWidget {
  final Idea idea;
  final approved;
  IdeaCard({this.idea, this.approved});
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
              builder: (context) =>
                  ViewIdea(idea: widget.idea, approved: widget.approved),
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

class ViewIdea extends StatelessWidget {
  final Idea idea;
  final approved;
  ViewIdea({this.idea, this.approved});

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
      floatingActionButton: !approved
          ? FloatingActionButton(
              onPressed: () async {
                await DatabaseService.approveIdea(idea.id, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, IdeasInvestmentScreen.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.check,
                color: Colors.grey[800],
              ),
            )
          : null,
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
