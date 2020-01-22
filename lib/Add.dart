import 'package:flutter/material.dart';
import 'student.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => new _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool _canSave = false;
  Student _data;

  void _setCanSave(bool save) {
    if (save != _canSave) setState(() => _canSave = save);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: AppBar(title: const Text('Add Student Name'), actions: <Widget>[
        FlatButton(
            child: new Text('ADD',
                style: theme.textTheme.body1.copyWith(
                    color: _canSave
                        ? Colors.white
                        : new Color.fromRGBO(255, 255, 255, 0.4))),
            onPressed: _canSave
                ? () {
              Navigator.of(context).pop(_data);
            }
                : null)
      ]),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            new TextField(
              decoration: const InputDecoration(
                labelText: "Enter Name",
              ),
              onChanged: (String value) {
                _data = Student(value, false);
                _setCanSave(value.isNotEmpty);
              },
            ),
          ].toList(),
        ),
      ),
    );
  }
}
