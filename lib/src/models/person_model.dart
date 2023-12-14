import 'package:hive_flutter/hive_flutter.dart';

part 'person_model.g.dart';

@HiveType(typeId: 1)
class PersonModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<PersonModel> friends;

  PersonModel({required this.age, required this.friends, required this.name});

  factory PersonModel.empty() => PersonModel(age: 0, friends: [], name: '');
}
