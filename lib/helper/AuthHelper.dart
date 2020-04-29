import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

//import '../models/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void LocaleChangeCallback(Locale locale);

class AuthHelper {
  static SharedPreferences prefs;
  static String userToken;
//  static Employee currUser;

  static initApp() async {
    prefs = await SharedPreferences.getInstance();
    await getLoginUser();
  }

  static setCompany(String companyId) async {
    prefs = await SharedPreferences.getInstance();
    if(companyId != null) {
      prefs.setString('curr-cid', companyId);
    }
    else{
      prefs.remove('curr-cid');
    }
  }


  static setLoginUser(String userToken,String userType,List<String> userRoles,String userCurrentRole,int isTrackable) async {
    prefs = await SharedPreferences.getInstance();
    if(userToken != null) {
      prefs.setString('user-token', userToken);
      prefs.setString('user-type', userType);
      prefs.setStringList('user-roles', userRoles);
      prefs.setString('user-current-role', userCurrentRole);
      prefs.setInt('isTreckable', isTrackable);

    }
    else{
      prefs.remove('user-token');
    }
  }

  static logOutUser() async {
    prefs = await SharedPreferences.getInstance();
//    prefs.clear();
      prefs.remove('user-token');
      prefs.remove('user-type');
      prefs.remove('user-roles');
      prefs.remove('user-current-role');
      prefs.remove('isTreckable');
  }

  static unregisterUser() async{
    prefs = await SharedPreferences.getInstance();
    prefs.remove('user-token');
    prefs.remove('curr-cid');
    prefs.remove('user-type');
    prefs.remove('user-roles');
    prefs.remove('user-current-role');
    prefs.remove('isTreckable');
    prefs.remove('logo-url');
//    prefs.remove('myInstanceId');
  }

  static updateUserCurrentRole(bool value) async{
    prefs = await SharedPreferences.getInstance();
    prefs.remove('user-current-role');
    if(value) {
      prefs.setString('user-current-role', 'Employee');
    }
    else{
      prefs.setString('user-current-role', 'Admin');

    }
  }

  static getUserCurrentRole() async{
    prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('user-current-role');
    if(role == 'Employee') {
      return true;
    }
    else{
      return false;
    }
  }

  static setCompanyId(String cID) async {
    if(cID != null) {
      prefs = await SharedPreferences.getInstance();
      prefs.setString('curr-cid', cID);
    }
    else{
      prefs.remove('curr-cid');
    }
  }

  static getLoginUser() async{
    prefs = await SharedPreferences.getInstance();
    userToken = await prefs.getString('user-token');
//    print(userToken);
//    String jsonStr = prefs.getString('user-token');
//    currUser = Employee.fromJson(jsonDecode(jsonStr));
  }
}