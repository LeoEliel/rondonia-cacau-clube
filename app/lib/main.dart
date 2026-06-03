import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/cacau_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Run inside a guarded zone so uncaught async errors reach Crashlytics.
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crash reporting: forward Flutter + platform errors to Crashlytics.
      // Disabled in debug so local runs don't pollute the dashboard.
      // Crashlytics has no web implementation, so it is skipped on web —
      // initializing it before runApp would throw and leave a blank page.
      if (!kIsWeb) {
        final crashlytics = FirebaseCrashlytics.instance;
        await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
        FlutterError.onError = crashlytics.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          crashlytics.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Analytics instance is created up front so it is ready for screen
      // tracking once feature navigation is wired.
      FirebaseAnalytics.instance;

      // Local storage is resolved before the UI so synchronous controllers
      // (e.g. ThemeController) can read persisted state immediately.
      final prefs = await SharedPreferences.getInstance();
      Get.put<SharedPreferences>(prefs, permanent: true);

      runApp(const CacauClubeApp());
    },
    (error, stack) {
      if (kIsWeb) {
        // No Crashlytics on web; surface the error to the console instead.
        FlutterError.presentError(
          FlutterErrorDetails(exception: error, stack: stack),
        );
        return;
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
