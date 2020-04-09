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