import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetHelpers {
  static void launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch email client');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  static void launchPhone(String phone) async {
    // Clean the phone number and ensure it has proper formatting
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch phone dialer');
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  static void launchWhatsApp(String whatsapp) async {
    // Validate input
    if (whatsapp.isEmpty) {
      debugPrint('WhatsApp number is empty');
      return;
    }

    // Clean the WhatsApp number (remove spaces, dashes, parentheses, etc.)
    String cleanNumber = whatsapp.replaceAll(RegExp(r'[^\d+]'), '');

    // Remove any leading zeros after cleaning
    cleanNumber = cleanNumber.replaceAll(RegExp(r'^0+'), '');

    // Ensure the number starts with country code
    if (!cleanNumber.startsWith('+')) {
      // If no country code, add a default one (you may want to customize this)
      // For example, if most numbers are from a specific country
      cleanNumber = '+$cleanNumber';
    }

    // For WhatsApp URL, we need to remove the '+' sign
    String whatsappNumber =
        cleanNumber.startsWith('+') ? cleanNumber.substring(1) : cleanNumber;

    // Validate that we have a reasonable phone number length
    if (whatsappNumber.length < 7 || whatsappNumber.length > 15) {
      debugPrint('Invalid phone number length: $whatsappNumber');
      return;
    }

    // Try WhatsApp app URL scheme first, then fallback to web
    final whatsappUri = Uri.parse('whatsapp://send?phone=$whatsappNumber');
    final webUri = Uri.parse('https://wa.me/$whatsappNumber');

    try {
      // First try to open WhatsApp app directly
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUri)) {
        // Fallback to web version if app is not installed
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp');
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
      // Try fallback to web version on error
      try {
        if (await canLaunchUrl(webUri)) {
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        }
      } catch (fallbackError) {
        debugPrint('Fallback also failed: $fallbackError');
      }
    }
  }

  static void launchDirections(String location) async {
    // URL encode the location string for proper handling of spaces and special characters
    String encodedLocation = Uri.encodeComponent(location);

    // Try Google Maps first, then fallback to Apple Maps on iOS
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
    final appleMapsUrl = 'https://maps.apple.com/?q=$encodedLocation';

    try {
      final googleUri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to Apple Maps
      final appleUri = Uri.parse(appleMapsUrl);
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
        return;
      }

      debugPrint('Could not launch maps application');
    } catch (e) {
      debugPrint('Error launching directions: $e');
    }
  }

  // Function to handle URL launches
  static Future<void> llaunchUrl(String url) async {
    try {
      // Ensure URL has a scheme
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(formattedUrl);

      bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('Failed to launch URL');
        }
      } else {
        throw Exception('Cannot launch URL');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Could not open link: $url",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  static Future<ShareResult?> shareContent({
    required String content,
    String? subject,
  }) async {
    try {
      await Share.share(
        content,
        subject: subject,
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
      );
    } catch (e) {
      debugPrint('Error sharing content: $e');
    }
    return null;
  }

  // select image from gallery

  static Future<String?> selectImageFromGallery({
    required BuildContext context,
    String? title,
  }) async {
    // use file picker to select an image from the gallery

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.path;
    }
    return null;
  }
}
