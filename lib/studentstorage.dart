

import 'dart:async';
import 'dart:io';
import 'student.dart';

class Storage {
  Future<String> get _localPath async {

  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/names.txt');
  }

  Future<List<Student>> readStudents() async {
    List<Student> Snames;
    try {
      final file = await _localFile;
      Snames = List<Student>();
      await file.readAsLines().then((List<String> lines) {
        for (int i = 0; i < lines.length; i++) {
          List<String> tokens = lines[i].split(',');
          bool vis = tokens[1] == 'true' ? true : false;
          Snames.add(new Student(tokens[0], vis));
        }
      });
      // Read the file
    } catch (e) {
      print('Hold on: ' + e.toString());
      return null;
    }
    return Snames;
  }

  Future<File> writeStudents(List<Student> Snames) async {

    final file = await _localFile;  // Write the file
    var sink = file.openWrite(mode: FileMode.write);
    for (int i = 0; i < Snames.length; i++) {
      var line = Snames[i].name + ',' + (Snames[i].hidden ? 'true' : 'false') +
          '\n';
      sink.write(line);
    }
    await sink.flush();
    await sink.close();

    return file;
  }
}
