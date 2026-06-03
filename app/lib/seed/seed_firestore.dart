import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../firebase_options.dart';
import 'firestore_seeder.dart';

/// Standalone entry point that populates Firestore with the mock dataset.
///
/// Run it instead of the app:
///   flutter run -t lib/seed/seed_firestore.dart -d chrome
///
/// Writes use deterministic ids, so it is safe to run repeatedly. The catalog
/// collections are seeded with unauthenticated writes — run this while the
/// database security rules allow it (test mode / your dev rules), then deploy
/// the locked-down `firestore.rules`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String message;
  bool ok;
  try {
    final summary = await FirestoreSeeder(FirebaseFirestore.instance).run();
    message = summary.toString();
    ok = true;
    debugPrint('✅ $message');
  } catch (e) {
    message = 'Falha ao popular o Firestore: $e';
    ok = false;
    debugPrint('❌ $message');
  }

  runApp(_SeedApp(message: message, ok: ok));
}

class _SeedApp extends StatelessWidget {
  const _SeedApp({required this.message, required this.ok});

  final String message;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ok ? Icons.check_circle_outline : Icons.error_outline,
                  size: 48,
                  color: ok ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  ok ? 'Firestore populado' : 'Erro no seed',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
