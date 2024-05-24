import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:simple_duet/controller.dart/category_controller.dart';
import 'package:simple_duet/pages/categories/categories_form.dart';
import 'package:simple_duet/service/database.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = categoryController.categories.watch(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesForm()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: categories.map(
          data: (item) {
            return SingleChildScrollView(
              child: Column(
                children: item
                    .map(
                      (i) => ListTile(
                        title: Text(i.title),
                        subtitle: Text(i.description ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoriesForm(item: i)),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await Database().deleteCategory(i.id);
                            await categoryController.categories.refresh();
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
          error: (error, __) => Center(
                child: Text('$error'),
              ),
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
