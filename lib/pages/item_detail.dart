import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_duet/controller.dart/history_controller.dart';
import 'package:simple_duet/model/item_model.dart';
import 'package:simple_duet/pages/widget/expenses_sheet.dart';
import 'package:simple_duet/pages/widget/income_sheet.dart';
import 'package:simple_duet/service/database.dart';
import 'package:simple_duet/utils/constant.dart';

class ItemDetail extends StatelessWidget {
  final ItemModel item;
  const ItemDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          ShadButton.ghost(
            text: const Text('Edit'),
            onPressed: () {
              showShadSheet(
                side: ShadSheetSide.right,
                context: context,
                builder: (context) => item.expenses != null
                    ? ExpensesSheet(side: ShadSheetSide.right, item: item)
                    : IncomeSheet(side: ShadSheetSide.right, item: item),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateWithoutTime.format(item.updated),
              style: ShadTheme.of(context).textTheme.p,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currency.format(item.income ?? item.expenses),
                  style: ShadTheme.of(context).textTheme.h4.copyWith(
                        color: item.income == null
                            ? Colors.red
                            : Colors.green[600],
                      ),
                ),
                Text(
                  item.category.capitalized(),
                  style: ShadTheme.of(context).textTheme.muted,
                )
              ],
            ),
            const SizedBox(height: 16),
            Text('Note', style: ShadTheme.of(context).textTheme.lead),
            Text(
              item.description ?? '',
              style: ShadTheme.of(context).textTheme.p,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ShadButton.destructive(
                text: const Text('Delete'),
                onPressed: () async {
                  await Database().deleteItem(item.id);
                  await historyController.history.refresh();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
