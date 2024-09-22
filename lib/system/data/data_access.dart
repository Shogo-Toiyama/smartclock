import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

Future<void> saveData<T>(String key, T value) async {
  var box = await Hive.openBox('settingsBox');
  box.put(key, value);
}

Future<T?> loadData<T>(String key) async {
  var box = Hive.box('settingsBox');
  return box.get(key) as T?;
}

Future<List<int>?> loadDataListInt(String key) async {
  try {
    final dynamic result = await loadData<dynamic>(key);
    if (result is List) {
      return result.map((e) => e as int).toList();
    } else {
      return null;
    }
  } catch (e) {
    log('Error loading list of int: $e');
    return null;
  }
}

Future<void> resetAll() async {
  
}