import 'package:flutter/material.dart';

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
                      onSaved: (value) {},
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'add'.toUpperCase(),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'clear'.toUpperCase(),
                  ),
                ),
                Divider(
                  height: 5.0,
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ],
        ));
  }
}
