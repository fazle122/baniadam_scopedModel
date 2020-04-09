import 'package:baniadam/pages/employee/empCurrentDateAttendanceList.dart';
import 'package:baniadam/widgets/employee/attendance_request_dialog.dart';
import 'package:baniadam/widgets/employee/leave_application_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/helper/utility.dart';
import 'package:baniadam/models/adminDashboard.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:custom_switch/custom_switch.dart';

class DashboardPage extends StatefulWidget {
  final MainModel model;

  DashboardPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  bool refreshPersonalList = false;
  String userRole;
  bool switchUser = false;

  @override
  initState() {
    widget.model.fetchDashboardData();
    widget.model.fetchUserAuthenticationInfo();
    widget.model.getUserCurrentRole();
//    switchUser = widget.model.userCurrentRole;
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(25.0),
              title: Center(child: Text('Exit app confirmation')),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('You are sure, you want to exit the application?'),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
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
                                  'No',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorDark),
                                )),
                              ),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              onTap: () async {
                                await SystemChannels.platform
                                    .invokeMethod<void>('SystemNavigator.pop');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
              // _filterOptions(context),
              );
        });
  }

  Widget _buildCustomSwitch() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
            height: 15.0,
            child: CustomSwitch(
              activeColor: Color(0xffB2B2B2),
              value: switchUser,
              onChanged: (value) {
                switchUser = value;
                model.switchUserRole(switchUser);
              },
            ));
      },
    );
  }

  Future<Map<String, dynamic>> leaveApplicationDialog(
      BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          LeaveApplicationDialogWidget(widget.model),
    );
  }

  Future<Map<String, dynamic>> attendanceRequestDialog(
      BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          AttendanceRequestDialogWidget(widget.model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (model.isLoading) {
          return CircularProgressIndicator();
        }
        return WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Baniadam'),
                actions: <Widget>[
                  model.userAuthenticationInfo.userRoles.contains('Admin')
                      ? _buildCustomSwitch()
                      : SizedBox(
                          width: 0.0,
                          height: 0.0,
                        ),

//              IconButton(
//                icon: Icon(Icons.refresh),
//                onPressed: () {
//                  _getDashboardDataForAdmin();
//                  _getEmployeeData();
//                },
//              ),
                  PopupMenuButton<String>(
                    onSelected: (val) async {
                      switch (val) {
                        case 'MONTHLY_ATTENDANCE_LIST':
                          Navigator.pushNamed(context, '/empMonthlyAttendance');
                          break;
                        case 'ATTENDANCE_REQUEST_LIST':
                          Navigator.pushNamed(
                              context, '/attendanceRequestList');
                          break;
                        case 'MANUAL_ATTENDANCE':
                          attendanceRequestDialog(context);
                          break;
//                    case 'VIEW_HOLYDAY_LIST':
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  MonthlyHolydayListPage(id: id)));
//                      break;
                        case 'APPLIED_LEAVES':
                          Navigator.pushNamed(context, '/empAppliedLeaves');
                          break;
                        case 'LEAVE_REQ_DIALOG':
                          leaveApplicationDialog(context);
                          break;

//                    case 'ATTENDANCE_REQUEST_LIST_FOR_ADMIN':
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  AttendanceRequestListPageForAdmin()));
//                      break;
//                    case 'DAILY_TRACKING':
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  TrackableEmployeesForAdmin()));
//                      break;
                        case 'CHANGE_PASS':
                          Utility.changePassDialog(context);
                          break;
                        case 'LOGOUT':
                          Utility.logOutDialog(context);
                          break;
                        case 'UNREGISTER':
                          Utility.unRegisterDialog(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      model.userAuthenticationInfo.userCurrentRole == 'Employee'
                          ? PopupMenuItem<String>(
                              value: 'MONTHLY_ATTENDANCE_LIST',
                              child: Text('Monthly attendance'),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                            ),
                      model.userAuthenticationInfo.userCurrentRole == 'Employee'
                          ? PopupMenuItem<String>(
                              value: 'ATTENDANCE_REQUEST_LIST',
                              child: Text('Attendance requests'),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                            ),
                      model.userAuthenticationInfo.userCurrentRole == 'Employee'
                          ? PopupMenuItem<String>(
                              value: 'MANUAL_ATTENDANCE',
                              child: Text('Request for attendance'),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                            ),
                      model.userAuthenticationInfo.userCurrentRole == 'Employee'
                          ? PopupMenuItem<String>(
                              value: 'APPLIED_LEAVES',
                              child: Text('Applied leaves'),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                            ),
                      model.userAuthenticationInfo.userCurrentRole == 'Employee'
                          ? PopupMenuItem<String>(
                              value: 'LEAVE_REQ_DIALOG',
                              child: Text('Apply for leave'),
                            )
                          : PopupMenuItem(
                              height: 0.0,
                            ),

//                  !employeeMenu
//                      ? PopupMenuItem<String>(
//                    value: 'ATTENDANCE_REQUEST_LIST_FOR_ADMIN',
//                    child: Text('Attendance requests'),
//                  )
//                      : PopupMenuItem(
//                    height: 0.0,
//                  ),
//                  !employeeMenu
//                      ? PopupMenuItem<String>(
//                    value: 'DAILY_TRACKING',
//                    child: Text('Daily tracking'),
//                  )
//                      : PopupMenuItem(
//                    height: 0.0,
//                  ),
                      PopupMenuItem<String>(
                        value: 'CHANGE_PASS',
                        child: Text('Change password'),
                      ),
                      PopupMenuItem<String>(
                        value: 'LOGOUT',
                        child: Text('Logout'),
                      ),
                      PopupMenuItem<String>(
                        value: 'UNREGISTER',
                        child: Text('Unregister'),
                      ),
                    ],
                  ),
                ],
              ),
              body: Container(
                  child: Column(
                children: <Widget>[
                  Container(
                    child: model.userAuthenticationInfo.userCurrentRole == null
                        ? CircularProgressIndicator()
                        : model.userAuthenticationInfo.userCurrentRole ==
                                'Admin'
                            ? adminDashboard(model.allDashboardData)
                            : employeeDashboard(model),
                  ),
                ],
              )),
            ));
      },
    );
  }

  Widget adminDashboard(AdminDashboard data) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.people),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Employees to attend',
                  value: data.currentShiftEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/currentShiftEmp');
              },
            ),
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.sentiment_satisfied),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Day-off',
                  value: data.dayOffEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/dayOffEmp');
              },
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.sentiment_satisfied),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'On time',
                  value: data.onTimeEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/onTimeEmp');
              },
            ),
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.warning),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Late',
                  value: data.lateEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/lateEmp');
              },
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.alarm_on),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Present',
                  value: data.presentEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/presentEmp');
              },
            ),
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.sentiment_dissatisfied),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Absent',
                  value: data.absentEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/absentEmp');
              },
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.directions_car),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'On-leave',
                  value: data.onLeaveEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/onLeaveEmp');
              },
            ),
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.flight),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Leave requests',
                  value: data.leaveRequestsCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/leaveRequests');
              },
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.library_books),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Attendance requests',
                  value: data.attendanceRequestsCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/adminAttendanceRequestList');
//                builder: (context) => AttendanceListPage()));
              },
            ),
            InkWell(
              child: Utility.cardWidget(
                  context: context,
                  icon: Icon(Icons.location_on),
                  primaryColor: Color(0xFFF0F0F0),
                  title: 'Track employee',
                  value: data.trackableEmpCount.toString(),
                  clickIcon: Icon(
                    Icons.launch,
                    size: 15.0,
                    color: Colors.black,
                  )),
              onTap: () {
                Navigator.pushNamed(context, '/trackableEmp');
              },
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget employeeDashboard(MainModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * .5 / 10,
                child: Row(
                  children: <Widget>[
//                    Text(
//                      _timeString,
//                      style:
//                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                    ),
                  ],
                )),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF36AFEA),
                      Color(0xFF37B8E5),
                      Color(0xFF38C1E0),
                      Color(0xFF39CCDA),
                      Color(0xFF3AD8D3),
                    ],
                  ),
                  color: Theme.of(context).primaryColorDark,
                  shape: BoxShape.circle,
                ),
                width: MediaQuery.of(context).size.width * 2 / 5,
                height: MediaQuery.of(context).size.height * 2.3 / 10,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text('Give',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                      Center(
                        child: Text('Attendance',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                Navigator.pushNamed(context, '/imageViewer');
              },
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * .5 / 10,
          child: Center(
            child: Text(
              'Today\'s Attendances',
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .5 / 10,
          child: Center(
            child: Text(
              DateFormat.yMMMEd().format(
                DateTime.parse(
                  DateTime.now().toString(),
                ),
              ),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        !refreshPersonalList
            ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0)),
                ),
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(top: 5.0),
                height: MediaQuery.of(context).size.height * 4.02 / 10,
                child: CurrentDateAttendanceWidget(model),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 100.0),
                child: Center(child: CircularProgressIndicator()))
      ],
    );
  }
}
