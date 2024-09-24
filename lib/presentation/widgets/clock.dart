import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/clocks_page.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';
import 'package:timezone/timezone.dart' as tz;

const double borderRadius = 10;
const double borderWidth = 10;

class Clock extends HookConsumerWidget {
  const Clock(
      {super.key,
      required this.thisIndex,
      required this.dateTime,
      required this.location});
  final int thisIndex;
  final tz.TZDateTime dateTime;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuBarrierOpacity = useState(0.0);
    final moveHereOpacity = useState(0.0);
    final moveCancelOpacity = useState(0.0);
    final removeAlartOpacity = useState(0.0);
    final selectingThisClock = useState(false);

    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));

    final offsetAnimation = useMemoized(() => Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut)));

    void toggleMenu() {
      if (animationController.isDismissed) {
        menuBarrierOpacity.value = 1.0;
        animationController.forward();
      } else {
        animationController.reverse();
        menuBarrierOpacity.value = 0.0;
      }
    }

    final double fontSize = ref.read(fontSizeProvider);
    int moveState = ref.watch(clockMoveStateProvider);

    useEffect(() {
      if (moveState == 1 && !selectingThisClock.value) {
        moveHereOpacity.value = 1.0;
      } else if (moveState == 1 && selectingThisClock.value) {
        moveCancelOpacity.value = 1.0;
      } else if (moveState == 0) {
        moveHereOpacity.value = 0.0;
        moveCancelOpacity.value = 0.0;
        selectingThisClock.value = false;
      }
      return null;
    }, [moveState]);

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
          onTap: () {},
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
                              onTap: () {
                                toggleMenu();
                              },
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
                              onTap: () {
                                toggleMenu();
                                showClockSelectMenu(context, thisIndex);
                              },
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
                              onTap: () {
                                selectingThisClock.value = true;
                                toggleMenu();
                                ref
                                    .read(clockMoveStateProvider.notifier)
                                    .selecting(thisIndex);
                                ref
                                    .read(showAddClockButtonProvider.notifier)
                                    .changeState(false);
                              },
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
                              onTap: () {
                                toggleMenu();
                                ref
                                    .read(showAddClockButtonProvider.notifier)
                                    .changeState(false);
                                removeAlartOpacity.value = 1.0;
                              },
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
        Positioned(
          top: borderWidth,
          bottom: borderWidth,
          right: borderWidth,
          left: borderWidth,
          child: IgnorePointer(
            ignoring: removeAlartOpacity.value == 0.0,
            child: AnimatedOpacity(
              opacity: removeAlartOpacity.value,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorPalette().customGrey(40, opacity: 0.9)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Are you sure you want to \nremove this clock?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize * 0.5,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton(
                              onPressed: () {
                                removeAlartOpacity.value = 0.0;
                                List<int> clockIndex =
                                    ref.read(clockIndexProvider);
                                clockIndex.removeAt(thisIndex);
                                ref
                                    .read(clockIndexProvider.notifier)
                                    .changeClockIndex(clockIndex);
                                ref
                                    .read(showAddClockButtonProvider.notifier)
                                    .changeState(true);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    fontSize: fontSize * 0.5,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton(
                              onPressed: () {
                                removeAlartOpacity.value = 0.0;
                                ref
                                    .read(showAddClockButtonProvider.notifier)
                                    .changeState(true);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontSize: fontSize * 0.5,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: borderWidth,
          bottom: borderWidth,
          right: borderWidth,
          left: borderWidth,
          child: IgnorePointer(
            ignoring: moveCancelOpacity.value == 0.0,
            child: AnimatedOpacity(
              opacity: moveCancelOpacity.value,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorPalette().customGrey(40, opacity: 0.9)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(clockMoveStateProvider.notifier)
                            .selected(thisIndex);
                        ref
                            .read(showAddClockButtonProvider.notifier)
                            .changeState(true);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: fontSize * 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: borderWidth,
          bottom: borderWidth,
          right: borderWidth,
          left: borderWidth,
          child: IgnorePointer(
            ignoring: moveHereOpacity.value == 0.0,
            child: AnimatedOpacity(
              opacity: moveHereOpacity.value,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorPalette().customGrey(40, opacity: 0.9)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(clockMoveStateProvider.notifier)
                            .selected(thisIndex);

                        ref
                            .read(showAddClockButtonProvider.notifier)
                            .changeState(true);
                      },
                      icon: const Icon(
                        Icons.beenhere,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Move here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.5,
                      ),
                    )
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
  const AddClock({super.key, required this.onTap});

  final Function(BuildContext)? onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.read(fontSizeProvider);
    return Visibility(
      visible: ref.watch(showAddClockButtonProvider),
      child: GestureDetector(
        onTap: (){
          if (onTap != null) {
            onTap!(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              border: Border.all(
                color: Colors.grey,
                width: 10,
              )),
          child: Center(
            child: Text('+',
                style: TextStyle(color: Colors.white, fontSize: fontSize * 3)),
          ),
        ),
      ),
    );
  }
}
