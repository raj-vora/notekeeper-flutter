import 'package:flutter/material.dart';
import 'screens/note_details.dart';
import 'screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: NoteDetails(),
    );
  }
}