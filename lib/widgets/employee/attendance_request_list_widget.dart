
import 'package:baniadam/models/employeeOperations.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';



class AttendanceRequestListWidget extends StatelessWidget {

  Widget _buildAttendanceRequestsList(List<AttendanceRequests> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AttendanceRequestItemCard(data[index],index),
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
        return _buildAttendanceRequestsList(model.attendanceRequests);
      },
    );
  }
}





class AttendanceRequestItemCard extends StatelessWidget {
  final AttendanceRequests requestData;
  final int index;

  AttendanceRequestItemCard(this.requestData, this.index);

  String convert12(String s) {
    String finalTime;
    String str = s.substring(0,5);
    int h1 = int.parse(str.substring(0,1)) - 0;
    int h2 = int.parse(str.substring(1,2));
    int hh = h1 * 10 + h2;

    String Meridien;
    if (hh < 12) {
      Meridien = "AM";
    } else
      Meridien = "PM";
    hh %= 12;
    if (hh == 0 && Meridien == 'PM') {
//      finalTime = '12' +str.substring(2);
      finalTime = '12' +str.substring(2);
    } else {
//      finalTime = hh.toString() +str.substring(2);
      finalTime = hh.toString() +str.substring(2);
    }
    finalTime = finalTime + Meridien;
//    print(finalTime);
    return finalTime;
  }


  Widget _buildItemRow(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
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
                              color: requestData.flag == 'in'
                                  ? Color(0xFFAFF0B2)
                                  : Color(0xFFFFCB96),
                              child: Center(
                                child: Text(
                                  requestData.flag,
                                  style: TextStyle(
                                      color:Colors.black),
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Text('request for ' +
                            convert12(requestData.time) + '  ' +
//                            DateFormat.yMMMd().format(DateTime.parse(listData['date']))
                            DateFormat('d-MMM-yy').format(DateTime.parse(requestData.date))
                          ,style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            child: requestData.status != null
                                ? Text(
                              requestData.status,
                            )
                                : Text('')),
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
//          Text('Time:' + requestData.time.toString()),
//          SizedBox( width: 8.0,),
//          Text('Flag:' + requestData.flag.toString()),
//          SizedBox( width: 8.0,),
//          Text(requestData.status),
//        ],
//      ),
//    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          _buildItemRow(context),
        ],
      ),
    );
    ;
  }
}


