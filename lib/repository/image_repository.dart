import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImageRepository {
  final ImagePicker _picker = ImagePicker();
  Uuid uuid = const Uuid();
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<XFile?> pickImage(bool fromCamera) async {
    XFile? xFile = await _picker.pickImage(
        maxHeight: 1000,
        imageQuality: 80,
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    return xFile;
  }

  Future<String> uploadPicture(File file) async {
    UploadTask task =
        storage.ref(uuid.v4() + p.extension(file.path)).putFile(file);
    TaskSnapshot snapshot = await task;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
