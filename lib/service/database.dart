import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_duet/model/category_model.dart';
import 'package:simple_duet/model/item_model.dart';

class Database {
  late Future<Isar> db;

  Database() {
    db = openDB();
  }

  // item
  Future<void> createItem(ItemModel val) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.itemModels.putSync(val));
  }

  Future<List<ItemModel>> readItems(
      {required DateTime start, required DateTime end}) async {
    final isar = await db;
    IsarCollection<ItemModel> itemCollection = isar.collection<ItemModel>();
    return await itemCollection
        .where()
        .filter()
        .createdBetween(start.copyWith(hour: 0, minute: 0, second: 0),
            end.copyWith(hour: 23, minute: 59, second: 59))
        .findAll();
  }

  Future<void> updateItem(ItemModel val) async {
    final isar = await db;
    await isar.writeTxn<int>(() async => await isar.itemModels.put(val));
  }

  Future<void> deleteItem(int val) async {
    final isar = await db;
    await isar.writeTxn<bool>(() async => await isar.itemModels.delete(val));
  }

  // category
  Future<void> createCategory(CategoryModel val) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.categoryModels.putSync(val));
  }

  Future<List<CategoryModel>> readCategories() async {
    final isar = await db;
    IsarCollection<CategoryModel> categoryCollection =
        isar.collection<CategoryModel>();
    return await categoryCollection.where().findAll();
  }

  Future<void> updateCategory(CategoryModel val) async {
    final isar = await db;
    await isar.writeTxn<int>(() async => await isar.categoryModels.put(val));
  }

  Future<void> deleteCategory(int val) async {
    final isar = await db;
    await isar
        .writeTxn<bool>(() async => await isar.categoryModels.delete(val));
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [ItemModelSchema, CategoryModelSchema],
        directory: dir.path,
        inspector: true,
      );

      return isar;
    }

    return Future.value(Isar.getInstance());
  }
}
