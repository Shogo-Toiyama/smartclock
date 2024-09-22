import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/timezone.dart';
import 'package:smartclock/system/data/data_access.dart';
import 'package:timezone/timezone.dart' as tz;

// ----------------------------------------------------------------------
// class NameNotifier extends Notifier<type> {
//   @override
//   type build() {
//     _loadName();
//     return default_value;
//   }

//   Future<void> _loadName() async {
//     final name = await loadData<type>('name');
//     if (name != null) {
//       state = name;
//     }
//   }

//   void function(type new_value){
//     state = new_value;
//     saveData('name', new_value);
//   }
// }

// final nameProvider = NotifierProvider<NameeNotifier, type>((){
//   return NameNotifier();
// });
// ----------------------------------------------------------------------

// Clock Index (decide what and how many clocks it shows)
class ClockIndexNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    _loadClockIndex();
    return [];
  }

  Future<void> _loadClockIndex() async {
    try {
      final clockIndex = await loadDataListInt('clockIndex');
      if (clockIndex != null) {
        state = clockIndex;
      }
    } catch (e) {
      log('Error loading clockIndex: $e');
    }
  }

  void changeClockIndex(List<int> indexes) {
    state = indexes;
    ref.read(timesProvider.notifier).changeTimesList(indexes);
    saveData('clockIndex', indexes);
  }
}

final clockIndexProvider = NotifierProvider<ClockIndexNotifier, List<int>>(() {
  return ClockIndexNotifier();
});

// Times (list of times that is shown)
class TimesNotifier extends Notifier<List<tz.TZDateTime>> {
  @override
  List<tz.TZDateTime> build() {
    return [];
  }

  void changeTimesList(List<int> indexes) {
    state = getCurrentTimes(indexes);
  }

  void incrementOneSec() {
    state = [for (var time in state) time.add(const Duration(seconds: 1))];
  }
}

final timesProvider = NotifierProvider<TimesNotifier, List<tz.TZDateTime>>(() {
  return TimesNotifier();
});

// Font Size (basic font size in this app)
class FontSizeNotifier extends Notifier<double> {
  @override
  double build() {
    _loadFontSize();
    return 35;
  }

  Future<void> _loadFontSize() async {
    final fontSize = await loadData('fontSize');
    if (fontSize != null) {
      state = fontSize;
    }
  }

  void changeFontSize(double newFontSize) {
    state = newFontSize;
    saveData('fontSize', newFontSize);
  }
}

final fontSizeProvider = NotifierProvider<FontSizeNotifier, double>(() {
  return FontSizeNotifier();
});
