import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/main_tabs_screen/widgets/app_widget.dart';
import 'package:rotaract/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only wait for critical initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up error handling immediately
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Start the app immediately to avoid blocking the main thread
  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );

  // Initialize non-critical services after app starts
  _initializeBackgroundServices();
}

void _initializeBackgroundServices() {
  // Use microtask to defer execution and avoid blocking
  scheduleMicrotask(() async {
    // Initialize Firebase App Check
    await FirebaseAppCheck.instance.activate();

    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Set preferred orientations after app initialization
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  });
}
