import 'package:flutter/material.dart';

class EmployeeOperations {
  final String flag;
  final String time;
  final String reason;


  EmployeeOperations({
    @required this.flag,
    @required this.time,
    @required this.reason,
  });
}

class EmployeeInfo {
  final int id;
  final String employeeId;
  final String empName;
  final String photoUrl;


  EmployeeInfo({
    @required this.id,
    @required this.employeeId,
    @required this.empName,
    @required this.photoUrl,
  });
}

class MonthlyAttendance {
  final String status;
  final String inTime;
  final String outTime;
  final String dates;
  final String offDayDate;
  final String offDayType;
  final String offDayStatus;


  MonthlyAttendance({
    @required this.status,
    @required this.inTime,
    @required this.outTime,
    @required this.dates,
    @required this.offDayDate,
    @required this.offDayType,
    @required this.offDayStatus,

  });
}


class AppliedLeaves {
  final String leaveType;
  final String status;
  final String fromDate;
  final String toDate;
  final String reason;
  final String appliedOn;


  AppliedLeaves({
    @required this.leaveType,
    @required this.status,
    @required this.fromDate,
    @required this.toDate,
    @required this.reason,
    @required this.appliedOn,
  });
}


class AttendanceRequests {
  final String status;
  final String flag;
  final String time;
  final String date;


  AttendanceRequests({
    @required this.status,
    @required this.flag,
    @required this.time,
    @required this.date,
  });
}

class AttendanceDetail {
  final String date;
  final String flag;
  final String time;


  AttendanceDetail({
    @required this.date,
    @required this.flag,
    @required this.time,
  });
}
