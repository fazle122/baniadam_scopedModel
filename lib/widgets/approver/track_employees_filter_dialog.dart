import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;



class TrackEmployeesFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackEmployeesFilterDialogState();
  }
}

class _TrackEmployeesFilterDialogState extends BaseState<TrackEmployeesFilterDialog> {
  int selectedDesignation;
  String selectedDesignationName;
  int selectedBranch;
  String selectedBranchName;
  int selectedDepartment;
  String selectedDepartmentName;
  String selectedLeaveStatus;

  Map<int, dynamic> _designations;
  Map<int, dynamic> _departments;
  Map<int, dynamic> _branch_types;

  bool showCustomFilterRow = false;
  bool editable = false;
  List _mySelectedStatus;
  final format = DateFormat('yyyy-MM-dd');
  DateTime _date;

  @override
  void initState() {
    _designations = new Map();
    _departments = new Map();
    _branch_types = new Map();
    _getBranchTypes();
    _getDepartments();
    _getCategory();
    _mySelectedStatus = [];
    super.initState();
  }


  void _getBranchTypes() async {
//    Map<String, dynamic> data = await ApiService.getBranchTypes();
    List<dynamic> data = await ApiService.getBranchTypes();
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data.length; i++) {
          _branch_types[data[i]['id']] =
          data[i]['value'];
        }
      });
    }
  }

  void _getDepartments() async {
//    Map<String, dynamic> data = await ApiService.getDepartments();
    List<dynamic> data = await ApiService.getDepartments();
    if (data != null) {
      setState(() {
// //       data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data.length; i++) {
          _departments[data[i]['id']] =
          data[i]['value'];
        }
      });
    }
  }

  void _getCategory() async {
//    Map<String, dynamic> data = await ApiService.getCategories();
    List<dynamic> data = await ApiService.getCategories_new();
    if (data != null) {
      setState(() {
//        data['attributes'].forEach((k,v) => _reasons.addAll(k,v))
        for (int i = 0; i < data.length; i++) {
          _designations[data[i]['id']] =
          data[i]['value'];
        }
      });
    }
  }




  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((key, value) {
      itemWidgets.add(DropdownMenuItem(
//        key: key,
        value: key,
        child: Text(value),
      ));
    });
    return itemWidgets;
  }

  List<DropdownMenuItem<String>> _statusMenuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((key, value) {
      itemWidgets.add(DropdownMenuItem(
//        key: key,
        value: key,
        child: Text(value),
      ));
    });
    return itemWidgets;
  }

  Widget _alertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
//      contentPadding: EdgeInsets.all(15.0),

//      titlePadding: EdgeInsets.only(left:20.0,right: 20.0),
      title: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        padding: EdgeInsets.all(0.0),
        child: Center(
          child: Text('Filter options'),
        ),
      ),
      content: SingleChildScrollView(
        padding: EdgeInsets.all(0.0),
        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Date',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  child: DateTimeField(
                    textAlign: TextAlign.start,
                    format: format,
                    onChanged: (dt) {
                      setState(() {
                        _date = dt;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Choose date',
                        prefixIcon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Branch',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select branch'),
                    isExpanded: true,
                    value: selectedBranch,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBranch = newValue;
                        selectedBranchName = _branch_types[newValue];
                        print(selectedBranch);
                        print(_branch_types[newValue]);
                      });
                    },
                    items: _menuItems(_branch_types),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Department',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select department'),
                    isExpanded: true,
                    value: selectedDepartment,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDepartment = newValue;
                        selectedDepartmentName = _departments[newValue];
                        print(selectedDepartment);
                        print(_departments[newValue]);
                      });
                    },
                    items: _menuItems(_departments),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Category',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: DropdownButton(
                    hint: Text('Select category'),
                    isExpanded: true,
                    value: selectedDesignation,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDesignation = newValue;
                        selectedDesignationName = _designations[newValue];
                        print(selectedDesignation);
                        print(_designations[newValue]);
                      });
                    },
                    items: _menuItems(_designations),
                  ),
                ),
              ],
            ),


            SizedBox(
              height: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 100.0,
                        height: 35.0,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          ),
                        ),
                        child: Center(
                            child: Text(
                              'Cancel',
                              style:
                              TextStyle(color: Theme.of(context).primaryColorDark),
                            )),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 100.0,
                        height: 35.0,
                        decoration: ShapeDecoration(
                          color: Theme.of(context).buttonColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: Center(
                            child: Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      onTap: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('statusList', json.encode(_mySelectedStatus));
//                      _getAttendanceList();
                        Map<String, dynamic> filters = Map();
                        filters['date'] = DateFormat('yyyy-MM-dd').format(_date);
                        filters['branch'] = selectedBranch.toString();
//                        filters['branchName'] = selectedBranchName;
                        filters['department'] = selectedDepartment.toString();
//                        filters['departmentName'] = selectedDepartmentName;
//                        filters['designation'] = selectedDesignation.toString();
//                        filters['designationName'] = selectedDesignationName;
//                        filters['leave_type'] = selectedLeaveType.toString();
//                        filters['leaveTypeName'] = selectedLeaveName;
                        filters['category'] = selectedDesignation.toString();
                        Navigator.of(context).pop(filters);
                      },
                    ),
                    SizedBox(height: 20.0)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialog(context);
  }
}
