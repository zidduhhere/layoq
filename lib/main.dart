import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/root_shell.dart';

void main() {
  runApp(const LayoqApp());
}

class LayoqApp extends StatelessWidget {
  const LayoqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layoq',
      theme: AppTheme.light,
      home: const RootShell(),
    );
  }
}
