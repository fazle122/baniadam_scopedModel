import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

class AttendanceRequestDialogWidget extends StatefulWidget {
  final MainModel model;

  AttendanceRequestDialogWidget(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AttendanceRequestDialogWidgetState();
  }
}

class _AttendanceRequestDialogWidgetState
    extends State<AttendanceRequestDialogWidget> {
  bool editable = false;
  bool disableButton = false;
  bool isApplied = false;
  final format = DateFormat('yyyy-MM-dd');
  DateTime today;
  String formattedDate;

  TimeOfDay _time = TimeOfDay.fromDateTime(DateTime.now());
  static const menuItems = <String>['in', 'out'];

  Map<String, dynamic> reasonData;
  Map<int, dynamic> _reasons;
  int selectedValue;

  @override
  void initState() {
    widget.model.fetchAttendanceRequestReasons();
    today = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(today);
    reasonData = Map();
    _reasons = new Map();
    super.initState();
  }

  _buildReasonDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text(
              'Select reason (optional)',
              style: TextStyle(fontSize: 15.0),
            ),
            // Not necessary for Option 1
            value: selectedValue,
            elevation: 3,
            onChanged: (newValue) {
              selectedValue = newValue;
              print(selectedValue.toString());
            },
            items: _menuItems(model.attendanceRequestReasons),
          );
        }
    );
  }


  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((k, v) {
      itemWidgets.add(DropdownMenuItem(
        value: k,
        child: Text(v.toString()),
      ));
    });
    return itemWidgets;
  }



  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  int flagType;

  void handleRadioValue(int value) {
    setState(() {
      flagType = value;
    });
  }

  Widget _alertDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
          child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'New attendance Request',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              formattedDate.toString(),
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ],
      )
          ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 240.0,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio<int>(
                          activeColor: Theme.of(context).primaryColorDark,
                          value: 0,
                          groupValue: flagType,
                          onChanged: handleRadioValue,
                        ),
                        Text('First IN'),
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Radio<int>(
                          activeColor: Theme.of(context).primaryColorDark,
                          value: 1,
                          groupValue: flagType,
                          onChanged: handleRadioValue,
                        ),
                        Text('Last OUT'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildReasonDropdown(),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.timer),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                    Container(
                        width: 80.0,
                        child: Text(_time.format(context))),
                  ],
                ),
              ),

              SizedBox(
                height: 30.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCancelButton(context),
                      _buildApplyButton(context),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child,MainModel model){
        return InkWell(
          child: Container(
            width: 100.0,
            height: 35.0,
            decoration: ShapeDecoration(
              color: Theme.of(context).buttonColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colors.grey.shade500),
                borderRadius:
                BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Center(
                child: Text(
                  'Apply',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          onTap: () async {
            _submitForm(model.createAttendanceRequest);
          },
        );
      }
    );
  }

  void _submitForm(Function attendanceRequestData) async{
    FormData data;
    if (selectedValue != null) {
      data = new FormData.from({
        'did': '10',
        'time': _time.hour.toString() +
            ":" +
            _time.minute.toString(),
        'request_reason':
        selectedValue.toString(),
      });
    } else {
      data = new FormData.from({
        'did': '10',
        'time': _time.hour.toString() +":" + _time.minute.toString(),
      });
    }
    attendanceRequestData(data,flagType).then((success){
      Navigator.of(context).pop();
//      if (successinformation['message'] != null) {
//        Toast.show(successinformation['message'], context,
//            duration: Toast.LENGTH_SHORT,
//            gravity: Toast.CENTER);
//
//        Navigator.pushReplacementNamed(context, '/dashboard');
//      } else {
//        Navigator.pushReplacementNamed(context, '/dashboard');
//        Toast.show('Please try again!!!', context,
//            duration: Toast.LENGTH_LONG,
//            gravity: Toast.BOTTOM);
//      }
//
//      if (successinformation == null) {
//        setState(() {
//          Navigator.pushReplacementNamed(context, '/dashboard');
//          Toast.show('Please try again!!!', context,
//              duration: Toast.LENGTH_LONG,
//              gravity: Toast.BOTTOM);
//        });
//      }
    });

  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
                      child: Container(
                        width: 100.0,
                        height: 35.0,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: Colors.grey.shade500),
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0)),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        )),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    );
  }

  @override
  Widget build(BuildContext context) {
    return _alertDialog(context);
  }

}
