import 'package:baniadam/base_state.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;



class AdminAttendanceRequestFilterDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminAttendanceRequestFilterDialogState();
  }
}

class _AdminAttendanceRequestFilterDialogState extends BaseState<AdminAttendanceRequestFilterDialog> {
  static const leaveStatus = <String>[
    'Approved',
    'Declined',
    'Pending',
  ];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  List attendenceList;

  int selectedLeaveType;
  String selectedLeaveName;
  int selectedDesignation;
  String selectedDesignationName;
  int selectedBranch;
  String selectedBranchName;
  int selectedDepartment;
  String selectedDepartmentName;
  String selectedLeaveStatus;

  Map<int, dynamic> _leaveTypes;
  Map<int, dynamic> _designations;
  Map<int, dynamic> _departments;
  Map<int, dynamic> _branch_types;

  bool showCustomFilterRow = false;
  bool editable = false;

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

  ];

  final format = DateFormat('yyyy-MM-dd');
  DateTime _from;
  DateTime _to;


  @override
  void initState() {
    _leaveTypes = new Map();
    _designations = new Map();
    _departments = new Map();
    _branch_types = new Map();
    attendenceList = [];
    _mySelectedStatus = [];
    _getStatusList();
    super.initState();
  }

  _getStatusList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
//    List _savedStatusList= pref.getStringList('statusList');
    var list = pref.getString('statusList');
//    print(list);
//    print(json.decode(list));
    if(list != null){
      setState(() {
        _mySelectedStatus = json.decode(list);
      });
    }
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
                        _from = dt;
                        print(_from.toString());
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
                        filters['date'] = _from.toString();
                        filters['status'] = _mySelectedStatus;
//                          filters['status'] = selectedLeaveType.toString();
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
