import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_pref/src/models/person_model.dart';

class HiveService {
  static Future<bool> initService() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PersonModelAdapter());
    return true;
  }

  static Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    } else {
      return Hive.openBox<T>(name);
    }
  }

  static Future<int> writeToBox<T>(Box<T> box, T data) {
    return box.add(data);
  }

  static Future<void> remove<T>(Box<T> box, int index) {
    return box.deleteAt(index);
  }
}
