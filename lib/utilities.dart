import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _fireStore = Firestore.instance;
final usersRef = _fireStore.collection('users');
final storageRef = FirebaseStorage.instance.ref();
final cardsRef = _fireStore.collection('businessCards');
final chatRoomRef = _fireStore.collection('chatRoom');
final questionRef = _fireStore.collection('questions');
final jobChancesRef = _fireStore.collection('jobChances');
final ideasRef = _fireStore.collection('ideas');
