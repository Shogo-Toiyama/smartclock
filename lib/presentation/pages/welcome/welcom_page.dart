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
    Future<void> loadInitialData() async {
      try {
        final clockIndex = await loadDataListInt('clockIndex');
        final fontSize = await loadData('fontSize');
        debugPrint('clockIndex: $clockIndex, fontsize: $fontSize');
        if (clockIndex != null) {
          ref.read(clockIndexProvider.notifier).changeClockIndex(clockIndex);
        }
        if (fontSize != null) {
          ref.read(fontSizeProvider.notifier).changeFontSize(fontSize);
        }
        debugPrint('Initial data loaded: \n   clockIndex: $clockIndex');
      } catch (e) {
        log('Error loading data: $e');
      }
    }

    useEffect(() {
      Future.microtask(() async {
        debugPrint('in the useEffect');
        await loadInitialData();
        if (context.mounted) {
          context.pushReplacement(PagePath.homePage);
        debugPrint('Go to home page');
        }
      });
      return null;
    }, []);

    return Container(
      decoration: BoxDecoration(color: Colors.red),
    );
  }
}
