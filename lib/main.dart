import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartclock/presentation/router/router.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  final app = kReleaseMode
      ? const ProviderScope(child: MyApp())
      : DevicePreview(
          enabled: true,
          builder: (context) => const ProviderScope(child: MyApp()),
        );
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
