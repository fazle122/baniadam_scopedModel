import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



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

class LeaveRequestsDetailForAdmin {
  final int id;
  final String from;
  final String to;
  final String reason;
  final String status;
  final String appliedOn;
  final String totalDays;
  final String leaveType;
  final String employeeName;
  final String brunch;
  final String department;
  final String designation;


  LeaveRequestsDetailForAdmin({
    @required this.id,
    @required this.from,
    @required this.to,
    @required this.reason,
    @required this. status,
    @required this.appliedOn,
    @required this.totalDays,
    @required this.leaveType,
    @required this.employeeName,
    @required this.brunch,
    @required this.department,
    @required this.designation,
  });
}

class TrackingData {
  int id;
  String activityType;
  String activityAt;
  String speed;
  String latitude;
  String longitude;
  String heading;
  String isMoving;

  TrackingData(
      {
        @required this.id,
        @required this.activityType,
        @required this.activityAt,
        @required this.speed,
        @required this.latitude,
        @required this.longitude,
        @required this.heading,
        @required this.isMoving,
      });
}

class MarkerData{
  int id;
  String activityType;
  String activityAt;
  String speed;
  String latitude;
  String longitude;
  String heading;
  String isMoving;

  MarkerData(this.id,this.activityType, this.activityAt, this.speed,this.latitude,this.longitude,this.heading,this.isMoving);

  Map toJson() {
    return {
      'id': id,
      'activity_type': activityType,
      'activity_at_raw': activityAt,
      'speed': speed,
      'latitude':latitude,
      'longitude':longitude,
      'heading':heading,
      'is_moving':isMoving
    };
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["activity_type"] = activityType;
    map["activity_at_raw"] = activityAt;
    map["speed"] = speed;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["heading"] = heading;
    map['is_moving'] = isMoving;

    return map;
  }
}