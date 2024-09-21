import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/clocks_page.dart';
import 'package:smartclock/presentation/pages/note/note_page.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.watch(fontSizeProvider);
    final pageNameHook = useState<String>('Clock');
    double iconSize = fontSize * 2;

    const Map<String, Widget> pages = {
      'Clock': ClocksPage(),
      'Note': NotePage(),
    };

    return Scaffold(
      backgroundColor: ColorPalette().customGrey(20),
      body: Row(
        children: [
          Expanded(child: Center(child: pages[pageNameHook.value])),
          const VerticalDivider(),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Clock';
                },
                icon: Icon(
                  Icons.watch_later,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Clock'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Calendar';
                },
                icon: Icon(
                  Icons.calendar_month,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Calender'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Note';
                },
                icon: Icon(
                  Icons.edit_note,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Note'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Notification';
                },
                icon: Icon(
                  Icons.notifications,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Notification'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Setting';
                },
                icon: Icon(
                  Icons.settings,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Setting'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Power';
                },
                icon: Icon(
                  Icons.power_settings_new,
                  size: iconSize,
                ),
                color: pageNameHook.value == 'Power'
                    ? Colors.white
                    : ColorPalette().customGrey(70),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
