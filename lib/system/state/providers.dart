import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/timezone.dart';
import 'package:smartclock/system/data/data_access.dart';
import 'package:timezone/timezone.dart' as tz;

// ----------------------------------------------------------------------
// class NameNotifier extends Notifier<type> {
//   @override
//   type build() {
//     return defaultValue;
//   }

//   void function(type newState){
//     state = newState;
// //      saveData('name', newState);
//   }
// }

// final nameProvider = NotifierProvider<NameNotifier, type>((){
//   return NameNotifier();
// });
// ----------------------------------------------------------------------

//
// Clock Index (decide what and how many clocks it shows)
class ClockIndexNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [];
  }

  void changeClockIndex(List<int> indexes) {
    state = indexes;
    ref.read(timesProvider.notifier).changeTimesList(state);
    saveData('clockIndex', state);
  }

  void addClockIndex(int index) {
    state.add(index);
    ref.read(timesProvider.notifier).changeTimesList(state);
    saveData('clockIndex', state);
  }
}

final clockIndexProvider = NotifierProvider<ClockIndexNotifier, List<int>>(() {
  return ClockIndexNotifier();
});

//
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

//
// Font Size (basic font size in this app)
class FontSizeNotifier extends Notifier<double> {
  @override
  double build() {
    return 25;
  }

  void changeFontSize(double newFontSize) {
    state = newFontSize;
    saveData('fontSize', newFontSize);
  }
}

final fontSizeProvider = NotifierProvider<FontSizeNotifier, double>(() {
  return FontSizeNotifier();
});

//
// Clock Move State (whether a clock is selected to move or not)
int moveFrom = -1;

class ClockMoveStateNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void selecting(selectingIndex) {
    moveFrom = selectingIndex;
    state = 1;
  }

  void selected(int moveTo) {
    List<int> clockIndex = ref.read(clockIndexProvider);
    if (moveFrom > -1 &&
        moveFrom < clockIndex.length &&
        moveTo > -1 &&
        moveTo < clockIndex.length) {
      if (moveTo == moveFrom) {
        moveFrom = -1;
        state = 0;
      } else {
        log('Move $moveFrom to $moveTo.');
        int valOfMoveFrom = clockIndex[moveFrom];
        clockIndex.removeAt(moveFrom);
        clockIndex.insert(moveTo, valOfMoveFrom);
        ref.read(clockIndexProvider.notifier).changeClockIndex(clockIndex);
        moveFrom = -1;
        state = 0;
      }
    }
  }
}

final clockMoveStateProvider =
    NotifierProvider<ClockMoveStateNotifier, int>(() {
  return ClockMoveStateNotifier();
});

//
// Show Add-Clock Button (decide whether it should be shown or not)
class ShowAddClockButtonNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void changeState(bool newState) {
    state = newState;
  }
}

final showAddClockButtonProvider =
    NotifierProvider<ShowAddClockButtonNotifier, bool>(() {
  return ShowAddClockButtonNotifier();
});
