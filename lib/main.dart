import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/presentation/router/router.dart';

main() {
  const app = MaterialApp(home: MyApp());
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = RouterClass().getRouter();
    return MaterialApp.router(
      title: 'smartclock',
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
