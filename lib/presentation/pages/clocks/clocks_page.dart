import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/locations.dart';
import 'package:smartclock/presentation/widgets/clock.dart';
import 'package:smartclock/presentation/widgets/clock_select_menu.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';

class ClocksPage extends HookConsumerWidget {
  const ClocksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clockIndexes = ref.watch(clockIndexProvider);
    final datetimes = ref.watch(timesProvider);

    int findInterval() {
      DateTime now = DateTime.now();
      int interval = 3600 - (now.minute * 60 + now.second);
      return interval;
    }

    useEffect(() {
      Future.microtask(() {
        ref.read(timesProvider.notifier).changeTimesList(clockIndexes);
      });
      return null;
    }, []);

    useEffect(() {
      int interval = findInterval();
      int counter = 0;
      Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        ref.read(timesProvider.notifier).incrementOneSec();
        if (counter == interval) {
          ref.read(timesProvider.notifier).changeTimesList(clockIndexes);
          counter = 0;
          interval = findInterval();
        }
        counter += 1;
      });
      return timer.cancel;
    }, []);

    List<String> cityNames = [for (var cityName in locations.keys) cityName];

    return Scaffold(
      backgroundColor: ColorPalette.pageBackground,
      body: GridView.count(
          padding: const EdgeInsets.all(30),
          crossAxisCount: 3,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          childAspectRatio: 1.6,
          children: [
            for (int i = 0; i < datetimes.length; i++)
              Clock(
                thisIndex: i,
                dateTime: datetimes[i],
                location: cityNames[clockIndexes[i]],
              ),
            AddClock(
              onTap: (BuildContext context) {
                showClockSelectMenu(context, null);
              },
            ),
          ]),
    );
  }
}

void showClockSelectMenu(BuildContext context, int? changeIndex) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 450,
            width: 700,
            child: ClockSelectMenu(changeIndex: changeIndex),
          ),
        );
      });
}
