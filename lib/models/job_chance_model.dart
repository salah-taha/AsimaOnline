import 'package:cloud_firestore/cloud_firestore.dart';

class JobChance {
  final country;
  final city;
  final companyName;
  final title;
  final description;
  final image;
  final salary;
  final phoneNumber;
  final email;
  final id;

  JobChance(
      {this.title,
      this.image,
      this.description,
      this.country,
      this.email,
      this.city,
      this.companyName,
      this.phoneNumber,
      this.salary,
      this.id});
  factory JobChance.fromDoc(DocumentSnapshot doc) {
    return JobChance(
        title: doc['title'],
        image: doc['image'],
        description: doc['description'],
        country: doc['country'],
        email: doc['email'],
        city: doc['city'],
        companyName: doc['companyName'],
        phoneNumber: doc['phoneNumber'],
        salary: doc['salary'],
        id: doc.documentID);
  }
}
