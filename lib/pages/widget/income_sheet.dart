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

class IncomeSheet extends StatefulWidget {
  const IncomeSheet({super.key, required this.side, this.item});

  final ShadSheetSide side;
  final ItemModel? item;

  @override
  State<IncomeSheet> createState() => _IncomeSheetState();
}

class _IncomeSheetState extends State<IncomeSheet> {
  final formKey = GlobalKey<ShadFormState>();
  TextEditingController _income = TextEditingController();
  TextEditingController _note = TextEditingController();
  CategoryModel selected = CategoryModel()..title = 'Income';

  @override
  void initState() {
    if (widget.item != null) {
      _income =
          TextEditingController(text: (widget.item?.income ?? '').toString());
      _note = TextEditingController(
          text: (widget.item?.description ?? '').toString());
      selected = CategoryModel()..title = widget.item!.category;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryController.categories.watch(context);
    return ShadSheet(
      constraints:
          BoxConstraints.tightFor(width: MediaQuery.sizeOf(context).width),
      title: const Text('Pemasukan'),
      description: const Text("Uang yang anda dapatkan"),
      content: ShadForm(
        key: formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'pemasukan',
                controller: _income,
                label: const Text('Pemasukan'),
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
                              value: CategoryModel()..title = 'Income',
                              child: const Text('Income'))),
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
                    ..income = int.parse(_income.text)
                    ..description = _note.text
                    ..title = 'Income'
                    ..category = selected.title
                    ..updated = DateTime.now()
                    ..created = widget.item!.created;
                  await Database().updateItem(item);
                  if (context.mounted) Navigator.pop(context);
                } else {
                  final item = ItemModel()
                    ..income = int.parse(_income.text)
                    ..description = _note.text
                    ..title = 'Income'
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
