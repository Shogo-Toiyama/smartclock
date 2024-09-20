import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class Clock extends StatelessWidget {
  const Clock({super.key, required this.dateTime, required this.location});

  final tz.TZDateTime dateTime;
  final String location;

  @override
  Widget build(BuildContext context) {
    int month = dateTime.month;
    int date = dateTime.day;
    int weekday = dateTime.weekday;
    int hour = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;

    List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return GestureDetector(
      onTap: () {
        debugPrint('$location: $dateTime');
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: (hour >= 7 && hour <= 19) ? Colors.yellow : Colors.blue,
              width: 7,
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '$month/$date  ${weekdays[weekday]}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${hour < 10 ? '0$hour' : hour} : ${min < 10 ? '0$min' : min}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text(
                      sec < 10 ? '0$sec' : sec.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
