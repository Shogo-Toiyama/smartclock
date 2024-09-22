import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';
import 'package:timezone/timezone.dart' as tz;

const double borderRadius = 10;
const double borderWidth = 10;

class Clock extends HookConsumerWidget {
  const Clock({super.key, required this.dateTime, required this.location});

  final tz.TZDateTime dateTime;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final offsetAnimation = useMemoized(() => Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut)));

    void toggleMenu() {
      if (animationController.isDismissed) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }

    final menuBarrierOpacity = useState(0.0);

    final double fontSize = ref.watch(fontSizeProvider);
    int month = dateTime.month;
    int date = dateTime.day;
    int weekday = dateTime.weekday;
    int hour = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;

    List<String> weekdays = [
      '',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    bool daytime = (hour >= 7 && hour <= 19);
    Color clockBorderColor = daytime
        ? ColorPalette.clockBorderDaytime
        : ColorPalette.clockBorderNight;
    Color clockTextColor =
        daytime ? Colors.white : ColorPalette().customGrey(200);
    Color clockBGColor = daytime ? ColorPalette().customGrey(20) : Colors.black;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            debugPrint('$location: $dateTime');
          },
          child: Container(
            decoration: BoxDecoration(
                color: clockBGColor,
                boxShadow: [BoxShadow(color: clockBorderColor, blurRadius: 15)],
                borderRadius:
                    const BorderRadius.all(Radius.circular(borderRadius)),
                border: Border.all(
                  color: clockBorderColor,
                  width: borderWidth,
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
                            color: clockTextColor,
                            fontSize: fontSize * 0.6,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          toggleMenu();
                          menuBarrierOpacity.value = 1.0;
                        },
                        icon: Icon(
                          Icons.menu,
                          color: clockTextColor,
                          size: fontSize,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      '$month/$date  ${weekdays[weekday]}',
                      style: TextStyle(
                          color: clockTextColor,
                          fontSize: fontSize * 0.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${hour < 10 ? '0$hour' : hour} : ${min < 10 ? '0$min' : min}',
                      style: TextStyle(
                          color: clockTextColor,
                          fontSize: fontSize * 2,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        Text(
                          sec < 10 ? '0$sec' : sec.toString(),
                          style: TextStyle(
                              color: clockTextColor,
                              fontSize: fontSize * 1,
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
        ),
        Positioned(
          top: borderWidth,
          bottom: borderWidth,
          right: borderWidth,
          left: borderWidth,
          child: IgnorePointer(
            ignoring: menuBarrierOpacity.value == 0.0,
            child: AnimatedOpacity(
              opacity: menuBarrierOpacity.value,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorPalette().customGrey(40, opacity: 0.9)),
              ),
            ),
          ),
        ),
        Positioned(
          right: borderWidth,
          top: borderWidth,
          bottom: borderWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: SlideTransition(
              position: offsetAnimation,
              child: Container(
                color: clockBGColor,
                width: 230,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.notes, color: clockTextColor),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Detail',
                                    style: TextStyle(
                                        color: clockTextColor,
                                        fontSize: fontSize * 0.5),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.autorenew, color: clockTextColor),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                        color: clockTextColor,
                                        fontSize: fontSize * 0.5),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Icon(Icons.open_with, color: clockTextColor),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Move',
                                    style: TextStyle(
                                        color: clockTextColor,
                                        fontSize: fontSize * 0.5),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  const Icon(Icons.delete, color: Colors.red),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Remove',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: fontSize * 0.5),
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 10),
                            child: IconButton(
                                onPressed: () {
                                  toggleMenu();
                                  menuBarrierOpacity.value = 0.0;
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: fontSize,
                                  color: clockTextColor,
                                )),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
            borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
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
