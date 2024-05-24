import 'package:isar/isar.dart';

part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  int? expenses;
  int? income;
  late String category;
  late DateTime created;
  late DateTime updated;
}
