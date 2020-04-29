import 'package:flutter/material.dart';



class EmployeeList {
  final String id;
  final String name;
  final String image;

  EmployeeList(
      {
        @required this.id,
        @required this.name,
        @required this.image,
      });
}

class AdminAttendanceRequestList{
  final int id;
  final String employeeName;
  final String flag;
  final String status;
  final String time;
  final String date;
  final String appliedOn;


  AdminAttendanceRequestList(
      {
        @required this.id,
        @required this.employeeName,
        @required this.flag,
        @required this.status,
        @required this.time,
        @required this.date,
        @required this.appliedOn,
      });

}

class AttendanceDetailForAdmin {
  final int id;
  final String flag;
  final String selfieUrl;
  final String time;
  final double lat;
  final double lng;
  final String deviceType;


  AttendanceDetailForAdmin({
    @required this.id,
    @required this.flag,
    @required this.selfieUrl,
    @required this.time,
    @required this.lat,
    @required this.lng,
    @required this.deviceType,
  });
}