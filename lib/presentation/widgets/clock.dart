import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';
import 'package:timezone/timezone.dart' as tz;

double borderRadius = 10;

class Clock extends ConsumerWidget {
  const Clock({super.key, required this.dateTime, required this.location});

  final tz.TZDateTime dateTime;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.watch(fontSizeProvider);
    int month = dateTime.month;
    int date = dateTime.day;
    int weekday = dateTime.weekday;
    int hour = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;

    List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    bool daytime = (hour >= 7 && hour <= 19);

    return GestureDetector(
      onTap: () {
        debugPrint('$location: $dateTime');
      },
      child: Container(
        decoration: BoxDecoration(
            color: daytime ? ColorPalette().customGrey(20) : Colors.black,
            boxShadow: [
              BoxShadow(
                  color: daytime
                      ? ColorPalette.clockBorderDaytime
                      : ColorPalette.clockBorderNight,
                  blurRadius: 15)
            ],
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border: Border.all(
              color: daytime
                  ? ColorPalette.clockBorderDaytime
                  : ColorPalette.clockBorderNight,
              width: 10,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Text(
                    location,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: daytime
                            ? Colors.white
                            : ColorPalette().customGrey(200),
                        fontSize: fontSize * 0.7,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '$month/$date  ${weekdays[weekday]}',
                  style: TextStyle(
                      color: daytime
                          ? Colors.white
                          : ColorPalette().customGrey(200),
                      fontSize: fontSize * 0.7,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${hour < 10 ? '0$hour' : hour} : ${min < 10 ? '0$min' : min}',
                  style: TextStyle(
                      color: daytime
                          ? Colors.white
                          : ColorPalette().customGrey(200),
                      fontSize: fontSize * 2,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      sec < 10 ? '0$sec' : sec.toString(),
                      style: TextStyle(
                          color: daytime
                              ? Colors.white
                              : ColorPalette().customGrey(200),
                          fontSize: fontSize * 0.7,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddClock extends ConsumerWidget {
  const AddClock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.watch(fontSizeProvider);
    List<int> clockIndex = ref.watch(clockIndexProvider);
    return GestureDetector(
      onTap: () {
        clockIndex.add(clockIndex.length);
        ref.read(clockIndexProvider.notifier).changeClockIndex(clockIndex);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border: Border.all(
              color: Colors.grey,
              width: 10,
            )),
        child: Center(
          child: Text('+',
              style: TextStyle(color: Colors.white, fontSize: fontSize * 3)),
        ),
      ),
    );
  }
}
