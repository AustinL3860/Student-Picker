import 'package:flutter/material.dart';
import 'dart:math';
import 'About.dart';
import 'Settings.dart';
import 'Add.dart';
import 'student.dart';
import 'studentstorage.dart';

//Student Picker
//Created by: Austin,Jerson,Phillip
//12/3/2019
//ITEC 4550

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the application root.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState ();
}

class _HomeState extends State<Home> {
  static const String title = 'GGC Student Picker';
  static const Icon hiddenStatus = Icon(Icons.visibility_off);
  static const Icon visibleStatus = Icon(Icons.visibility);
  static const AssetImage bannerImage = AssetImage('assets/banner.jpg');

  String _pick = '';
  List<Student> _items = [];

  Storage storage = Storage();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    storage.readStudents().then((List<Student> students) {
      if (students != null) _items.addAll(students);
      setState(() {});
    });
  }



  int _countHidden(List list) {
    int _count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].hidden) _count++;
    }
    return _count;
  }

  void _postPick() {
    setState(() {
      _pick = '';
      if (_items.length == 0 || _countHidden(_items) == _items.length) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: new Text("No items are selectable"),
          duration: Duration(seconds: 1),
        ));
      } else {
        var selectedIndex = 0;
        while (true) {
          selectedIndex = Random().nextInt(_items.length);
          if (_items[selectedIndex].hidden) continue;
          _pick = _items[selectedIndex].name;
          break;
        }
      }
    });
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _pick = '';
      switch (choice.title) {
        case 'Add Name':
          _openAddStudent();
          break;
        case 'Sort':
          _items.sort((a, b) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          break;
        case 'Shuffle':
          _items.shuffle();
          break;
        case 'Clear':
          _items.clear();
          break;
        case 'About':
          _openAbout();
          break;
      }
    });
  }

  void _openAddStudent() async {
    Student data = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddStudent(), fullscreenDialog: true));

    setState(() {
      if (data != null) _items.add(data);
      storage.writeStudents(_items);
    });
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(title),
          actions: <Widget>[
            // everything in overflow menu
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 500),
                    ));
                  });
                },
                child: Image(
                  image: bannerImage,
                ),
              ),
              Container(
                padding: new EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 40.0, bottom: 10.0),
                child: new Text(
                  _pick,
                  style: TextStyle(fontSize: 35.0),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 20.0),
                  child: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        // Let the ListView know how many items it needs to build
                        itemCount: _items.length,
                        // Provide a builder function. This is where the magic happens! We'll
                        // convert each item into a Widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          Icon status = (item.hidden) ? hiddenStatus : null;
                          return Column(children: <Widget>[
                            Dismissible(
                              // Show a red background as the item is swiped away
                              background: Container(color: Colors.red),
                              key: Key(item.name),
                              onDismissed: (direction) {
                                setState(() {
                                  _items.removeAt(index);
                                  storage.writeStudents(_items);
                                });

                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("$item.name has been deleted")));
                              },
                              child: ListTile(
                                title: new Text(item.name,
                                    style: TextStyle(fontSize: 28.0)),
                                trailing: status,
                                onTap: () {
                                  setState(() {
                                    _items[index].hidden = !_items[index].hidden;
                                  });
                                },
                              ),
                            ),
                            Divider(height: 10.0),
                          ]);
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: _postPick,
            tooltip: 'random pick',
            child: new Icon(Icons.sync),
          );
        }),
      ),
    );
  }
}
