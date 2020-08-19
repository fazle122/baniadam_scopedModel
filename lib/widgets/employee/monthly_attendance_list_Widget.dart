
import 'package:baniadam/models/employeeOperations.dart';
import 'package:baniadam/pages/employee/empAttendanceDetailList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class MonthlyAttendanceListWidget extends StatelessWidget {

  final MainModel model;

  MonthlyAttendanceListWidget(this.model);

  Widget _buildEmployeeList(List<MonthlyAttendance> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            MonthlyAttendanceItemCard(model,data[index],index),
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
        return _buildEmployeeList(model.monthlyAttendaceData);
      },
    );
  }
}





class MonthlyAttendanceItemCard extends StatelessWidget {
  final Model model;
  final MonthlyAttendance attendanceData;
  final int index;

  MonthlyAttendanceItemCard(this.model,this.attendanceData, this.index);

  Widget _buildItemRow(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        int dayCount = DateTime.parse(attendanceData.dates).day;
        int toDay = DateTime.parse(DateTime.now().toString()).day;
        return
        dayCount <= toDay?
        Container(
            padding: EdgeInsets.only(top: 10.0),
            child: InkWell(
              child: ListTile(
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
//                                    margin: EdgeInsets.only(top: 5.0),
                          child: Text(
                            DateFormat.yMMMEd().format(DateTime.parse(
                                attendanceData.dates)),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),





                        Container(
                          width: MediaQuery.of(context).size.width *
                              1.2 /
                              5,
                          child: (
//                              attendanceData.offDayStatus != null &&
//                              attendanceData.offDayStatus != 'Pending' &&
////                              attendanceData.status != 'Present'
                              attendanceData.offDayType != null
//                                  &&
//                              attendanceData.status != 'Present'
                          )
                              ?
                          Container(
                              margin: EdgeInsets.only(top: 15.0),
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: ShapeDecoration(
                                  shape: AppTheme
                                      .roundedBorderDecoration(),
                                  color: attendanceData.offDayType != null && attendanceData.offDayType == 'leave'
                                      ? Color(0xFF29ABE2)
                                      : attendanceData.offDayType != null && attendanceData.offDayType == 'weekend'
                                      ? Color(0xFF8B1843)
                                      : Color(0xFF29ABE2)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(attendanceData.offDayType,
//                                    attendanceData.offDayType.substring(0, 1).toUpperCase() +
//                                        attendanceData.offDayType.substring(1),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              ))
                              : Container(
                              margin: EdgeInsets.only(top: 15.0),
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              decoration: ShapeDecoration(
                                  shape: AppTheme
                                      .roundedBorderDecoration(),
                                  color: attendanceData.status == 'Present'
                                      ? Color(0xFF8B8B8B)
                                      : attendanceData.status == 'Absent'
                                      ? Color(0xFFED1C24)
                                      : Color(0xFFF7931E)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[

//                                  Text(attendanceData.status == "Absent" && attendanceData.offDayType == "holiday"
//                                      ?attendanceData.offDayType:attendanceData.status,
                                  Text(attendanceData.status,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),







                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                child: Text(
                                  'In: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                child: attendanceData.inTime !=
                                    null &&
                                    attendanceData.inTime !=
                                        'n/a'
                                    ? Text(
                                  convert12(attendanceData.inTime),
                                )
                                    : Text('No data')),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                                child: Text(
                                  'Out: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                child: attendanceData.outTime !=
                                    null &&
                                    attendanceData.outTime !=
                                        'n/a'
                                    ? Text(
                                    convert12(attendanceData.outTime)
                                )
                                    : Text('No data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),

//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text('In Time:' + attendanceData.inTime.toString()),
//                  Text('Out Time:' + attendanceData.outTime.toString()),
//                  SizedBox( width: 8.0,),
//                  Text(attendanceData.status)
//                ],
//              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendanceDetailListPage(model,attendanceData.dates)));
              },
            )
        )
        :SizedBox(width: 0.0,height: 0.0,);
      }
    );

  }

  String convert12(String str) {
    String finalTime;
    int h1 = int.parse(str.substring(0, 1)) - 0;
    int h2 = int.parse(str.substring(1, 2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = " AM";
    } else
      Meridien = " PM";
    hh %= 12;
    if (hh == 0 && Meridien == ' PM') {
      finalTime = '12' + str.substring(2);
    } else {
      finalTime = hh.toString() + str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
//          Image.network(employee.image),
          _buildItemRow(context),
        ],
      ),
    );
    ;
  }
}


