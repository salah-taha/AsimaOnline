import 'package:asima_online/models/user.dart';
import 'package:asima_online/screens/asima_business.dart';
import 'package:asima_online/screens/ideas_investment_screen.dart';
import 'package:asima_online/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

  static Future<QuerySnapshot> getQuestions() async {
    QuerySnapshot questions =
        await questionRef.orderBy('time', descending: true).getDocuments();
    return questions;
  }

  static Future<QuerySnapshot> getJobChancesDocs() async {
    QuerySnapshot jobChancesSnapshot = await jobChancesRef
        .orderBy('timestamp', descending: true)
        .getDocuments();
    return jobChancesSnapshot;
  }

  static Future<QuerySnapshot> getIdeas() async {
    QuerySnapshot ideasSnapshot =
        await ideasRef.orderBy('timestamp', descending: true).getDocuments();
    return ideasSnapshot;
  }
}
