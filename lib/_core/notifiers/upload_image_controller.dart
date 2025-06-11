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
  final FirebaseStorage firebaseStorage;

  UploadImageController(this.firebaseStorage)
      : super(const AsyncValue.data(null));

  Future<String?> getUserDownloadUrl(String folderName) async {
    state = const AsyncValue.loading();
    try {
      final url = await updateProfilePic(folderName: folderName);
      state = AsyncValue.data(url);
      return url;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return null;
    }
  }

  Future<String?> updateProfilePic({required String folderName}) async {
    try {
      final dn = DateTime.now();
      String? imgUrl;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      debugPrint("File picker result: $result");

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        Uint8List fileBytes;

        // Handle different platforms
        if (kIsWeb) {
          // On web, use bytes directly
          if (file.bytes == null) {
            throw Exception('File bytes are null on web platform.');
          }
          fileBytes = file.bytes!;
        } else {
          // On mobile platforms, read from file path
          if (file.path == null) {
            throw Exception('File path is null on mobile platform.');
          }
          final fileFromPath = File(file.path!);
          if (!await fileFromPath.exists()) {
            throw Exception('File does not exist at path: ${file.path}');
          }
          fileBytes = await fileFromPath.readAsBytes();
        }

        // Validate file size (optional - adjust limit as needed)
        if (fileBytes.length > 5 * 1024 * 1024) {
          // 5MB limit
          throw Exception('File size too large. Maximum size is 5MB.');
        }

        // Create a more descriptive filename
        final fileName =
            file.name ?? '${DateTime.now().millisecondsSinceEpoch}';
        final fileExtension = fileName.split('.').last.toLowerCase();

        // Validate file extension
        final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
        if (!allowedExtensions.contains(fileExtension)) {
          throw Exception(
              'Invalid file type. Allowed: ${allowedExtensions.join(', ')}');
        }

        // Create Firebase Storage reference with explicit bucket
        final ref = FirebaseStorage.instanceFor(
          bucket: 'gs://rotaract-584b8.firebasestorage.app',
        )
            .ref()
            .child(folderName)
            .child("${dn.year}")
            .child("${dn.month}")
            .child("${DateTime.now().millisecondsSinceEpoch}_$fileName");

        // Upload with metadata
        final metadata = SettableMetadata(
          contentType: _getContentType(fileExtension),
          customMetadata: {
            'uploaded_at': DateTime.now().toIso8601String(),
            'original_name': fileName,
            'file_size': fileBytes.length.toString(),
            'platform': kIsWeb ? 'web' : 'mobile',
          },
        );

        // For web, set CORS-friendly headers
        if (kIsWeb) {
          final webMetadata = SettableMetadata(
            contentType: _getContentType(fileExtension),
            cacheControl: 'public, max-age=3600',
            customMetadata: {
              'uploaded_at': DateTime.now().toIso8601String(),
              'original_name': fileName,
              'file_size': fileBytes.length.toString(),
              'platform': 'web',
            },
          );

          final uploadTask = ref.putData(fileBytes, webMetadata);

          // Monitor upload progress
          uploadTask.snapshotEvents.listen(
            (TaskSnapshot snapshot) {
              final progress = snapshot.bytesTransferred / snapshot.totalBytes;
              debugPrint(
                  'Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
            },
            onError: (error) {
              debugPrint('Upload stream error: $error');
            },
          );

          // Wait for upload completion with timeout
          await uploadTask.timeout(
            const Duration(minutes: 5),
            onTimeout: () {
              throw Exception('Upload timeout after 5 minutes');
            },
          );
        } else {
          // Mobile upload
          final uploadTask = ref.putData(fileBytes, metadata);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            final progress = snapshot.bytesTransferred / snapshot.totalBytes;
            debugPrint(
                'Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
          });

          await uploadTask;
        }

        // Get download URL with retry mechanism
        imgUrl = await _getDownloadUrlWithRetry(ref);

        if (imgUrl != null) {
          debugPrint("Upload successful. URL: $imgUrl");
        } else {
          throw Exception('Failed to get download URL after upload');
        }
      } else {
        debugPrint("No file selected or result is null");
        return null;
      }

      return imgUrl;
    } on FirebaseException catch (e) {
      debugPrint("Firebase error: ${e.code} - ${e.message}");

      // Handle specific Firebase Storage errors
      switch (e.code) {
        case 'storage/unauthorized':
          throw Exception(
              'Upload failed: You do not have permission to upload files.');
        case 'storage/canceled':
          throw Exception('Upload was canceled.');
        case 'storage/unknown':
          throw Exception('Upload failed due to an unknown error.');
        case 'storage/invalid-format':
          throw Exception('Invalid file format.');
        case 'storage/invalid-argument':
          throw Exception('Invalid upload parameters.');
        case 'storage/retry-limit-exceeded':
          throw Exception('Upload failed: Maximum retry attempts exceeded.');
        case 'storage/quota-exceeded':
          throw Exception('Upload failed: Storage quota exceeded.');
        default:
          throw Exception(
              'Upload failed: ${e.message ?? 'Unknown Firebase error'}');
      }
    } catch (e) {
      debugPrint("General error during upload: $e");
      rethrow;
    }
  }

  // Helper method to get download URL with retry
  Future<String?> _getDownloadUrlWithRetry(Reference ref,
      {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final url = await ref.getDownloadURL();
        return url;
      } catch (e) {
        debugPrint('Attempt ${i + 1} to get download URL failed: $e');
        if (i == maxRetries - 1) {
          debugPrint('All attempts to get download URL failed');
          return null;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: (i + 1) * 2));
      }
    }
    return null;
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'bmp':
        return 'image/bmp';
      case 'ico':
        return 'image/x-icon';
      default:
        return 'image/jpeg';
    }
  }

  // Helper method to validate and sanitize folder names
  String _sanitizeFolderName(String folderName) {
    return folderName
        .replaceAll(RegExp(r'[^\w\-_/]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  // Method to delete uploaded image (optional utility)
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instanceFor(
        bucket: 'gs://rotaract-584b8.firebasestorage.app',
      ).refFromURL(imageUrl);

      await ref.delete();
      debugPrint('Image deleted successfully: $imageUrl');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('Failed to delete image: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  // Method to get image metadata
  Future<Map<String, dynamic>?> getImageMetadata(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instanceFor(
        bucket: 'gs://rotaract-584b8.firebasestorage.app',
      ).refFromURL(imageUrl);

      final metadata = await ref.getMetadata();
      return {
        'name': metadata.name,
        'bucket': metadata.bucket,
        'contentType': metadata.contentType,
        'size': metadata.size,
        'timeCreated': metadata.timeCreated?.toIso8601String(),
        'updated': metadata.updated?.toIso8601String(),
        'customMetadata': metadata.customMetadata,
      };
    } catch (e) {
      debugPrint('Error getting image metadata: $e');
      return null;
    }
  }
}
