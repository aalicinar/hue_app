import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class HueApp extends ConsumerWidget {
  const HueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Hue',
      debugShowCheckedModeBanner: false,
      theme: buildHueTheme(),
      routerConfig: appRouter,
    );
  }
}
