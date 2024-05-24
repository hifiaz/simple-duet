import 'package:signals/signals_flutter.dart';
import 'package:simple_duet/service/database.dart';

class HistoryController {
  final dateRange = listSignal(
      [DateTime.now().subtract(const Duration(days: 31)), DateTime.now()]);
  final history = futureSignal(
    () async => Database().readItems(
        start: historyController.dateRange.first,
        end: historyController.dateRange.last),
  );
}

final historyController = HistoryController();
