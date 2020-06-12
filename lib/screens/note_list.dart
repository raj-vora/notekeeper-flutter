import 'package:flutter/material.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/screens/note_details.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  void initState(){
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    if(noteList == null) noteList = List<Note>();

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(this.noteList[position].title, style: titleStyle,),
              subtitle: Text(this.noteList[position].date),
              trailing: GestureDetector(
                onTap: () => _delete(context, noteList[position]),
                child: Icon(
                  Icons.delete, 
                  color: Colors.grey,
                ),
              ),
              onTap: (){navigateToDetail(this.noteList[position], 'Edit Note');},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){navigateToDetail(Note('', '', 3), 'Add Note');},
        child: Icon(Icons.add),
      ),
    );
  }

  Color getPriorityColor (int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      default:
      return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);
      case 3:
        return Icon(Icons.arrow_right);
      default:
        return Icon(Icons.arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetails(note, title);
    }));

    if(result == true) updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then( (database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}