import 'package:get_it/get_it.dart';
import 'package:simple_duet/service/database.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<Database>(() => Database());
}
