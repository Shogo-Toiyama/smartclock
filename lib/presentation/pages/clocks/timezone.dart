import 'package:smartclock/presentation/pages/clocks/locations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

List<tz.TZDateTime> getCurrentTimes(List<int> indexes) {
  tz.initializeTimeZones();
  List<tz.TZDateTime> currentTimes = [];
  List<String> cityIds = [for(var cityId in locations.values) cityId];

  for (int i in indexes) {
    var location = tz.getLocation(cityIds[i]);
    var now = tz.TZDateTime.now(location);
    currentTimes.add(now);
  }

  return currentTimes;
}
