import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_duet/pages/home.dart';
import 'package:simple_duet/service/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Duet - Money Management',
      home: Home(),
    );
  }
}
