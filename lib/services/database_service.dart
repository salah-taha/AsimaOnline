import 'package:asima_online/models/business_card_model.dart';
import 'package:asima_online/models/idea_model.dart';
import 'package:asima_online/models/job_chance_model.dart';
import 'package:asima_online/models/provider_data.dart';
import 'package:asima_online/models/user.dart';
import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/screens/ideas_investment_screen.dart';
import 'package:asima_online/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  static userUpdate(User user) async {
    await usersRef.document(user.id).updateData({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'userType': user.type,
    });
  }

  static Future approveJob(String jobId, BuildContext context) async {
    try {
      await jobChancesRef.document(jobId).updateData({
        'approved': true,
      });
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
  }

  static Future deleteJob(String jobId, BuildContext context) async {
    try {
      await jobChancesRef.document(jobId).delete();
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
  }

  static Future approveIdea(String ideaId, BuildContext context) async {
    try {
      await ideasRef.document(ideaId).updateData({
        'approved': true,
      });
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
  }

  static Future approveBusiness(String businessId, BuildContext context) async {
    try {
      await businessRef.document(businessId).updateData({
        'approved': true,
      });
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AsimaBusiness.id);
    }
  }

  static Future approveQuestion(String questionId, BuildContext context) async {
    try {
      await questionRef.document(questionId).updateData({
        'approved': true,
      });
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AsimaBusiness.id);
    }
  }

  static Future deleteIdea(String ideaId, BuildContext context) async {
    try {
      await ideasRef.document(ideaId).delete();
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
  }

  static Future deleteQuestion(String questionId, BuildContext context) async {
    try {
      await questionRef.document(questionId).delete();
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
  }

  static Future deleteBusiness(String businessId, BuildContext context) async {
    try {
      await businessRef.document(businessId).delete();
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AsimaBusiness.id);
    }
  }

  static Future deleteMessage(String messageId, BuildContext context) async {
    try {
      await chatRoomRef.document(messageId).delete();
      return;
    } catch (e) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, IdeasInvestmentScreen.id);
    }
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
    businessRef.document(model.id).setData({
      'author': model.author,
      'id': model.id,
      'links': model.links,
      'title': model.title,
      'address': model.address,
      'description': model.description,
      'mainImage': model.mainImage,
      'secondaryImages': model.secondaryImages,
      'type': model.type
    });
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
      'timestamp': DateTime.now().toIso8601String()
    });
  }

  static Future<QuerySnapshot> getIdeas() async {
    QuerySnapshot ideasSnapshot =
        await ideasRef.orderBy('timestamp', descending: true).getDocuments();
    return ideasSnapshot;
  }
}
