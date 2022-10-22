import 'package:flutter/material.dart';

import 'database.dart';
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SqliteUsing(),
    );
  }
}

class SqliteUsing extends StatefulWidget {
  const SqliteUsing({Key? key}) : super(key: key);

  @override
  State<SqliteUsing> createState() => _SqliteUsingState();
}

class _SqliteUsingState extends State<SqliteUsing> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();

  late Future<List<Student>> _studentsList;
  late String _studentName;
  bool isUpdate = false;
  int? studentIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateStudentList();
  }

  updateStudentList() {
    setState(() {
      _studentsList = DBProvider.db.getStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SqliteUsing'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter student name';
                      }
                      if (value.trim() == "") return 'Can not be empty !';
                      return null;
                    },
                    onSaved: (value) {
                      _studentName = value!;
                    },
                    controller: _studentNameController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      labelText: 'Student name',
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  (isUpdate ? 'update'.toUpperCase() : 'add'.toUpperCase()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .updateStudent(
                              Student(studentIdForUpdate!, _studentName))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db.insertStudent(Student(null, _studentName));
                    }
                  }
                  _studentNameController.text = '';
                  updateStudentList();
                },
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _studentNameController.text = "";
                  setState(() {
                    isUpdate = false;
                    studentIdForUpdate = null;
                  });
                },
                child: Text(
                  (isUpdate ? 'cancel'.toUpperCase() : 'clear'.toUpperCase()),
                ),
              ),
              Divider(
                height: 5.0,
              ),
              Expanded(
                child: FutureBuilder(
                    future: _studentsList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return generalList(snapshot.data as List<Student>);
                      }
                      if (snapshot.data == null ||
                          (snapshot.data as List<Student>).length == 0) {
                        return Text('No data found');
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generalList(List<Student> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'name'.toUpperCase(),
              ),
            ),
            DataColumn(
              label: Text(
                'delete'.toUpperCase(),
              ),
            ),
          ],
          rows: students
              .map(
                (student) => DataRow(cells: [
                  DataCell(Text(student.name), onTap: () {
                    setState(() {
                      isUpdate = true;
                      studentIdForUpdate = student.id;
                    });
                    _studentNameController.text = student.name;
                  }),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        DBProvider.db.deleteStudent(student.id);
                        updateStudentList();
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }
}
