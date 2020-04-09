
import 'package:baniadam/models/employeeDashboard.dart';
import 'package:baniadam/models/employeeOperations.dart';
import 'package:baniadam/scoped-models/main.dart';
//import 'package:baniadam/widgets/employee/attendance_Item_cart.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class AttendanceDetailListWidget extends StatelessWidget {

  Widget _buildEmployeeList(List<AttendanceDetail> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AttendanceDetailItemCard(data[index]),
        itemCount: data.length,

      );
    }else{
      itemCards = Container();
    }
    return itemCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildEmployeeList(model.attendanceDetailData);
//      return Text('ok');
      },
    );
  }
}



class AttendanceDetailItemCard extends StatelessWidget {
  final AttendanceDetail detailData;

  AttendanceDetailItemCard(this.detailData);

  String convert12(String str) {
    String finalTime;
    int h1 = int.parse(str.substring(0,1)) - 0;
    int h2 = int.parse(str.substring(1,2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = " AM";
    } else
      Meridien = " PM";
    hh %= 12;
    if (hh == 0 && Meridien == ' PM') {
      finalTime = '12' +str.substring(2);
    } else {
      finalTime = hh.toString() +str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }

  Widget _buildItemRow() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: <Widget>[
          ListTile(
              title: Container(
                padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
//                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            height: 25.0,
                            width: 35.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(5.0),
                              color: detailData.flag == 'in'
                                  ? Color(0xFFAFF0B2)
                                  : Color(0xFFFFCB96),
                              child: Center(
                                child: Text(
                                  detailData.flag,
                                  style: TextStyle(
                                      color:Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('at ' + convert12(detailData.time),style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                              'Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            child: detailData.date != null
                                ? Text(
                              detailData.date,
                            )
                                : Text('Not mentioned')),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
//          Image.network(employee.image),
          _buildItemRow(),
        ],
      ),
    );
    ;
  }
}







//import 'package:baniadam/models/employeeOperations.dart';
//import 'package:baniadam/scoped-models/main.dart';
//import 'package:flutter/material.dart';
//import 'package:scoped_model/scoped_model.dart';
//
//
//
//class AttendanceDetailListWidget extends StatelessWidget {
//
//  Widget _buildList(List<AttendanceDetail> data){
//    Widget itemCards;
//    if(data.length >0){
//      itemCards = ListView.builder(
//        itemBuilder: (BuildContext context, int index) =>
//            AttendanceDetailItemCard(data[index]),
////        itemCount: data.length,
//
//      );
//    }else{
//      itemCards = Container();
//    }
//    return itemCards;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModelDescendant<MainModel>(
//      builder: (BuildContext context, Widget child, MainModel model) {
//        return _buildList(model.attendanceDetailData);
//      },
//    );
//  }
//}
//
//
//
//class AttendanceDetailItemCard extends StatelessWidget {
//  final AttendanceDetail detailData;
//
//  AttendanceDetailItemCard(this.detailData);
//
//  String convert12(String str) {
//    String finalTime;
//    int h1 = int.parse(str.substring(0,1)) - 0;
//    int h2 = int.parse(str.substring(1,2));
//    int hh = h1 * 10 + h2;
//
//    String Meridien;
//    if (hh < 12) {
//      Meridien = " AM";
//    } else
//      Meridien = " PM";
//    hh %= 12;
//    if (hh == 0 && Meridien == ' PM') {
//      finalTime = '12' +str.substring(2);
//    } else {
//      finalTime = hh.toString() +str.substring(2);
//    }
//    finalTime = finalTime + Meridien;
////    print(finalTime);
//    return finalTime;
//  }
//
//  Widget _buildItemRow() {
//    return Card(
//      color: Colors.white,
//      elevation: 4.0,
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(10.0)
//      ),
//      child: Column(
//        children: <Widget>[
//          ListTile(
//              title: Container(
//                padding: EdgeInsets.only(top:10.0,bottom: 10.0),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Container(
////                      decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
//                            decoration: BoxDecoration(
//                                border: Border.all(color: Colors.white),
//                                borderRadius: BorderRadius.circular(10.0)),
//                            height: 25.0,
//                            width: 35.0,
//                            child: Material(
//                              borderRadius: BorderRadius.circular(5.0),
//                              color: detailData.flag == 'in'
//                                  ? Color(0xFFAFF0B2)
//                                  : Color(0xFFFFCB96),
//                              child: Center(
//                                child: Text(
//                                  detailData.flag,
//                                  style: TextStyle(
//                                      color:Colors.black),
//                                ),
//                              ),
//                            )),
//                        SizedBox(width: 10.0),
//                        Text('at ' + convert12(detailData.time),style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 5.0,
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Container(
//                            child: Text(
//                              'Time: ',
//                              style: TextStyle(fontWeight: FontWeight.bold),
//                            )),
//                        Container(
//                            child: detailData.time != null
//                                ? Text(
//                              detailData.time,
//                            )
//                                : Text('Not mentioned')),
//                        SizedBox(width: 10.0),
//                      ],
//                    ),
//                  ],
//                ),
//              )),
//        ],
//      ),
//    );
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      child: Column(
//        children: <Widget>[
////          Image.network(employee.image),
//          _buildItemRow(),
//        ],
//      ),
//    );
//    ;
//  }
//}
