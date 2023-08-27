import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rupa_creation/utility/app_urls.dart';

class FirebaseApi{
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.refFromURL('${AppUrl.firebaseStorageBaseUrl}/$destination');

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}