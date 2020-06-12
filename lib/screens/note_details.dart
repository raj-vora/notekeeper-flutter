import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetails(this.note, this.appBarTitle);
  @override
  _NoteDetailsState createState() => _NoteDetailsState(this.note, this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  static var _priorities = ['High', 'Medium' ,'Low'];
  var _formKey = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  _NoteDetailsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    
    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(appBarTitle),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String item) {
                    return DropdownMenuItem<String>(
                      child: Text(item),
                      value: item,
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(note.priority),
                  onChanged: (value){
                    setState(() {
                      updatepriorityAsInt(value);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: TextFormField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value){
                    note.title = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                  validator: (String value) {
                    if(value.isEmpty) return 'Please enter a title for the note';
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value){
                    note.description = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save', textScaleFactor: 1.5,),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            Navigator.pop(context, true);
                            int result;
                            note.date = DateFormat.yMMMd().format(DateTime.now());
                            if(note.id != null) { //Update operation
                              result = await helper.updateNote(note);
                            }
                            else { //Insert operation
                              result = await helper.insertNote(note);
                            }

                            if(result != 0) {
                              _showAlertDialog('Status', 'Note Saved Successfully');
                            } else {
                              _showAlertDialog('Status', 'Problem Saving Note');
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).errorColor,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Delete', textScaleFactor: 1.5,),
                        onPressed: () async {
                          Navigator.pop(context, true);
                          //If user is trying to delete a NEW NOTE.
                          if(note.id == null) {
                            _showAlertDialog('Status', 'No Note was deleted');
                            return;
                          }

                          //User is trying to delete a valid note.
                          int result = await helper.deleteNote(note.id);
                          if(result != 0) {
                            _showAlertDialog('Status', 'Note Deleted Successfully');
                          } else {
                            _showAlertDialog('Status', 'Error Occured while Deleting Note');
                          }
                          
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //Convert priority from String to int before saving to db
  void updatepriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Medium':
        note.priority = 2;
        break;
      case 'Low':
        note.priority = 3;
        break;        
    }
  }

  //Convert priority from int to String and display to user
  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0];
      case 2:
        return _priorities[1];
      case 3:
        return _priorities[2];
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}