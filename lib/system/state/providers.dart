import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclock/presentation/pages/clocks/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class ClockIndexNotifier extends Notifier<List<int>> {
  @override
  List<int> build() {
    return [for (int i = 0; i < 13; i++) i];
  }

  void changeClockIndex(List<int> indexes) {
    state = indexes;
  }
}

final clockIndexProvider = NotifierProvider<ClockIndexNotifier, List<int>>(() {
  return ClockIndexNotifier();
});


class TimesNotifier extends Notifier<List<tz.TZDateTime>> {

  @override
  List<tz.TZDateTime> build() {
    return [];
  }

  void changeTimesList(List<int> indexes) {
    state = getCurrentTimes(indexes);
  }

  void incrementOneSec() {
    state = [
      for (var time in state) 
        time.add(const Duration(seconds: 1))
    ];
  }
}

final timesProvider = NotifierProvider<TimesNotifier, List<tz.TZDateTime>>(() {
  return TimesNotifier();
});