
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/widgets/employee/leave_application_dialog.dart';
import 'package:baniadam/widgets/helpers/change_password_dialog.dart';
import 'package:baniadam/widgets/logOut_confirmation_dialog.dart';
import 'package:baniadam/widgets/unRegister_confirmation_dialog.dart';
import 'package:flutter/material.dart';



class Utility {

  static Future<Map<String, dynamic>> logOutDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LogOutConfirmationDialog(),
    );
  }

  static   Future<Map<String, dynamic>> unRegisterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => UnRegisterConfirmationDialog(),
    );
  }

  static Future<Map<String, dynamic>> changePassDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ChangePasswordDialog(),
    );
  }

//  static Future<Map<String, dynamic>> leaveApplicationDialog(BuildContext context) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => LeaveApplicationDialogWidget(),
//    );
//  }

  static Future<void> updateSelfie(attendanceId, attendanceIdSelfie) async {
    ApiService.updateAttendanceRequest(attendanceId, attendanceIdSelfie);
  }



//  static   Future<String> asyncEmpDialog(BuildContext context) async {
//    return showDialog<String>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) =>
//          EmployeeInfoDialog(data: personalDetail),
//    );
//  }

  static Widget cardWidget({BuildContext context,Icon icon, Color primaryColor, String title, String value, Icon clickIcon}) {
    return Container(
        height: MediaQuery.of(context).size.height * 1.5 / 10,
        width: MediaQuery.of(context).size.width * 2.2 / 5,
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Card(
            elevation: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                clickIcon != null
                    ? Center(
                  child: Container(
                    height: 0.0,
                    padding: EdgeInsets.only(right: 10.0),
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: clickIcon,
                  ),
                )
                    : SizedBox(
                  width: 0.0,
                  height: 0.0,
                ),
//                Center(child: clickIcon),
                Center(child: icon),
                Center(
                  child: Text(title),
                ),
                Center(
                  child: Text(value.toString()),
                ),
              ],
            )));
  }


  static Widget sizedContainer({BuildContext context,Widget child}) {
    return new SizedBox(
      width: 100.0,
//      height: 50.0,
      height: MediaQuery.of(context).size.height * 1 / 10,
      child: new Center(
        child: child,
      ),
    );
  }


}