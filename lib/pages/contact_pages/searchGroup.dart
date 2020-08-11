import 'package:flutter/material.dart';
import '../../models/constant.dart';

class SearchGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: orengeColor,
        leading: Container(
          padding: EdgeInsets.only(left: kDefaultPadding),
          child: GestureDetector(
            onTap: () {
              //tose
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                //return to previous page;
              },
            ),
          ),
        ),
        title: Text('Find Course Channel'),
        centerTitle: true,
      ),
      body: _stateBody(),
    );
  }

  Widget _stateBody() {
    String _selectedYear = "";
    List<String> _years = ["", "2019", "2020", "2021"];
    String _selectedSemester = "";
    List<String> _semesters = ["", "Fall", "Spring", "Summer1", "Summer2"];

    return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: DropdownButtonFormField(
                    value: _selectedYear,
                    items: _years.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Year',
                    ),
                    validator: (String value) {
                      if (value == "") {
                        return "Year is required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Flexible(
                  child: DropdownButtonFormField(
                    value: _selectedSemester,
                    items: _semesters.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSemester = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Semester',
                    ),
                    validator: (String value) {
                      if (value == "") {
                        return "Semester is required";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  labelStyle: TextStyle(
                    color: Colors.grey
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: orengeColor),
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Course name is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Section',
                  labelStyle: TextStyle(
                      color: Colors.grey
                  ),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: orengeColor),
                  ),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "Section is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 100,
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Search"),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
