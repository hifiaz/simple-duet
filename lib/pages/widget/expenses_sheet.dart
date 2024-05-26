import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:simple_duet/controller.dart/category_controller.dart';
import 'package:simple_duet/controller.dart/history_controller.dart';
import 'package:simple_duet/model/category_model.dart';
import 'package:simple_duet/model/item_model.dart';
import 'package:simple_duet/pages/categories/categories_form.dart';
import 'package:simple_duet/service/database.dart';

class ExpensesSheet extends StatefulWidget {
  const ExpensesSheet({super.key, required this.side, this.item});

  final ShadSheetSide side;
  final ItemModel? item;

  @override
  State<ExpensesSheet> createState() => _ExpensesSheetState();
}

class _ExpensesSheetState extends State<ExpensesSheet> {
  final formKey = GlobalKey<ShadFormState>();
  TextEditingController _expenses = TextEditingController();
  TextEditingController _note = TextEditingController();
  CategoryModel selected = CategoryModel()..title = 'Expenses';

  @override
  void initState() {
    if (widget.item != null) {
      _expenses =
          TextEditingController(text: (widget.item?.expenses ?? '').toString());
      _note = TextEditingController(
          text: (widget.item?.description ?? '').toString());
      selected = CategoryModel()..title = widget.item!.category;
    }
    super.initState();
  }

  @override
  void dispose() {
    _expenses.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryController.categories.watch(context);
    return ShadSheet(
      constraints:
          BoxConstraints.tightFor(width: MediaQuery.sizeOf(context).width),
      title: const Text('Pengeluaran'),
      description: const Text("Uang yang anda keluarkan"),
      content: ShadForm(
        key: formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'pengeluaran',
                controller: _expenses,
                label: const Text('Pengeluaran'),
                placeholder: const Text('cth: 500000'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v.length < 2) {
                    return 'Masukkan angka yang benar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              categories.map(
                data: (items) {
                  return Row(
                    children: [
                      ShadSelect<CategoryModel>(
                        initialValue: selected,
                        placeholder: const Text('Category'),
                        onChanged: (val) {
                          setState(() {
                            selected = val;
                          });
                        },
                        options: items
                            .map((e) =>
                                ShadOption(value: e, child: Text(e.title)))
                            .toList()
                          ..add(ShadOption(
                              value: CategoryModel()..title = 'Expenses',
                              child: const Text('Expanses'))),
                        selectedOptionBuilder: (context, value) =>
                            Text(selected.title),
                      ),
                      ShadButton.ghost(
                        text: const Text('Add'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategoriesForm()),
                          );
                        },
                      )
                    ],
                  );
                },
                error: (error, __) => Text('$error'),
                loading: () => const CircularProgressIndicator(),
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'note',
                controller: _note,
                label: const Text('Catatan'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ShadButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.item != null) {
                  final item = ItemModel()
                    ..id = widget.item!.id
                    ..expenses = int.parse(_expenses.text)
                    ..description = _note.text
                    ..title = 'Expenses'
                    ..category = selected.title
                    ..updated = DateTime.now()
                    ..created = widget.item!.created;
                  await Database().updateItem(item);
                  if (context.mounted) Navigator.pop(context);
                } else {
                  final item = ItemModel()
                    ..expenses = int.parse(_expenses.text)
                    ..description = _note.text
                    ..title = 'Expenses'
                    ..category = selected.title
                    ..updated = DateTime.now()
                    ..created = DateTime.now();
                  await Database().createItem(item);
                }

                await historyController.history.refresh();
                if (context.mounted) Navigator.pop(context);
              }
            },
            text: const Text('Simpan')),
      ],
    );
  }
}
