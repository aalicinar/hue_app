import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Global ThemeMode provider — toggle between light & dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class HueApp extends ConsumerWidget {
  const HueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Hue',
      debugShowCheckedModeBanner: false,
      theme: buildHueLightTheme(),
      darkTheme: buildHueDarkTheme(),
      themeMode: mode,
      routerConfig: appRouter,
    );
  }
}
