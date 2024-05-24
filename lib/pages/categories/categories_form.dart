import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_duet/controller.dart/category_controller.dart';
import 'package:simple_duet/model/category_model.dart';
import 'package:simple_duet/service/database.dart';

class CategoriesForm extends StatefulWidget {
  final CategoryModel? item;
  const CategoriesForm({super.key, this.item});

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  final formCategoryKey = GlobalKey<ShadFormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  @override
  void initState() {
    if (widget.item != null) {
      _title =
          TextEditingController(text: (widget.item?.title ?? '').toString());
      _description = TextEditingController(
          text: (widget.item?.description ?? '').toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ShadForm(
          key: formCategoryKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'category',
                controller: _title,
                label: const Text('Kategori'),
                placeholder: const Text('Makan'),
                validator: (v) {
                  if (v.length < 2) {
                    return 'Kategori paling tidak 2 huruf.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'description',
                controller: _description,
                label: const Text('Note'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ShadButton(
                text: const Text('Simpan'),
                onPressed: () async {
                  if (formCategoryKey.currentState!.saveAndValidate()) {
                    if (widget.item != null) {
                      final category = CategoryModel()
                        ..id = widget.item!.id
                        ..title = _title.text
                        ..description = _description.text;
                      await Database().updateCategory(category);
                    } else {
                      final category = CategoryModel()
                        ..title = _title.text
                        ..description = _description.text;
                      await Database().createCategory(category);
                    }

                    await categoryController.categories.refresh();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
