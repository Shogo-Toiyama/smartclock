import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/router/page_path.dart';
import 'package:smartclock/system/data/data_access.dart';
import 'package:smartclock/system/state/providers.dart';

class WelcomPage extends HookConsumerWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('WelcomePage built');
    Future<void> loadInitialData() async {
      try {
        List<int>? clockIndex = await loadDataListInt('clockIndex');
        double? fontSize = await loadData('fontSize');
        clockIndex ??= [];
        ref.read(clockIndexProvider.notifier).changeClockIndex(clockIndex);
        fontSize ??= 35;
        ref.read(fontSizeProvider.notifier).changeFontSize(fontSize);
      } catch (e) {
        log('Error loading data: $e');
      }
    }

    final titleOpacity = useState(0.0);

    useEffect(() {
      Future.microtask(() async {
        await Future.delayed(const Duration(seconds: 1));
        await loadInitialData();
        titleOpacity.value = 1.0;
        await Future.delayed(const Duration(seconds: 3));
        titleOpacity.value = 0.0;
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.pushReplacement(PagePath.homePage);
        } else {}
      });
      return null;
    }, []);

    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Center(
        child: AnimatedOpacity(
          opacity: titleOpacity.value,
          duration: const Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 150,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'SMARTCLOCK',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
