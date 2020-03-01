import 'dart:io';

import 'package:asima_online/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(imageFile, photoId);
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<StorageTaskSnapshot> uploadBusinessImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(imageFile, photoId);

    StorageUploadTask uploadTask = storageRef
        .child('images/business/businessPhoto_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    return storageSnap;
  }

  static Future<StorageTaskSnapshot> uploadJobChanceImage(
      File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(imageFile, photoId);

    StorageUploadTask uploadTask = storageRef
        .child('images/jobChances/jobChancePhoto_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    return storageSnap;
  }

  static Future<StorageTaskSnapshot> uploadIdeaImage(File imageFile) async {
    String photoId = Uuid().v4();
    File image = await compressImage(imageFile, photoId);

    StorageUploadTask uploadTask =
        storageRef.child('images/ideas/ideaPhoto_$photoId.jpg').putFile(image);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    return storageSnap;
  }

  static Future<File> compressImage(File imageFile, String photoId) async {
    var compressedImage;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    try {
      compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        '$path/img_$photoId.jpg',
        quality: 70,
      );
    } on UnsupportedError {
      compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        imageFile.absolute.path,
        format: CompressFormat.jpeg,
        quality: 70,
      );
    }
    return compressedImage;
  }
}
