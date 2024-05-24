import 'package:signals/signals_flutter.dart';
import 'package:simple_duet/service/database.dart';

class CategoryController {
  final categories = futureSignal(() async => Database().readCategories());
}

final categoryController = CategoryController();
