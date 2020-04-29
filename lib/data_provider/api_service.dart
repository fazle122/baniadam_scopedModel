import 'package:baniadam/helper/AuthHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {

//  static final String BASE_URL = "https://api.baniadam.app/"; //original
  static final String BASE_URL = "http://devapi.baniadam.info/"; //dev
//  static final String BASE_URL ="http://testapi.baniadam.info/"; //test

//  static final String CDN_URl = "https://cdn.baniadam.app/"; //original
  static final String CDN_URl = "http://devcdn.baniadam.info/"; //dev
//  static final String CDN_URl = "http://testcdn.baniadam.info/"; //test


  static final Dio dioService = new Dio();

  static Future<Map<String, dynamic>> login(
      String userName, String password, String cID,String instanceId) async {
    String qString = ApiService.BASE_URL + "$cID/api/in/v1/login";
    var responseData;

    final Map<String, dynamic> authData = {
      'grant_type': 'password',
      'client_id': 3,
      'client_secret': 'W5nQYuW1OFknDwiFnU96Y7dBMqTJ5jG6r6AXYk9q',
      'username': userName,
      'password': password,
    };
    try {
      final http.Response response = await http.post(
        qString,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['code'] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username',userName);
      prefs.setString('password',password);
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> logout(String cID,String instanceId) async {
    String qString = ApiService.BASE_URL + "$cID/api/in/v1/logout";
    var responseData;

    final Map<String, dynamic> authData = {
      'grant_type': 'password',
      'client_id': 3,
      'client_secret': 'W5nQYuW1OFknDwiFnU96Y7dBMqTJ5jG6r6AXYk9q',
    };
    try {
      final http.Response response = await http.post(
        qString,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['code'] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> createActivityLog(
      String cID,String token,String deviceType,String instanceId,String userId,String activity,String lat,String lng,String createdAt,String whereFrom) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token1 = prefs.getString('user-token');
    String qString = ApiService.BASE_URL + "$cID/api/in/v1/utilities/activitylogs/create";
    var responseData;

    final Map<String, dynamic> authData = {
    'device_type':deviceType,
    'instance_id':instanceId,
    'user_id':userId,
    'activity':activity,
    'lat':lat,
    'lng':lng,
    'created_at':createdAt,
//    'where_from':''
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token1,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.post(
        qString,
        body: json.encode(authData),
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['code'] == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getActivityLog(
      String userName, String password, String cID,String instanceId) async {
    String qString = ApiService.BASE_URL + "$cID/api/in/v1/login";
    var responseData;

    final Map<String, dynamic> authData = {
      'grant_type': 'password',
      'client_id': 3,
      'client_secret': 'W5nQYuW1OFknDwiFnU96Y7dBMqTJ5jG6r6AXYk9q',
      'username': userName,
      'password': password,
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: {'Content-Type': 'application/json'},
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['code'] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username',userName);
      prefs.setString('password',password);
      return responseData;
    }
    return responseData;
  }

//  static void logOut() async {
//    await AuthHelper.prefs.remove('user-token'); //add guest user
//  }

//  static Future<String> changePassword(String oldPass, String newPass) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('user-token');
//    var cID = prefs.getString('curr-cid');
//
//    String qString = BASE_URL + "$cID/api/in/v1/user/pasword/change";
//
//    final Map<String, dynamic> authData = {
//      'old_password': oldPass,
//      'new_password': newPass,
//    };
//
//    Map<String, String> headers = {
//      'Authorization': 'Bearer ' + token,
//      'Content-Type': 'application/json',
//    };
//
//    final http.Response response = await http.patch(
//      qString,
//      body: json.encode(authData),
//    );
//     final String responseData = response.body;
//
//    if (response.statusCode == 200) {
//      return responseData;
//    }
//    return responseData;
//  }

  static Future<Map<String,dynamic>> changePassword(String oldPass, String newPass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/user/pasword/change";

    final Map<String, dynamic> authData = {
      'old_password': oldPass,
      'new_password': newPass,
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.patch(
      qString,
      body: json.encode(authData),
      headers: headers,
    );
    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> attendanceRequest(
      FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    dioService.options.headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/app";

    final Response response = await dioService.post(
      qString,
      data: formData,
    );

    bool hasError = true;
    String message = 'Something went wrong';
    Map<String, dynamic> attribute = Map();

    if (response.statusCode == 200 || response.statusCode == 201) {
      hasError = false;
      message = response.data['msg'];
      attribute = response.data['data']['attendance'];
    } else {
      // Map<String, dynamic> _responseMap = json.decode(response.data);
      print(response.statusMessage);
    }

    return {'success': !hasError, 'message': message,'id':attribute['id']};
  }


  static Future<Map<String, dynamic>> manualAttendanceRequestIn(
      FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    dioService.options.headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    Response response;
    String qString = BASE_URL + "$cID/api/in/v1/accounts/my/attendance/request/firstin";

    bool hasError = true;
    String message = 'Something went wrong';
    Map<String, dynamic> attribute = Map();

    try {
      response = await dioService.post(
        qString,
        data: formData,
      );
    } on DioError catch(e) {
      return {'success': !hasError, 'message': e.response.data['msg']};
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      hasError = false;
      message = response.data['msg'];
    } else {
      hasError = true;
//      message = response.data['msg'];

    }
    return {'success': !hasError, 'message': message};
  }

  static Future<Map<String, dynamic>> manualAttendanceRequestOut(
      FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    dioService.options.headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    Response response;
    String qString = BASE_URL + "$cID/api/in/v1/accounts/my/attendance/request/lastout";
    bool hasError = true;
    String message = 'Something went wrong';
    Map<String, dynamic> attribute = Map();

    try {
      response = await dioService.post(
        qString,
        data: formData,
      );
    } on DioError catch(e) {
      return {'success': !hasError, 'message': e.response.data['msg']};
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      hasError = false;
      message = response.data['msg'];
    }
    else {
      hasError = true;
//      message = response.data['msg'];
    }

    return {'success': !hasError, 'message': message};
  }




//  static Future<Map<String, dynamic>> updateAttendanceRequest(var attendanceId,
  static Future<void> updateAttendanceRequest(var attendanceId,
      FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    dioService.options.headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/$attendanceId/selfie";

    final Response response = await dioService.post(
      qString,
      data: formData,
    );

    bool hasError = true;
    String message = 'Something went wrong';

    if (response.statusCode == 200) {
      print(response.data);
      print(response.data['message']);
      hasError = false;
      message = response.data['flag'];
    } else {
      // Map<String, dynamic> _responseMap = json.decode(response.data);
      print(response.statusMessage);
    }

//    return {'success': !hasError, 'message': message};
  }

  static Future<Map<String, dynamic>> attendanceRequest2
//      (int uId, int dId,double lng, double lat, String flag, int reason) async {
      (String uId, String dId, String lng, String lat, String flag,
          String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/request";
//        "http://$cID" +"api.ideaxen.net/" +
//        "$cID/api/in/v1/attendances/attendance/request";

    final Map<String, dynamic> authData = {
      'uid': uId,
      'did': dId,
      'lng': lng,
      'lat': lat,
      'flag': flag,
      'reason': reason
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
//       responseData['access_token'] = responseData['result']['token'];
//       responseData['result']['message'] = responseData['message'];
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> attendanceRerjection(
      int attendanceId, String status, String note, String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/attendances/attendance/approve/$attendanceId";
    final Map<String, dynamic> authData = {
      'status': status,
      'note': note,
      'decline_reason': reason
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<String> attendanceApproval(
      int attendanceId, String status, String note, String declineId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/attendances/attendance/approve/$attendanceId";
    final Map<String, dynamic> authData = {
      'status': status,
      'note': note,
      'decline_reason': declineId,
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final String responseData = response.body;
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getAttendanceRequestReasons_old() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=attendance_request_reason";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData;
  }


  static Future<List<dynamic>> getAttendanceRequestReasons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=attendance_request_reason";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    var responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData;
  }

//  Future<List<Employee>> currentUser(String token) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('user-token');
//    var cID = prefs.getString('curr-cid');
//    String qString = BASE_URL +
////    "http://$cID" +"api.ideaxen.net/" +
//        "$cID/api/in/v1/employees/employee/user/profile";
//    var responseData;
//    try {
//      final http.Response response = await http.get(qString);
////       headers: {'Content-Type': 'application/json'}
//      responseData = json.decode(response.body);
//    } catch (Exception) {
//      return null;
//    }
//    if (responseData['code'] != 200 || responseData['result'] == null) {
//      return null;
//    }
//    final Iterable list = responseData['result']['architects'];
//    List<dynamic> map = list;
//    return map;
//
////     Employee employeeList = await mapApiService.currentUser(token);
////     return employeeList;
//  }

  static Future<Map<String, dynamic>> getAttendanceListOld(
      Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/attendances/attendance/pending?";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    if (filters != null) {
      if (filters.containsKey('from') && filters['from'] != null) {
        qString += 'from=' + filters['from'];
      }
      if (filters.containsKey('to') && filters['to'] != null) {
        qString += '&to=' + filters['to'];
      }
      if (filters.containsKey('duration') && filters['duration'] != null) {
        qString += 'duration=' + filters['duration'];
      }
      if (filters.containsKey('status') && filters['status'] != null) {
        qString += '&status=' + filters['status'];
      }
      if (filters.containsKey('page') && filters['page'] != null) {
        qString += '&page=' + filters['page'].toString();
//        qString += '&per_page' + 10.toString();
      }
    }
    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getTrackedEmployees(
      Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        //    "$cID/api/in/v1/employees/employee?";
        "$cID/api/in/v1/employees/tracker/trackedemployees?";

    if (filters != null) {
      if (filters.containsKey('date') && filters['date'] != 'null') {
        qString += 'date=' + filters['date'];
      }

      if (filters.containsKey('branch') && filters['branch'] != 'null') {
        qString += '&branch=' + filters['branch'];
      }
      if (filters.containsKey('department') &&
          filters['department'] != 'null') {
        qString += '&department=' + filters['department'];
      }
      if (filters.containsKey('category') &&
          filters['category'] != 'null') {
        qString += '&category=' + filters['category'];
      }
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getAttendanceList(
      Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/reports/attendance/daily?per_page=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> authData = {
      'attendance_status': ["Present"],
    };

    final http.Response response = await http.post(
      qString,
      headers: headers,
      body: json.encode(authData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }


  static Future<Map<String, dynamic>> getDashboardItemCount1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/ea_do_ol";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getDashboardItemCount2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/ola";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getDashboardItemCount3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/attreq_trackingnow";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getCurrentShiftEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('user-token');
//    var cID = prefs.getString('curr-cid');

    var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjVhZmQ0NDYwYWU0Y2IyYWYwZjkwOGMyNTY5MzgzYjM2NzEwYTM3MGY3NzcwNmRmZDljYTMxY2ZjMjhmNWVmZjg2N2UxMmM3ZGI5Y2E3Yzc3In0.eyJhdWQiOiIzIiwianRpIjoiNWFmZDQ0NjBhZTRjYjJhZjBmOTA4YzI1NjkzODNiMzY3MTBhMzcwZjc3NzA2ZGZkOWNhMzFjZmMyOGY1ZWZmODY3ZTEyYzdkYjljYTdjNzciLCJpYXQiOjE1ODUyMjMzNTUsIm5iZiI6MTU4NTIyMzM1NSwiZXhwIjoxNjE2NzU5MzU1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.i5hnv2zPy07QAKH33m0JiEkJ2JujaKSGDTh1ZMXvhsraIXJ_eHAOxZOmrcAaF_Y9NwGHgliXfCRAuYo-QcYD0g2uZumDLcrDW3fJCwuKnCgN2RBoeM3w4Z5ERlxdO4wqLfuiVY3ycbtXW0213R63M0VEKALlFb-7Ivi73QREFyqOll9tjqFKVtWJF_IOcbsgkriPG3b4vGLZCleEuzmiGYzqlbrV95U9SjkeeiQl1thRxE6xLGgnYuTlqndUG5dc5VsAZN_yRBJ5Y3JG53c96sK5Q-55ICCKb1sjpU_I2JtzKEswXv4_4F5b1YEtnHXpuVZKVfI8-sxUdV1_3m0Whc6Y1nog81jEo2iHD4LZSR3ekKPm0e12kN9ZQuxUlfMq65pwwBa2hpjYs4PjrXoqJOZ9oLniZ6NXPd9SWLQEJB-A1R5CFXYGmW4EfsluyI41FQGva7EHb7XSc11eAjpdZZNj8oYMM-1o1NIgBjeU2HezysgOHtsDkjSGOW-79W9C5gn5auxcQVu1JG-ZEx7Sy0G93QF5mYjAZANHlx9DM9KRkDbKnezHwhU43qlbXh43iYle34wsB-WHngIRQIPvbf9vX-jjrsLSEJXbRQdWKpAAOLb-mgHOfpoSML5bp5jooRHxi6MugsujDIEPwC-IlDf1p8me0PTLZ6sPHygfcrM";
    var cID = 'ideaxen';

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/emptoattend?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getDayOffEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/dayofftoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getOnTimeEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/ontimetoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getLateEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/latetoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getPresentEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/presenttoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getAbsentEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/absenttoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getOnleaveEmployee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/dashboard/onleavetoday?paginaton=20";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };


    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getAttendanceRequestListForAdmin_old(
      Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
//    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/pending?status[]=PENDING&status[]=APPROVED&status[]=DECLINED";
    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/pending?";

    if (filters.containsKey('date') &&
        filters['date'] != 'null') {
      qString += 'date=' + filters['date'];
    }

    if (filters != null) {
      if (filters.containsKey('status') && filters['status'] != null) {
        for (int i = 0; i < filters['status'].length; i++) {
          qString += '&status[]=' + filters['status'][i];
        }
      }
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['data'] == null) {
      return null;
    }
    return responseData['data'];
  }

  static Future<List<dynamic>> getAttendanceRequestListForAdmin(Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String qString = BASE_URL + "$cID/api/in/v1/attendances/attendance/pending?";

    if (filters.containsKey('date') &&
        filters['date'] != 'null') {
      qString += 'date=' + filters['date'];
    }

    if (filters != null) {
      if (filters.containsKey('status') && filters['status'] != null) {
        for (int i = 0; i < filters['status'].length; i++) {
          qString += '&status[]=' + filters['status'][i];
        }
      }
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData['data'] == null) {
      return null;
    }
    return responseData['data'];
  }


  static Future<List<dynamic>> getAttendanceRequestListForEmployee(
      Map<String, dynamic> filters) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/accounts/my/attendance/requests?";

    if (filters.containsKey('date') &&
        filters['date'] != 'null') {
      qString += 'date=' + filters['date'];
    }

    if (filters != null) {
      if (filters.containsKey('status') && filters['status'] != null) {
        for (int i = 0; i < filters['status'].length; i++) {
          qString += '&status[]=' + filters['status'][i];
        }
      }
    }

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;

  }

  static Future<List<dynamic>> getDateWisePersonalAttendanceList(
      int employeeId, var date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "$cID/api/in/v1/attendances/attendance/details?employee=$employeeId&date=$date";
        "$cID/api/in/v1/accounts/my/attendance?date=$date";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

//    final List<dynamic> responseData = json.decode(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data']['attendance'];
    }
    return responseData['data']['attendance'];
  }

  static Future<List<dynamic>> getCurrentDatePersonalAttendanceList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "$cID/api/in/v1/attendances/attendance/details?employee=$employeeId&date=$date";
        "$cID/api/in/v1/attendances/attendance/my";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String,dynamic>> getCurrentDatePersonalAttendanceList1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
//        "$cID/api/in/v1/attendances/attendance/details?employee=$employeeId&date=$date";
        "$cID/api/in/v1/attendances/attendance/my";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String,dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getCurrentDateAttendanceDetail(
      empId, date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/attendances/attendance/details?employee=$empId&date=$date";
//                        attendances/attendance/details?employee=2&date=2020-02-3

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }


  static Future<Map<String,dynamic>> getCurrentDateTrackingDetail(
      empId, date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/employees/tracker/trackingrecords?employee=$empId&date=$date";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String,dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<List<dynamic>> getCustomePersonalAttendanceList(
      int employeeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/attendances/attendance/details?employee=$employeeId";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getMonthlyAttendanceData(
      int employeeId, Map<String, dynamic> filters) async {
    var now = DateTime.now();
    int _currentYear = now.year;
    int _currentMonth = now.month;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String qString = BASE_URL +
//        "$cID/api/in/v1/employees/employee/dashboard?employee=$employeeId";
        "$cID/api/in/v1/accounts/my/dashboard";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  static Future<String> getAttendanceFlag(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/attendances/attendance/flag/$id";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

//    final String responseData = json.decode(response.body);
    final String responseData = response.body;
    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getEmployeeDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String queryString = BASE_URL +
        "$cID/api/in/v1/employees/employee/user/profile";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        queryString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }
    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getEmployeeDetail1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String queryString = BASE_URL +
        "$cID/api/in/v1/employees/employee/user/profile";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        queryString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }
    if (responseData == null) {
      return null;
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> leaveRequest
//      (int uId, int dId,double lng, double lat, String flag, int reason) async {
      (String leaveType, String fromDate, String toDate, String reason,
          String leaveMode, String leaveModeShift) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');
    String qString = BASE_URL +
//        "http://$cID" + "api.ideaxen.net/" +
        "$cID/api/in/v1/leave/add";
    final Map<String, dynamic> authData = {
      'leave_type': leaveType,
      'from': fromDate,
      'to': toDate,
      'status': 'pending',
      'reason': reason,
      'leave_mode': leaveMode,
      'half_day_shift': leaveModeShift
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);

    if (response.statusCode == 200) {
      hasError = false;
      message = responseData['msg'];
    } else {
      message = responseData['msg'];
    }
    return {'success': !hasError, 'message': message};
  }

  static Future<Map<String, dynamic>> getLeavesList(
      Map<String, dynamic> filters) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String qString = BASE_URL + "$cID/api/in/v1/leave?";

    if (filters != null) {
//      if (filters.containsKey('status') && filters['status'] == 'Pending') {
//        qString += '&status[]=' + 'Requested for Cancellation';
//      }
      if (filters.containsKey('branch') && filters['branch'] != 'null') {
        qString += '&branch=' + filters['branch'];
      }
      if (filters.containsKey('designation') &&
          filters['designation'] != 'null') {
        qString += '&designation=' + filters['designation'];
      }
      if (filters.containsKey('department') &&
          filters['department'] != 'null') {
        qString += '&department=' + filters['department'];
      }
      if (filters.containsKey('leave_type') &&
          filters['leave_type'] != 'null') {
        qString += '&leave_type=' + filters['leave_type'];
      }
//      if (filters.containsKey('status') && filters['status'] != null) {
//        qString += '&status[]=' + filters['status'];
//      }
      if (filters.containsKey('status') && filters['status'] != null) {
        for (int i = 0; i < filters['status'].length; i++) {
          qString += '&status[]=' + filters['status'][i];
        }
      }
    }
//    else{
//      qString = BASE_URL + "$cID/api/in/v1/leave?status[]=Requested for Cancellation";
//    }

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  static Future<List<dynamic>> getPersonalLeavesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String qString = BASE_URL +
        "$cID/api/in/v1/leave/myleave";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }

    if (responseData == null) {
      return null;
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getLeave(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String queryString = BASE_URL + "$cID/api/in/v1/leave/show/$id";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        queryString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }
    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  static Future<List<dynamic>> getAllLeaveTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/utilities/lovs?lov=leave_types";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<List<dynamic>> getLeaveTypesForLeaveApply_old() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" + "api.ideaxen.net/" +
        "$cID/api/in/v1/leave/balance";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String,dynamic>> getLeaveTypesForLeaveApply() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" + "api.ideaxen.net/" +
        "$cID/api/in/v1/leave/balance";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    final Map<String,dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      return responseData;
    }
    return responseData;
  }

  static Future<List<dynamic>> getLeaveBalanceForLeaveApply_old(
      DateTime from, DateTime to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/accounts/my/leaves/balance?from=$from&to=$to";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String,dynamic>> getLeaveBalanceForLeaveApply(
      DateTime from, DateTime to) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/accounts/my/leaves/balance?from=$from&to=$to";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );

    final Map<String,dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
      return responseData;
    }
    return responseData;
  }

  static Future<List<dynamic>> getUsersLeaveTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" + "api.ideaxen.net/" +
        "$cID/api/in/v1/leave/balance";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    final List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
//      print(responseData);
      return responseData;
    }
    return responseData;
  }

  static Future<List<dynamic>> getBranchTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/utilities/lovs?lov=branch_types";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }


  static Future<List<dynamic>> getDepartments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=departments";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData['data'];
  }



  static Future<List<dynamic>> getDesignations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=designations";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
//       print(responseData['lov'][0]);
      return responseData['data'];
    }
    return responseData['data'];
  }

  static Future<Map<String, dynamic>> getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=employee_categories";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData;
  }
  static Future<List<dynamic>> getCategories1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/utilities/lovs?lov=employee_categories";
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseData['data'];
    }
    return responseData;
  }


  static Future<Map<String, dynamic>> getLOVDeclineReasons() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        '$cID/api/in/v1/utilities/lovs?lov=attendance_decline_reason';
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.get(
      qString,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
//       print(responseData['lov'][0]);
      return responseData['lov'][0];
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> applyLeaveCancel(
      int leaveId, String cancellationReason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cID/api/in/v1/leave/request/cancel/$leaveId";
    final Map<String, dynamic> authData = {
      'cancel_request_reason': cancellationReason,
    };
//    /brother/api/in/v1/leave/request/cancel/{leave}
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.patch(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> leaveApproval(
      int leaveId, String status, String note, String declineId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL + "$cID/api/in/v1/leave/approve/$leaveId";
    final Map<String, dynamic> authData = {
      'status': status,
      'note': note,
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      body: json.encode(authData),
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> approveAttendanceRequest(
      int leaveId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/attendances/attendance/approve/$leaveId";


    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> declineAttendanceRequest(
      int attendanceId,String note,String declinedReason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    String qString = BASE_URL +
        "$cID/api/in/v1/attendances/attendance/decline/$attendanceId?note=$note&decline_reason=$declinedReason";


    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      qString,
      headers: headers,
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> getLogo(var cId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String qString = BASE_URL +
//        "http://$cID" +"api.ideaxen.net/" +
        "$cId/api/in/v1/company/company/logo";

    Map<String, String> headers = {
//      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        qString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }
    if (responseData != null) {
      prefs.setString('logo-url', responseData['value']);
      return responseData;
    }
    return null;
  }

  static Future<Map<String, dynamic>> getDashBoardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');

    var responseData;
    String queryString = BASE_URL +
        "$cID/api/in/v1/admin/dashboard?pending_request_count=all";

    Map<String, String> headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };
    try {
      final http.Response response = await http.get(
        queryString,
        headers: headers,
      );
      responseData = json.decode(response.body);
    } catch (Exception) {
      return null;
    }
    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  static Future<Map<String, dynamic>> updateEmployeeInfo(FormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    var cID = prefs.getString('curr-cid');
    Response response;

    dioService.options.headers = {
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    String qString = BASE_URL + "$cID/api/in/v1/accounts/my/photo/update";

    response = await dioService.post(
      qString,
      data: formData,
    ).catchError((onPostError) {
      return null;
    });

    bool hasError = true;
    String message = 'Something went wrong';

    if(response = null) {
      return null;
    }else if (response.statusCode == 200) {
      hasError = false;
      message = response.data['msg'];
    } else {
      message = response.data['msg'];
    }

    return {'success': !hasError, 'message': message};

//    Map<String,dynamic> responseData = json.decode(response.data);
//
//    if (response.statusCode == 200) {
//      return responseData;
//    }
//    return responseData;
  }

//  static Future<Map<String, dynamic>> updateEmployeeInfo_old(
//      FormData formData) async {
//    Response response;
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var token = prefs.getString('user-token');
//    var cID = prefs.getString('curr-cid');
//
//    dioService.options.headers = {
//      'Authorization': 'Bearer ' + token,
//      'Content-Type': 'application/json',
//    };
//
//    bool hasError = true;
//    String message = 'Something went wrong';
//
//    String qString = BASE_URL + "$cID/api/in/v1/accounts/my/photo/update";
//
//    response = await dioService
//        .post(
//      qString,
//      data: formData,
//    )
//        .catchError((onPostError) {
////          message = onPostError.response.data['msg'];
////          return message;
//      return null;
////          return {'success': !hasError, 'message': message};
//    });
//
//    if (response == null) {
//      return null;
//    } else if (response.statusCode == 200) {
//      hasError = false;
//      message = 'profile image updates successfully';
//    } else {
//      message = 'please try again';
//    }
//    return {'success': !hasError, 'message': message};
//  }

  static onPostError(err) {
    return err;
  }
}
