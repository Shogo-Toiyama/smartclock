import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/locations.dart';
import 'package:smartclock/system/materials/color_palette.dart';
import 'package:smartclock/system/state/providers.dart';

class ClockSelectMenu extends ConsumerWidget {
  const ClockSelectMenu({super.key, this.changeIndex});

  final int? changeIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double fontSize = ref.read(fontSizeProvider);
    List<int> currentClockIndex = ref.read(clockIndexProvider);
    List<String> allLocations = locations.keys.toList();
    Set<int> allLocationIndex = {for(int i=0; i<allLocations.length; i++) i};
    List<int> remainingClockIndex = allLocationIndex.difference(currentClockIndex.toSet()).toList();
    return Container(
      decoration: BoxDecoration(
          color: ColorPalette().customGrey(50),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Select a world clock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    onPressed: () {Navigator.of(context).pop();},
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: fontSize,
                    )),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                for (int i in remainingClockIndex)
                  ClockMenuTile(changeIndex: changeIndex, index: i, location: allLocations[i])
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClockMenuTile extends ConsumerWidget {
  const ClockMenuTile({super.key, this.changeIndex, required this.index, required this.location});
  final int? changeIndex;
  final int index;
  final String location;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double fontSize = ref.read(fontSizeProvider);
    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        if (changeIndex==null){
          ref.read(clockIndexProvider.notifier).addClockIndex(index);
        }
        else {
          List<int> indexes = ref.read(clockIndexProvider);
          indexes[changeIndex!] = index;
          ref.read(clockIndexProvider.notifier).changeClockIndex(indexes);
        }
      },
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          location,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize * 0.7,
          ),
        ),
      ),
    );
  }
}
