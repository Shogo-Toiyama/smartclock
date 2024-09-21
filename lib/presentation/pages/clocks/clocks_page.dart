import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/locations.dart';
import 'package:smartclock/presentation/widgets/clock.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';

class ClocksPage extends HookConsumerWidget {
  const ClocksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockIndexes = ref.watch(clockIndexProvider);
    final datetimes = ref.watch(timesProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(timesProvider.notifier).changeTimesList(clockIndexes);
      });
      return null;
    }, []);

    useEffect(() {
      Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        ref.read(timesProvider.notifier).incrementOneSec();
      });
      return timer.cancel;
    }, []);

    List<String> cityNames = [for (var cityName in locations.keys) cityName];

    return Scaffold(
      backgroundColor: ColorPalette().customGrey(40),
      body: GridView.count(
          padding: const EdgeInsets.all(30),
          crossAxisCount: 3,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          childAspectRatio: 1.6,
          children: [
            for (int i = 0; i < datetimes.length; i++)
              Clock(
                dateTime: datetimes[i],
                location: cityNames[clockIndexes[i]],
              ),
            const AddClock(),
          ]),
    );
  }
}
