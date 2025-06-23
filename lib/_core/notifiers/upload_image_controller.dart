import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';

final uploadImageControllerProvider =
    StateNotifierProvider<UploadImageController, AsyncValue<String?>>((ref) {
  return UploadImageController(ref.watch(firebaseStorageProvider));
});

class UploadImageController extends StateNotifier<AsyncValue<String?>> {
  final FirebaseStorage _firebaseStorage;

  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const Duration _uploadTimeout = Duration(minutes: 5);
  static const List<String> _allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];

  UploadImageController(this._firebaseStorage)
      : super(const AsyncValue.data(null));

  /// Uploads a provided image file to Firebase Storage and returns the download URL
  Future<String?> uploadImage(PlatformFile file, String folderName) async {
    state = const AsyncValue.loading();

    try {
      final fileBytes = await _getFileBytes(file);
      _validateFile(file, fileBytes);

      final downloadUrl = await _uploadToFirebase(file, fileBytes, folderName);

      state = AsyncValue.data(downloadUrl);
      return downloadUrl;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  /// Picks an image file using the file picker
  Future<PlatformFile?> pickImageFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        compressionQuality: 50,
      );

      return result?.files.isNotEmpty == true ? result!.files.first : null;
    } catch (e) {
      throw Exception('Failed to pick file: $e');
    }
  }

  /// Extracts bytes from the selected file
  Future<Uint8List> _getFileBytes(PlatformFile file) async {
    if (kIsWeb) {
      if (file.bytes == null) {
        throw Exception('File bytes are unavailable on web platform');
      }
      return file.bytes!;
    } else {
      if (file.path == null) {
        throw Exception('File path is unavailable on mobile platform');
      }

      final fileFromPath = File(file.path!);
      if (!await fileFromPath.exists()) {
        throw Exception('File does not exist at the specified path');
      }

      return await fileFromPath.readAsBytes();
    }
  }

  /// Validates the file type and size
  void _validateFile(PlatformFile file, Uint8List fileBytes) {
    final fileName = file.name;
    final extension = fileName.split('.').last.toLowerCase();

    if (!_allowedExtensions.contains(extension)) {
      throw Exception(
          'Unsupported file type. Allowed: ${_allowedExtensions.join(', ')}');
    }

    if (fileBytes.length > _maxFileSizeBytes) {
      throw Exception('File size exceeds 5MB limit');
    }
  }

  /// Uploads the file to Firebase Storage and returns the download URL
  Future<String> _uploadToFirebase(
    PlatformFile file,
    Uint8List fileBytes,
    String folderName,
  ) async {
    final timestamp = DateTime.now();
    final fileName = file.name;
    final sanitizedFolderName = _sanitizeFolderName(folderName);

    final storageRef = _firebaseStorage.ref().child(sanitizedFolderName).child(
        '${timestamp.year}/${timestamp.month}/${timestamp.millisecondsSinceEpoch}_$fileName');

    final metadata = SettableMetadata(
      contentType: _getContentType(fileName.split('.').last.toLowerCase()),
      customMetadata: {
        'uploaded_at': timestamp.toIso8601String(),
        'original_name': fileName,
        'file_size': fileBytes.length.toString(),
        'platform': kIsWeb ? 'web' : 'mobile',
      },
    );

    try {
      final uploadTask = storageRef.putData(fileBytes, metadata);

      // Optional: Listen to upload progress
      uploadTask.snapshotEvents.listen((event) {
        final progress =
            (event.bytesTransferred / event.totalBytes * 100).toInt();
        debugPrint('Upload progress: $progress%');
      });

      await uploadTask.timeout(_uploadTimeout);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  /// Returns the appropriate MIME type for the file extension
  String _getContentType(String extension) {
    const contentTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
    };

    return contentTypes[extension] ?? 'image/jpeg';
  }

  /// Sanitizes folder name for Firebase Storage
  String _sanitizeFolderName(String folderName) {
    return folderName
        .replaceAll(RegExp(r'[^\w\-_/]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
