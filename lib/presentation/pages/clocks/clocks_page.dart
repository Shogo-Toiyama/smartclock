import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/locations.dart';
import 'package:smartclock/presentation/widgets/clock.dart';
import 'package:smartclock/system/state/providers.dart';

class ClocksPage extends HookConsumerWidget {
  const ClocksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeIndexes = ref.watch(clockIndexProvider);
    useEffect((){
      Future.microtask((){
        ref.read(timesProvider.notifier).changeTimesList(timeIndexes);
      });
      return null;
    }, []);
    final datetimes = ref.watch(timesProvider);

    useEffect((){
      Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        ref.read(timesProvider.notifier).incrementOneSec();
      });
      return timer.cancel;
    }, []);
    
    List<String> cityNames = [for(var cityName in locations.keys) cityName];

    return Scaffold(
      body: GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
          children: [
            for (int i = 0; i < datetimes.length; i++)
              Clock(
                dateTime: datetimes[i],
                location: cityNames[i],
              ),
          ]),
    );
  }
}
