import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/clocks_page.dart';
import 'package:smartclock/presentation/pages/clocks/timezone.dart';
import 'package:smartclock/presentation/pages/note/note_page.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNameHook = useState<String>('Clock');
    double iconSize = 48;

    const Map<String, Widget> pages = {
      'Clock': ClocksPage(),
      'Note': NotePage(),
    };

    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Center(
            child: pages[pageNameHook.value]
          )),
          const VerticalDivider(),
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Clock';
                  getCurrentTimes([0, 1, 2, 3, 4, 5]);
                },
                icon: Icon(
                  Icons.watch_later,
                  size: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Calendar';
                },
                icon: Icon(
                  Icons.calendar_month,
                  size: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Note';
                },
                icon: Icon(
                  Icons.edit_note,
                  size: iconSize,
                ),
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Notification';
                },
                icon: Icon(
                  Icons.notifications,
                  size: iconSize,
                ),
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
              ),
              IconButton(
                onPressed: () {
                  pageNameHook.value = 'Power';
                },
                icon: Icon(
                  Icons.power_settings_new,
                  size: iconSize,
                ),
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
