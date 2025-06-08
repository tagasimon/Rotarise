import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImagePickerNotifier {
  /// Pick image using ImagePicker (Camera/Gallery), upload to Firebase Storage, and return URL
  static Future<File?> selectImageFromGallery() async {
    File? imgFile;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      imgFile = File(image.path);
    }
    return imgFile;
  }

  static Future<String?> pickAndUploadImage() async {
    final File? file = await selectImageFromGallery();
    if (file == null) return null;
    try {
      File imageFile = File(file.path);
      String? downloadUrl = await _uploadImageToFirebase(imageFile);
      return downloadUrl;
    } catch (e) {
      debugPrint("$e");
      Fluttertoast.showToast(msg: "Error: $e");
      return null;
    }
  }

  /// Uploads the image to Firebase Storage and returns the download URL
  static Future<String?> _uploadImageToFirebase(File imageFile) async {
    if (imageFile.lengthSync() == 0) {
      throw Exception("Selected file is empty.");
    }

    String fileName = const Uuid().v4();
    String filePath = "PROFILE-PICS/${DateTime.now().year}/$fileName.jpg";
    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    try {
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        return await ref.getDownloadURL();
      } else {
        throw Exception("Upload failed");
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      rethrow;
    }
  }
}
