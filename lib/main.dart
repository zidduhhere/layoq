import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/providers.dart';
import 'screens/auth_screen.dart';
import 'screens/root_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  runApp(const ProviderScope(child: LayoqApp()));
}

class LayoqApp extends ConsumerWidget {
  const LayoqApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(isSignedInProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layoq',
      theme: AppTheme.light,
      home: signedIn ? const RootShell() : const AuthScreen(),
    );
  }
}
