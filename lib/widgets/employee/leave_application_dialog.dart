import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

class LeaveApplicationDialogWidget extends StatefulWidget {
  final MainModel model;

  const LeaveApplicationDialogWidget(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LeaveApplicationDialogWidgetState();
  }
}

class _LeaveApplicationDialogWidgetState
    extends BaseState<LeaveApplicationDialogWidget> {
  static const leaveMode = <String>['Full Day', 'Half Day'];
  static const leaveModeShift = <String>['First Half', 'Second Half'];
  TextEditingController reasonController;
  int selectedLeaveType;
  Map<int, dynamic> _leaveTypes;
  bool editable = false;
  DateTime _from;
  DateTime _to;
  bool disableButton = false;
  String selectedLeaveMode;
  String selectedLeaveModeShift;
  bool modeShift = false;
  bool showBalance = false;
  double leaveCount;
  final format = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
//    widget.model.fetchLeaveTypes();
    reasonController = TextEditingController();
    _leaveTypes = new Map();
    super.initState();
  }

  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((key, value) {
      itemWidgets.add(DropdownMenuItem(
        value: key,
        child: Text(value['label']),
      ));
    });
    return itemWidgets;
  }

  Widget _leaveApplicationDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        child: Center(
          child: Text(
            'Leave application',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
      content:
//      SingleChildScrollView(
//        child:
        Container(
//          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(3.0),
                      child: Text(
                        'Leave mode *',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
//                    margin: EdgeInsets.all(3.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Select leave mode'),
                        value: selectedLeaveMode,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedLeaveMode = newValue;
                            print(selectedLeaveMode);
                            if (selectedLeaveMode == 'Half Day') {
                              modeShift = true;
                            } else {
                              modeShift = false;
                            }
                          });
                        },
                        items: leaveMode
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList()),
                  ),
                ],
              ),
              modeShift == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text(
                              'Leave mode shift',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            )),
                        Container(
//                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          margin: EdgeInsets.all(3.0),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Select leave mode shift'),
                              value: selectedLeaveModeShift,
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedLeaveModeShift = newValue;
                                  print(selectedLeaveModeShift);
                                });
                              },
                              items: leaveModeShift
                                  .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList()),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
              modeShift == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text(
                              'Select date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            )),
                        ScopedModelDescendant<MainModel>(builder:
                            (BuildContext context, Widget child,
                                MainModel model) {
                          return Container(
                            child: DateTimeField(
                              textAlign: TextAlign.start,
                              format: format,
                              onChanged: (dt) {
                                setState(() {
                                  _from = dt;
                                  _to = dt;
                                });
                                model.fetchLeaveBalance(_from, _to);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Select date',
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          );
                        }),
                      ],
                    )
                  : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
              modeShift == false
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text(
                              'From date',
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
                                labelText: 'From date',
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
                    )
                  : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
              modeShift == false
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text(
                              'To date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            )),
                        ScopedModelDescendant<MainModel>(builder:
                            (BuildContext context, Widget child,
                                MainModel model) {
                          return Container(
                            child: DateTimeField(
                              enabled: _from == null ? false : true,
                              textAlign: TextAlign.start,
                              format: format,
                              onChanged: (dt) {
                                setState(() {
                                  _to = dt;
                                  print(_to.toString());
                                });
                                model.fetchLeaveBalance(_from, _to);
                              },
                              decoration: InputDecoration(
                                  labelText: 'To date',
                                  prefixIcon: Icon(
                                    Icons.date_range,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: _from,
//                          initialDate: currentValue ?? DateTime.now(),
                                    initialDate:
                                        _from.compareTo(DateTime.now()) < 1
                                            ? DateTime.now()
                                            : _from,
                                    lastDate: DateTime(2100));
                              },
                            ),
                          );
                        }),
                      ],
                    )
                  : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(3.0),
                      child: Text(
                        'Leave type *',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: ScopedModelDescendant<MainModel>(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return DropdownButton(
                        isExpanded: true,
                        hint: Text('Select leave type'),
                        value: selectedLeaveType,
                        onChanged: (newValue) {
                          setState(() {
                            selectedLeaveType = newValue;
                            leaveCount = model.leaveTypesForLeaveApply[newValue]['balance'].toDouble();

                            showBalance = true;
                          });
                        },
                        items: _menuItems(model.leaveTypesForLeaveApply),
                      );
                    }),
                  ),
                ],
              ),
              showBalance
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(3.0),
                            child: Text(
                              'Current balance',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            )),
                        Container(
                          height: 55.0,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText:
                                  'Current balance : ' + leaveCount.toString(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(3.0),
                      child: Text(
                        'Leave reason *',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      )),
                  Container(
                    child: TextField(
                      autofocus: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      controller: reasonController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.keyboard,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        labelText: 'Reason',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Text(
                      '* Required fields',
                      style: TextStyle(fontSize: 12.0, color: Colors.red),
                    ),
                  )
                ],
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
                      InkWell(
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
                      ),
                      InkWell(
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
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if (selectedLeaveMode == null ||
                              selectedLeaveMode == '') {
                            Toast.show('Please select leave mode', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (selectedLeaveMode == 'Half Day' &&
                              (selectedLeaveModeShift == null ||
                                  selectedLeaveModeShift == '')) {
                            Toast.show(
                                'Please select leave mode shift', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (selectedLeaveMode == 'Half Day' &&
                              (_from == null || _from == '')) {
                            Toast.show('Please choose date', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (_from == null || _from == '') {
                            Toast.show('Please choose from date', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (_to == null || _to == '') {
                            Toast.show('Please choose to date', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (selectedLeaveType == null ||
                              selectedLeaveType == '') {
                            Toast.show('Please select leave type', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          } else if (reasonController.text == null ||
                              reasonController.text == '') {
                            Toast.show('Please write down the reason', context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
//                        if (reasonController.text == null ||
//                            reasonController.text == "") {
//                          Toast.show('Please write down a reason !!!', context,
//                              duration: Toast.LENGTH_LONG,
//                              gravity: Toast.CENTER);
//                        }
                          else {
                            showDialog<Map<String, dynamic>>(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) =>
                                  _confirmLeaveDialog(
                                      context,
                                      selectedLeaveType.toString(),
                                      _from.toString(),
                                      _to.toString(),
                                      reasonController.text.trim(),
                                      selectedLeaveMode,
                                      selectedLeaveModeShift),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
//      ),
    );
  }

  Widget _buildLeaveTypeDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return DropdownButton(
//          isExpanded: true,
        hint: Text('Select leave type'),
        value: selectedLeaveType,
        onChanged: (newValue) {
          setState(() {
            selectedLeaveType = newValue;
            leaveCount = _leaveTypes[newValue]['balance'];
            showBalance = true;
          });
        },
        items: _menuItems(model.leaveTypesForLeaveApply),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:_leaveApplicationDialog(context)
    );
  }

  Widget _confirmLeaveDialog(
      BuildContext context,
      String leaveType,
      String fromDate,
      String toDate,
      String reason,
      String leaveMode,
      String leaveModeShift) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isActivityLoading
          ? AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: SingleChildScrollView(
                  child: Center(
                child: CircularProgressIndicator(),
              )),
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(15.0),
              title: Center(child: Text('Confirm request')),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('Do you want to submit this leave application?'),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCancelButton(context),
                        _buildSubmitButton(context, leaveType, fromDate, toDate,
                            reason, leaveMode, leaveModeShift),
                      ],
                    ),
                  ],
                ),
              ));
    });
  }

  Widget _buildSubmitButton(
      BuildContext context,
      String leaveType,
      String fromDate,
      String toDate,
      String reason,
      String leaveMode,
      String leaveModeShift) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return InkWell(
        child: Container(
          width: 90.0,
          height: 35.0,
          decoration: ShapeDecoration(
            color: !disableButton ? Theme.of(context).buttonColor : Colors.grey,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: Colors.grey.shade500),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: Center(
              child: Text(
            'YES',
            style: TextStyle(color: Colors.white),
          )),
        ),
        onTap: disableButton
            ? null
            : () async {
                _submitForm(model.applyForLeave, leaveType, fromDate, toDate,
                    reason, leaveMode, leaveModeShift);
              },
      );
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
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
        ),
        child: Center(
            child: Text(
          'No',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        )),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _submitForm(Function applyForLeave, String leaveType, String fromDate,
      String toDate, String reason, String leaveMode, String leaveModeShift) {
    applyForLeave(
            leaveType, fromDate, toDate, reason, leaveMode, leaveModeShift)
      .then((Map<String,dynamic> response) {
        if(response == null){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
        if (response['success']) {
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/empAppliedLeaves');
      } else {
          Navigator.of(context).pop();
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }
    });
  }
}
