import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true),
        onDetect: (capture) {
          String? info = capture.barcodes.first.rawValue;
          if (info != null) {
            print("PRINT: $info");
            final formattedStr = info.toString().replaceAll("'", "\"");
            final Map<String, dynamic> data = jsonDecode(formattedStr);
            print("PRINT: $data");
            final id = data['id'] as String?;
            final name = data['name'] as String?;
            final school = data['school'] as String?;

            print("PRINT: $id, $name, $school");
          }
        },
      ),
    );
  }
}

void main() {
  const str = "{'id': '012345', 'name':'simon'}";

  // Replace single quotes with double quotes to make it valid JSON
  final formattedStr = str.replaceAll("'", "\"");
  print(formattedStr);

  // Parse the JSON string into a Map
  final Map<String, dynamic> data = jsonDecode(formattedStr);

  print(data);
}
