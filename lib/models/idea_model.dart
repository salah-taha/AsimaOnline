import 'package:cloud_firestore/cloud_firestore.dart';

class Idea {
  final projectHolder;
  final holderExp;
  final country;
  final suggestedCity;
  final title;
  final description;
  final imageUrl;
  final minBudget;
  final maxBudget;
  final notes;
  final phoneNumber;
  final email;
  final id;

  Idea({
    this.phoneNumber,
    this.email,
    this.description,
    this.title,
    this.country,
    this.imageUrl,
    this.holderExp,
    this.maxBudget,
    this.minBudget,
    this.notes,
    this.projectHolder,
    this.suggestedCity,
    this.id,
  });

  factory Idea.fromDoc(DocumentSnapshot doc) {
    return Idea(
      phoneNumber: doc['phoneNumber'],
      email: doc['email'],
      description: doc['description'],
      title: doc['title'],
      country: doc['country'],
      imageUrl: doc['imageUrl'],
      holderExp: doc['holderExp'],
      maxBudget: doc['maxBudget'],
      minBudget: doc['minBudget'],
      notes: doc['notes'],
      projectHolder: doc['projectHolder'],
      suggestedCity: doc['suggestedCity'],
      id: doc.documentID,
    );
  }
}
