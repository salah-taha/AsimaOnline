import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/screens/signin_screen.dart';
import 'package:asima_online/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List categories = ['اقتصادي', 'قانوني', 'غير ذلك'];

class QuestionAnswerScreen extends StatefulWidget {
  static String id = 'q_a_screen';

  @override
  _QuestionAnswerScreenState createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  String selectedCat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuestionScreen(),
                ),
              );
              setState(() {});
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.grey[800],
          ),
          SizedBox(
            height: 10,
          ),
          selectedCat != null
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
                      selectedCat = null;
                    });
                  },
                )
              : SizedBox(),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseService.getQuestions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List questions = List();
          snapshot.data.documents.forEach((doc) {
            if (doc['categorey'].contains(selectedCat ?? '')) {
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

          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      height: 50,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: selectedCat == null
                                  ? Colors.grey
                                  : Colors.blue,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          hint: Text('اختر تصنيف'),
                          isExpanded: true,
                          value: selectedCat ?? null,
                          items:
                              categories.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (index) {
                            setState(() {
                              selectedCat = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return QuestionAnswerCard(
                        questionDoc: questions[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuestionAnswerCard extends StatefulWidget {
  final questionDoc;
  final bool isAnswersScreen;
  QuestionAnswerCard({this.questionDoc, this.isAnswersScreen = false});

  @override
  _QuestionAnswerCardState createState() => _QuestionAnswerCardState();
}

class _QuestionAnswerCardState extends State<QuestionAnswerCard> {
  bool addAnswer = false;
  final FocusNode _focusNode = new FocusNode();
  final TextEditingController _answerField = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.isAnswersScreen
                          ? SizedBox()
                          : FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewAnswerScreen(
                                      questionDoc: widget.questionDoc,
                                    ),
                                  ),
                                );
                              },
                              child: Text('مشاهدة الإجابات'),
                              color: Color(0xfff2f2f2),
                            ),
                      widget.isAnswersScreen
                          ? SizedBox()
                          : SizedBox(
                              width: 25,
                            ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            addAnswer = !addAnswer;
                          });
                        },
                        child: Text(addAnswer ? 'إلغاء' : 'إضافة إجابة'),
                        color: Color(0xfff2f2f2),
                      ),
                    ],
                  ),
                ),
                addAnswer
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: _answerField,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'إضافة إجابة',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Color(0xfff2f2f2),
                          ),
                        ),
                      )
                    : SizedBox(),
                addAnswer
                    ? FlatButton(
                        onPressed: () async {
                          if (_answerField.text.isNotEmpty) {
                            await DatabaseService.addAnswer(
                                widget.questionDoc.documentID,
                                _answerField.text,
                                context);
                            _answerField.clear();
                            setState(() {
                              addAnswer = false;
                            });
                          }
                        },
                        child: Text('إرسال'),
                        color: Color(0xfff2f2f2),
                      )
                    : SizedBox(),
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
  ViewAnswerScreen({this.questionDoc});

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
      body: FutureBuilder(
        future: DatabaseService.getQuestionAnswers(questionDoc.documentID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  )),
                  child: QuestionAnswerCard(
                    questionDoc: questionDoc,
                    isAnswersScreen: true,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return AnswerCard(
                        answerDoc: snapshot.data.documents[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  final answerDoc;
  AnswerCard({this.answerDoc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  answerDoc['author'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  answerDoc['answer'],
                  textAlign: TextAlign.center,
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

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String selectedCat;
  bool isLoading = false;
  final FocusNode _focusNode = new FocusNode();
  final TextEditingController _newQuestionField = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title: Text(
          'إضافة سؤال جديد',
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
          : Provider.of<ProviderData>(context).currentUserId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'يجب تسجيل الدخول أولا',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      FlatButton(
                        splashColor: Color(0xfff2f2f2),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 25.0,
                          ),
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                    parent: ScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            height: 50,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedCat == null
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
                                hint: Text('اختر تصنيف'),
                                isExpanded: true,
                                value: selectedCat ?? null,
                                items: categories
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (index) {
                                  setState(() {
                                    selectedCat = index;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15),
                        child: TextField(
                          maxLines: 10,
                          maxLength: 350,
                          controller: _newQuestionField,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'إضافة سؤال',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      FlatButton(
                        splashColor: Color(0xfff2f2f2),
                        color: Colors.grey[800],
                        onPressed: () async {
                          if (selectedCat != null &&
                              _newQuestionField.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            await DatabaseService.uploadQuestion(
                                selectedCat, _newQuestionField.text, context);
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, QuestionAnswerScreen.id);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 25.0,
                          ),
                          child: Text(
                            'نشر السؤال',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
