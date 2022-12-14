import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class DataModel{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool complete;

  DataModel({required this.title, required this.description, required this.complete});

}