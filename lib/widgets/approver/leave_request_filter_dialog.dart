import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;



class LeaveRequestFilterDialog extends StatefulWidget {
  final MainModel model;

  LeaveRequestFilterDialog(this.model);
  @override
  State<StatefulWidget> createState() {
    return _LeaveRequestFilterDialogState();
  }
}

class _LeaveRequestFilterDialogState extends BaseState<LeaveRequestFilterDialog> {
  static const leaveStatus = <String>[
    'Approved',
    'Declined',
    'Pending',
    'Requested for Cancellation',
    'Cancelled'
  ];

  int selectedBranch;
  int selectedDepartment;
  int selectedDesignation;
  int selectedLeaveType;

  String selectedBranchName;
  String selectedDepartmentName;
  String selectedDesignationName;
  String selectedLeaveName;
  Map<String,dynamic> _defaultFilters = Map();


  List _mySelectedStatus;
  List<Map> dataSource = [

    {
      "display": "Approved",
      "value": "Approved",
    },
    {
      "display": "Declined",
      "value": "Declined",
    },
    {
      "display": "Pending",
      "value": "Pending",
    },
    {
      "display": "Requested for Cancellation",
      "value": "Requested for Cancellation",
    },
    {
      "display": "Cancelled",
      "value": "Cancelled",
    },
  ];

  @override
  void initState() {
    widget.model.fetchBranches();
    widget.model.fetchDepartments();
    widget.model.fetchDesignations();
    widget.model.fetchAllLeaveTypes();
    _mySelectedStatus = [];
    _defaultFilters['status'] = ['Pending','Requested for Cancellation'];
    _getStatusList();
    super.initState();
  }

  _getStatusList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var list = pref.getString('statusList');
    if(list != null){
      setState(() {
        _mySelectedStatus = json.decode(list);
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
                  child: _buildBranchDropdown(),
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
                  child: _buildDepartmentDropdown(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Designation',
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
                  child: _buildDesignationDropdown(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Leave type',
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
                  child: _buildLeaveTypeDropdown(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text(
                      'Leave status',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  margin: EdgeInsets.all(3.0),
                  child: MultiSelectFormField(
                    autovalidate: false,
                    titleText: 'Choose status',
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please select one or more status';
                      }
                    },
                    dataSource: dataSource,
                    textField: 'display',
                    valueField: 'value',
                    okButtonLabel: 'OK',
                    cancelButtonLabel: 'CANCEL',
                    // required: true,
                    hintText: 'Please choose one or more',
                    value: _mySelectedStatus,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        _mySelectedStatus = value;
                      });
                    },
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
                        Navigator.of(context).pop(_defaultFilters);
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
                        Map<String, dynamic> filters = Map();
                        filters['branch'] = selectedBranch.toString();
//                        filters['branchName'] = selectedBranchName;
                        filters['department'] = selectedDepartment.toString();
//                        filters['departmentName'] = selectedDepartmentName;
                        filters['designation'] = selectedDesignation.toString();
//                        filters['designationName'] = selectedDesignationName;
                        filters['leave_type'] = selectedLeaveType.toString();
//                        filters['leaveTypeName'] = selectedLeaveName;
                        filters['status'] = _mySelectedStatus;
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

  Widget _buildBranchDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text('Select branch'),
            isExpanded: true,
            value: selectedBranch,
            onChanged: (newValue) {
              setState(() {
                selectedBranch = newValue;
//                selectedBranchName = _branchTypes[newValue];
              });
            },
            items: _menuItems(widget.model.allBranches),
          );
        }
    );

  }

  Widget _buildDepartmentDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text('Select department'),
            isExpanded: true,
            value: selectedDepartment,
            onChanged: (newValue) {
              setState(() {
                selectedDepartment = newValue;
//                selectedDepartmentName = _departments[newValue];
              });
            },
            items: _menuItems(widget.model.allDepartments),
          );
        }
    );

  }

  Widget _buildDesignationDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text('Select designation'),
            isExpanded: true,
            value: selectedDesignation,
            onChanged: (newValue) {
              setState(() {
                selectedDesignation = newValue;
//                selectedDesignationName = _designations[newValue];
              });
            },
            items: _menuItems(widget.model.allDesignations),
          );
        }
    );

  }

  Widget _buildLeaveTypeDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text('Select leave type'),
            isExpanded: true,
            value: selectedLeaveType,
            onChanged: (newValue) {
              setState(() {
                selectedLeaveType = newValue;
//                selectedLeaveName = _leaveTypes[newValue];
              });
            },
            items: _menuItems(widget.model.allLeaveTypes),
          );
        }
    );

  }
}
