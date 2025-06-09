import 'dart:io';
import 'dart:typed_data';
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
      String? downloadUrl = await _uploadImageToFirebase(file);
      return downloadUrl;
    } catch (e) {
      debugPrint("Error in pickAndUploadImage: $e");
      Fluttertoast.showToast(msg: "Error: $e");
      return null;
    }
  }

  /// Uploads the image to Firebase Storage and returns the download URL
  static Future<String?> _uploadImageToFirebase(File imageFile) async {
    // Check if file exists and is not empty
    if (!await imageFile.exists()) {
      throw Exception("File does not exist");
    }

    if (await imageFile.length() == 0) {
      throw Exception("Selected file is empty");
    }

    String fileName = const Uuid().v4();
    String filePath = "PROFILE-PICS/${DateTime.now().year}/$fileName.jpg";
    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    try {
      debugPrint("Starting upload to: $filePath");
      debugPrint("File size: ${await imageFile.length()} bytes");

      // Method 1: Use putFile with await and then get URL
      await ref.putFile(imageFile);
      debugPrint("Upload completed, getting download URL...");

      // Add a small delay to ensure the file is fully processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Get download URL
      String downloadURL = await ref.getDownloadURL();
      debugPrint("Download URL obtained: $downloadURL");
      return downloadURL;
    } on FirebaseException catch (e) {
      debugPrint("Firebase error: ${e.code} - ${e.message}");

      // If object-not-found, try alternative method
      if (e.code == 'object-not-found') {
        debugPrint("Trying alternative upload method...");
        return await _alternativeUploadMethod(imageFile, filePath);
      }

      throw Exception("Firebase upload failed: ${e.message}");
    } catch (e) {
      debugPrint("Upload error: $e");
      rethrow;
    }
  }

  /// Alternative upload method using putData instead of putFile
  static Future<String?> _alternativeUploadMethod(
      File imageFile, String filePath) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      // Read file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();
      debugPrint("File read as bytes, size: ${imageBytes.length}");

      // Upload using putData
      UploadTask uploadTask = ref.putData(
        Uint8List.fromList(imageBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for completion
      TaskSnapshot snapshot = await uploadTask;
      debugPrint("Alternative upload completed with state: ${snapshot.state}");

      if (snapshot.state == TaskState.success) {
        // Wait a bit more before getting URL
        await Future.delayed(const Duration(seconds: 1));
        String downloadURL = await ref.getDownloadURL();
        debugPrint("Alternative method - Download URL obtained: $downloadURL");
        return downloadURL;
      } else {
        throw Exception(
            "Alternative upload failed with state: ${snapshot.state}");
      }
    } catch (e) {
      debugPrint("Alternative upload method failed: $e");
      rethrow;
    }
  }
}
