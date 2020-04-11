
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/models/adminDashboard.dart';
import 'package:baniadam/scoped-models/adminUtilityScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin AdminDashboardScopedModel on Model{


  AdminDashboard _dashboardItem;
  bool _isLoading = false;
  int empToAttendCount;
  int dayOfEmpCount;
  int onLeaveEmpCount;
  int onTimeEmpCount;
  int lateEmpCount;
  int presentEmpCount;
  int leaveRequestsCount;
  int absentEmpCount;
  int attendanceRequestsCount;
  int currentTrackingEmpCount;

  AdminDashboard get allDashboardData{
    return _dashboardItem;
  }

  Future<Null> fetchDashboardData() async{
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> dashboardItem1 = await ApiService.getDashboardItemCount1();
    if (dashboardItem1 != null) {

        empToAttendCount = dashboardItem1['empToAttend'];
        dayOfEmpCount = dashboardItem1['dayOff'];
        onLeaveEmpCount = dashboardItem1['onLeave'];
    }
    Map<String, dynamic> dashboardItem2 =
    await ApiService.getDashboardItemCount2();
    if (dashboardItem1 != null) {

        onTimeEmpCount = dashboardItem2['ontime'];
        lateEmpCount = dashboardItem2['late'];
        absentEmpCount = dashboardItem2['absent'];
    }

    Map<String, dynamic> dashboardItem3 =
    await ApiService.getDashboardItemCount3();
    if (dashboardItem1 != null) {
        attendanceRequestsCount = dashboardItem3['attendance_requests'];
        currentTrackingEmpCount = dashboardItem3['now_tracking'];
    }
    final Map<String, dynamic> dashboardItem4 = await ApiService.getDashBoardData();
    if (dashboardItem4 != null) {
      presentEmpCount = dashboardItem4['data']['total_present'];
      leaveRequestsCount = dashboardItem4['data']['total_pending_leave_applications'];
    }

    if (dashboardItem1 == null || dashboardItem2 == null || dashboardItem3 == null || dashboardItem4 == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    final AdminDashboard dashboardItemsCount = AdminDashboard(
      currentShiftEmpCount: dashboardItem1['empToAttend'],
      dayOffEmpCount: dashboardItem1['dayOff'],
      onLeaveEmpCount: dashboardItem1['onLeave'],
      onTimeEmpCount: dashboardItem2['ontime'],
      lateEmpCount: dashboardItem2['late'],
      absentEmpCount: dashboardItem2['absent'],
      attendanceRequestsCount: dashboardItem3['attendance_requests'],
      trackableEmpCount: dashboardItem3['now_tracking'],
      presentEmpCount: dashboardItem4['data']['total_present'],
      leaveRequestsCount: dashboardItem4['data']['total_pending_leave_applications'],
    );
    _dashboardItem = dashboardItemsCount;
    _isLoading = false;
    notifyListeners();
    return;
  }


  bool get isDashLoading {
    return _isLoading;
  }
}

//mixin UtilityModel on AdminDashboardScopedModel {
//
//  bool get isLoading {
//    return _isLoading;
//  }
//}

