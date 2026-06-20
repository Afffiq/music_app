import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  Future<String> uploadSong({
    required Uint8List fileBytes,
    required String fileName,
  }) async {

    Reference ref =
        _storage.ref().child(
          'songs/$fileName',
        );

    UploadTask task =
        ref.putData(fileBytes);

    await task;

    return await ref.getDownloadURL();
  }
}