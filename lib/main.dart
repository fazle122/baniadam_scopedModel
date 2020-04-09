import 'package:baniadam/pages/admin/adminAttendanceRequestList.dart';
import 'package:baniadam/pages/admin/leaveRequestsList.dart';
import 'package:baniadam/pages/admin/presentEmployees.dart';
import 'package:baniadam/pages/admin/trackableEmployees.dart';
import 'package:baniadam/pages/employee/empAppliedLeavesList.dart';
import 'package:baniadam/pages/employee/empAttendanceRequestList.dart';
import 'package:baniadam/pages/employee/empMonthlyAttendanceList.dart';
import 'package:baniadam/pages/employee/image_viewer.dart';
import 'package:baniadam/pages/register.dart';
import 'package:baniadam/pages/splash_screen.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/widgets/employee/attendance_request_dialog.dart';
import 'package:baniadam/widgets/employee/leave_application_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/pages/dashboard.dart';
import 'package:baniadam/pages/admin/absentEmployees.dart';
import 'package:baniadam/pages/admin/currentShiftEmployees.dart';
import 'package:baniadam/pages/admin/dayOffEmployees.dart';
import 'package:baniadam/pages/admin/lateEmployees.dart';
import 'package:baniadam/pages/admin/onLeaveEmployees.dart';
import 'package:baniadam/pages/admin/onTimeEmployees.dart';
import 'package:baniadam/pages/login.dart';
import 'package:baniadam/scoped-models/main.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeHR(),
        routes: {
          '/': (BuildContext context) => SplashScreen(model),
          '/register': (BuildContext context) => RegisterPage(model),
          '/logIn':(BuildContext context) => LoginPage(model),
          '/dashboard': (BuildContext context) => DashboardPage(model),
          '/imageViewer': (BuildContext context) => PicturePreviewScreen(model: model,),
          '/currentShiftEmp': (BuildContext context) => CurrentShiftEmployeesListPage(model),
          '/dayOffEmp': (BuildContext context) => DayOffEmployeesListPage(model),
          '/onTimeEmp': (BuildContext context) => OnTimeEmployeesListPage(model),
          '/lateEmp': (BuildContext context) => LateEmployeesListPage(model),
          '/presentEmp': (BuildContext context) => PresentEmployeesListPage(model),
          '/absentEmp':(BuildContext context) => AbsentEmployeesListPage(model),
          '/onLeaveEmp':(BuildContext context) => OnLeaveEmployeesListPage(model),
          '/leaveRequests':(BuildContext context) => LeaveRequestsListPage(model),
          '/trackableEmp':(BuildContext context) => TrackableEmployeesListPage(model),
          '/empMonthlyAttendance':(BuildContext context) => MonthlyAttendanceLIstPage(model),
//          '/attendanceDetail':(BuildContext context) => AttendanceDetailListPage(model),
          '/attendanceRequestList':(BuildContext context) => EmpAttendanceRequestListPage(model),
          '/adminAttendanceRequestList':(BuildContext context) => AdminAttendanceRequestListPage(model),
          '/empAppliedLeaves':(BuildContext context) => AppliedLeaveLIstPage(model),
          '/applyForLeaves':(BuildContext context) => LeaveApplicationDialogWidget(model),
          '/applyForAttendance':(BuildContext context) => AttendanceRequestDialogWidget(model),


//          '/products': (BuildContext context) => ProductsPage(),
//          '/admin': (BuildContext context) => ProductsAdminPage(),
        },
//        onGenerateRoute: (RouteSettings settings) {
//          final List<String> pathElements = settings.name.split('/');
//          if (pathElements[0] != '') {
//            return null;
//          }
//          if (pathElements[1] == 'product') {
//            final int index = int.parse(pathElements[2]);
//            return MaterialPageRoute<bool>(
//              builder: (BuildContext context) =>
//                  ProductPage(index),
//            );
//          }
//          return null;
//        },
//        onUnknownRoute: (RouteSettings settings) {
//          return MaterialPageRoute(
//              builder: (BuildContext context) => ProductsPage());
//        },
      ),
    );
  }
}
