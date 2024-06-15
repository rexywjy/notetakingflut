import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notetakingflut/passcode.dart';
import 'noteslist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('pin');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: NoteList()
      home: PinCodeWidget(),
    );
  }
}
