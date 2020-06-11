import 'package:flutter/material.dart';

class NoteDetails extends StatefulWidget {
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  static var _priorities = ['High', 'Medium' ,'Low'];
  var _priority = _priorities[0];
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Edit Note'),
      ),
      body: Padding(
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
                value: _priority,
                onChanged: (value){},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value){},
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value){},
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
                      onPressed: (){},
                      
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).errorColor,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Delete', textScaleFactor: 1.5,),
                      onPressed: (){},
                      
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}