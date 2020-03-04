import 'package:asima_online/services/database_service.dart';
import 'package:flutter/material.dart';

List categories = ['اقتصادي', 'قانوني', 'غير ذلك'];

class QuestionAnswerScreen extends StatefulWidget {
  static String id = 'q_a_screen';

  @override
  _QuestionAnswerScreenState createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
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
              'سؤال وجواب',
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
                future: DatabaseService.getQuestions(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List questions = List();
                  snapshot.data.documents.forEach((doc) {
                    if (doc['approved'] == false) {
                      questions.add(doc);
                    }
                  });
                  if (questions.length == 0) {
                    return Center(
                      child: Text(
                        'لا توجد أسئلة حاليا',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return QuestionAnswerCard(
                          questionDoc: questions[index], approved: false);
                    },
                  );
                },
              ),
              FutureBuilder(
                future: DatabaseService.getQuestions(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List questions = List();
                  snapshot.data.documents.forEach((doc) {
                    if (doc['approved'] == true) {
                      questions.add(doc);
                    }
                  });
                  if (questions.length == 0) {
                    return Center(
                      child: Text(
                        'لا توجد أسئلة حاليا',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return QuestionAnswerCard(
                          questionDoc: questions[index], approved: true);
                    },
                  );
                },
              ),
            ],
          )),
    );
  }
}

class QuestionAnswerCard extends StatefulWidget {
  final questionDoc;
  final approved;
  QuestionAnswerCard({this.questionDoc, this.approved});

  @override
  _QuestionAnswerCardState createState() => _QuestionAnswerCardState();
}

class _QuestionAnswerCardState extends State<QuestionAnswerCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewAnswerScreen(
                questionDoc: widget.questionDoc, approved: widget.approved),
          ),
        );
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[800],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.questionDoc['author'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Text(
                      widget.questionDoc['categorey'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.questionDoc['question'] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewAnswerScreen extends StatelessWidget {
  final questionDoc;
  final approved;
  ViewAnswerScreen({this.questionDoc, this.approved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'سؤال',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
      ),
      floatingActionButton: !approved
          ? FloatingActionButton(
              onPressed: () async {
                await DatabaseService.approveQuestion(
                    questionDoc.documentID, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, QuestionAnswerScreen.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.check,
                color: Colors.grey[800],
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                await DatabaseService.deleteQuestion(
                    questionDoc.documentID, context);
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, QuestionAnswerScreen.id);
              },
              backgroundColor: Color(0xfff2f2f2),
              child: Icon(
                Icons.delete,
                color: Colors.grey[800],
              ),
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
            physics: ScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            )),
            child: QuestionAnswerCard(
              questionDoc: questionDoc,
            ),
          ),
        ],
      ),
    );
  }
}
