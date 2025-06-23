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
    // Clean the WhatsApp number (remove spaces, dashes, etc.)
    String cleanNumber = whatsapp.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure the number starts with country code
    if (!cleanNumber.startsWith('+')) {
      // If no country code, you might want to add a default one
      // For example, if most numbers are from a specific country
      cleanNumber = '+$cleanNumber';
    }

    final uri = Uri.parse('https://wa.me/$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp');
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
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
}
