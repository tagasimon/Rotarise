import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImagePickerNotifier {
  // final FirebaseStorage firebaseStorage;
  // ImageUploadRepository({required this.firebaseStorage});

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

  static Future<File?> selectImageFromCamera() async {
    File? imgFile;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      imgFile = File(image.path);
    }
    return imgFile;
  }

  static Future<String?> uploadCustomerImage() async {
    final File? file = await selectImageFromGallery();
    if (file == null) {
      return null;
    }
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    // Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("images/path/to/mountains.jpg")
        .putFile(file, metadata);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
    return null;
  }
}
