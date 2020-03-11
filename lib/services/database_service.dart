import 'package:asima_online/models/business_card_model.dart';
import 'package:asima_online/models/idea_model.dart';
import 'package:asima_online/models/job_chance_model.dart';
import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/models/user.dart';
import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  static userUpdate(User user) async {
    await usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'userType': user.type,
    });
  }

  static Future<DocumentSnapshot> getUserInfo(String userId) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return userDoc;
  }

  static sendMessage(String message, String userId) {
    chatRoomRef.add({
      'message': message,
      'author': userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Stream getChatMessages(String roomId) {
    final messages = chatRoomRef.snapshots();
    return messages;
  }

  static void uploadBusinessCard(
      BusinessCardModel model, BuildContext context) async {
    await cardsRef.document(model.id).setData({
      'author': model.author,
      'id': model.id,
      'links': model.links,
      'title': model.title,
      'address': model.address,
      'description': model.description,
      'mainImage': model.mainImage,
      'secondaryImages': model.secondaryImages,
      'type': model.type,
      'timestamp': DateTime.now().toIso8601String(),
      'approved': false,
    });
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, AsimaBusiness.id);
    popDialog(context);
  }

  static Future<bool> uploadQuestion(
      String cat, String question, BuildContext context) async {
    DocumentSnapshot userDoc = await getUserInfo(
        Provider.of<ProviderData>(context, listen: false).currentUserId);
    String userName;
    try {
      userName = userDoc['name'];
    } catch (e) {
      print(e);
    }
    await questionRef.add({
      'question': question,
      'categorey': cat,
      'author': userName,
      'time': DateTime.now().toIso8601String(),
      'approved': false,
    });
    return true;
  }

  static addAnswer(
      String questionId, String answer, BuildContext context) async {
    DocumentSnapshot userDoc = await getUserInfo(
        Provider.of<ProviderData>(context, listen: false).currentUserId);
    String userName;
    try {
      userName = userDoc['name'];
    } catch (e) {
      print(e);
    }
    questionRef.document(questionId).collection('answers').add({
      'answer': answer,
      'author': userName ?? 'مستخدم مجهول',
      'time': DateTime.now().toIso8601String()
    });
  }

  static Future<QuerySnapshot> getQuestionAnswers(String questionId) async {
    QuerySnapshot answers = await questionRef
        .document(questionId)
        .collection('answers')
        .orderBy('time', descending: true)
        .getDocuments();
    return answers;
  }

  static Future<QuerySnapshot> getQuestions() async {
    QuerySnapshot questions =
        await questionRef.orderBy('time', descending: true).getDocuments();
    return questions;
  }

  static uploadJobChance(JobChance jobChance) async {
    await jobChancesRef.add({
      'title': jobChance.title,
      'image': jobChance.image,
      'description': jobChance.description,
      'country': jobChance.country,
      'city': jobChance.city,
      'email': jobChance.email,
      'salary': jobChance.salary,
      'phoneNumber': jobChance.phoneNumber,
      'companyName': jobChance.companyName,
      'timestamp': DateTime.now().toIso8601String(),
      'approved': false,
    });
    return;
  }

  static Future<QuerySnapshot> getJobChancesDocs() async {
    QuerySnapshot jobChancesSnapshot = await jobChancesRef
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return jobChancesSnapshot;
  }

  static uploadIdea(Idea idea) async {
    await ideasRef.add({
      'title': idea.title,
      'imageUrl': idea.imageUrl,
      'projectHolder': idea.projectHolder,
      'holderExp': idea.holderExp,
      'country': idea.country,
      'suggestedCity': idea.suggestedCity,
      'description': idea.description,
      'minBudget': idea.minBudget,
      'maxBudget': idea.maxBudget,
      'notes': idea.notes,
      'phoneNumber': idea.phoneNumber,
      'email': idea.email,
      'timestamp': DateTime.now().toIso8601String(),
      'approved': false,
    });
  }

  static Future<QuerySnapshot> getIdeas() async {
    QuerySnapshot ideasSnapshot =
        await ideasRef.orderBy('timestamp', descending: true).getDocuments();
    return ideasSnapshot;
  }

  static popDialog(BuildContext context) {
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
