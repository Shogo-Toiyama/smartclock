import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartclock/presentation/router/router.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  final app = DevicePreview(
    enabled: true,
    builder: (context) => const ProviderScope(child: MyApp()),
  );
  runApp(app);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = RouterClass().getRouter();
    return MaterialApp.router(
      title: 'smartclock',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
