import 'package:flutter/material.dart';
import 'package:notekeeper/screens/note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 1;
  

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    void navigateToDetail(String title) {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return NoteDetails(title);
      }));
    }

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
                backgroundColor: Colors.yellow,
                child: Icon(Icons.keyboard_arrow_right),
              ),
              title: Text('Dummy Title', style: titleStyle,),
              subtitle: Text('Dummy Date'),
              trailing: Icon(
                Icons.delete, 
                color: Colors.grey,
              ),
              onTap: (){navigateToDetail('Edit Note');},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){navigateToDetail('Add Note');},
        child: Icon(Icons.add),
      ),
    );
  }
}