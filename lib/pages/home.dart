import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:simple_duet/controller.dart/history_controller.dart';
import 'package:simple_duet/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:simple_duet/pages/categories.dart';
import 'package:simple_duet/pages/item_detail.dart';
import 'package:simple_duet/pages/widget/expenses_sheet.dart';
import 'package:simple_duet/pages/widget/income_sheet.dart';
import 'package:simple_duet/utils/constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Iterable<CategoryModel>? category;

  @override
  Widget build(BuildContext context) {
    final history = historyController.history.watch(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simple Duet'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Categories()),
              );
            },
            icon: const Icon(Icons.category),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: Text(
                currency.format((history.value ?? []).fold(
                    0,
                    (p, c) =>
                        c.income != null ? p + c.income! : p - c.expenses!)),
                style: ShadTheme.of(context).textTheme.h1,
              ),
            ),
            Text(
              'uang anda',
              style: ShadTheme.of(context).textTheme.p,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  onPressed: () {
                    showShadSheet(
                      side: ShadSheetSide.bottom,
                      context: context,
                      builder: (context) =>
                          const IncomeSheet(side: ShadSheetSide.bottom),
                    );
                  },
                  text: const Text('Pemasukan'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.add,
                      size: 16,
                    ),
                  ),
                ),
                ShadButton(
                  onPressed: () {
                    showShadSheet(
                      side: ShadSheetSide.bottom,
                      context: context,
                      builder: (context) =>
                          const ExpensesSheet(side: ShadSheetSide.bottom),
                    );
                  },
                  text: const Text('Pengeluaran'),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: const Text('History'),
              trailing: const Icon(Icons.filter_list),
              onTap: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                  ),
                  dialogSize: const Size(325, 400),
                  value: historyController.dateRange.watch(context),
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null) {
                  historyController.dateRange.value = [
                    results.first!,
                    results.last!
                  ];
                }
              },
            ),
            history.map(
              data: (item) {
                if (item.isEmpty) {
                  return const Text('There is no history');
                }
                return Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: item.map(
                      (i) => ListTile(
                        title: Text(
                          currency.format(i.income ?? i.expenses),
                          style: TextStyle(
                              color: i.income == null
                                  ? Colors.red
                                  : Colors.green[600]),
                        ),
                        subtitle: Text(i.description ?? ''),
                        trailing: Text(dateWithoutTime.format(i.updated)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetail(item: i)),
                          );
                        },
                      ),
                    ),
                  ).toList(),
                );
              },
              error: (error, __) => Text('$error'),
              loading: () => const CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
