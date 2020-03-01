import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessCardModel {
  final String author;
  final String title;
  final List address;
  final String description;
  final String mainImage;
  final List secondaryImages;
  final String type;
  final String id;
  final List links;

  BusinessCardModel(
      {this.type,
      this.author,
      this.title,
      this.address,
      this.description,
      this.mainImage,
      this.secondaryImages,
      this.links,
      this.id});

  factory BusinessCardModel.fromDoc(DocumentSnapshot doc) {
    return BusinessCardModel(
      author: doc['author'],
      id: doc['id'],
      type: doc['type'],
      title: doc['title'],
      address: doc['address'],
      description: doc['description'],
      mainImage: doc['mainImage'],
      secondaryImages: doc['secondaryImages'],
      links: doc['links'],
    );
  }
}
