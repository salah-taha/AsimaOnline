import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String id;
  final String email;
  final String profileImageUrl;
  final String type;

  User({this.email, this.id, this.name, this.profileImageUrl, this.type});
  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
        id: doc.documentID,
        name: doc['name'],
        email: doc['email'],
        profileImageUrl: doc['profileImageUrl'],
        type: doc['userType']);
  }
}
