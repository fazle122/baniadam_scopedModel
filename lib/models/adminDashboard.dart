import 'package:flutter/material.dart';

class AdminDashboard {
  final int currentShiftEmpCount;
  final int dayOffEmpCount;
  final int onTimeEmpCount;
  final int lateEmpCount;
  final int presentEmpCount;
  final int absentEmpCount;
  final int onLeaveEmpCount;
  final int leaveRequestsCount;
  final int attendanceRequestsCount;
  final int trackableEmpCount;

  AdminDashboard({
    @required this.currentShiftEmpCount,
    @required this.dayOffEmpCount,
    @required this.onTimeEmpCount,
    @required this.lateEmpCount,
    @required this.presentEmpCount,
    @required this.absentEmpCount,
    @required this.onLeaveEmpCount,
    @required this.leaveRequestsCount,
    @required this.attendanceRequestsCount,
    @required this.trackableEmpCount,
  });
}


class LeaveRequest {
  final int id;
  final String employeeName;
  final String fromDate;
  final String toDate;
  final String appliedOn;
  final String reason;
  final String status;

  LeaveRequest({
    @required this.id,
    @required this.employeeName,
    @required this.fromDate,
    @required this.toDate,
    @required this.appliedOn,
    @required this.reason,
    @required this.status,

  });
}
