
import 'package:baniadam/models/employeeDashboard.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class AttendanceListWidget extends StatelessWidget {

  Widget _buildEmployeeList(List<EmployeeDashboard> employees){
    Widget itemCards;
    if(employees.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AttendanceItemCard(employees[index]),itemCount: employees.length,

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
        return _buildEmployeeList(model.allAttendances);
      },
    );
  }
}



class AttendanceItemCard extends StatelessWidget {
  final EmployeeDashboard attendanceData;

  AttendanceItemCard(this.attendanceData);

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
                              color: attendanceData.flag == 'in'
                                  ? Color(0xFFAFF0B2)
                                  : Color(0xFFFFCB96),
                              child: Center(
                                child: Text(
                                  attendanceData.flag,
                                  style: TextStyle(
                                      color:Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('at ' + convert12(attendanceData.time),style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                              'Reason: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            child: attendanceData.reason != null
                                ? Text(
                              attendanceData.reason,
                            )
                                : Text('Not mentioned')),
//                        Container(
//                          child: listData['note'] != null
//                              ? Text('Notes : ' + listData['note'])
//                              : Text('Notes : None'),
//                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
//    return Container(
//      padding: EdgeInsets.only(top: 10.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text(attendanceData.time.toString()),
//          SizedBox( width: 8.0,),
//          Text(attendanceData.flag)
//        ],
//      ),
//    );
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

