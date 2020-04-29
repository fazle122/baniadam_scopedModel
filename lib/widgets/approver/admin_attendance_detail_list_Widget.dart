import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/pages/admin/locationOnMap.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:toast/toast.dart';


class AdminAttendanceDetailListWidget extends StatelessWidget {

  Widget _buildEmployeeList(List<AttendanceDetailForAdmin> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              AdminAttendanceDetailItemCard(data[index],index),itemCount: data.length,

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
        return _buildEmployeeList(model.allAttendanceDetailForAdmin);
      },
    );
  }
}


class AdminAttendanceDetailItemCard extends StatelessWidget {
  final AttendanceDetailForAdmin detailData;
  final int detailDataIndex;

  AdminAttendanceDetailItemCard(this.detailData, this.detailDataIndex);

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


  Widget _buildItemRow(BuildContext context) {
    return Card(
      color: (detailDataIndex % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),
//      elevation: 8.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
            child: Container(
              color: Theme
                  .of(context)
                  .primaryColorDark,
            ),
          ),
          ListTile(
            title: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: Text('Time: ' + convert12(detailData.time)),
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_album, color: Colors.red,),
                      onPressed: () async {
                        if (detailData.selfieUrl != null) {
                          await viewSelfieDialog(
                              context, detailData.selfieUrl);
                        } else {
                          Toast.show('No selfie taken', context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    )
                  ],
                ),

              ],
            ),
            subtitle: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text('Attendance: ' ),
                            Container(
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
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            Text('From: ' + detailData.deviceType),
                          ],
                        )
                    ),
                    IconButton(
                      icon: Icon(Icons.my_location, color: Color(0xff2390D0),),
                      onPressed: () {
                        if (detailData.lat != null &&
                            detailData.lng != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MapLocation(
                                          lat: detailData.lat,
                                          lng: detailData.lng)));
                        } else {
                          Toast.show('Location data not found', context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static viewSelfieDialog(BuildContext context, var data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(25.0),
              title: Center(child: Text('Attendance selfie')),
              content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Center(
                            child: Container(
                                padding: const EdgeInsets.only(left: 0.0),
//                                height: 120.0,
//                                width: 130.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: data != null &&
                                      data != "''"
//                                ?Text(data['photoAttachment']):Text('null')
                                      ? Image.network(
                                    data, width: 280, height: 300,)
                                      : Image.asset('assets/profile.png'),
                                )),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 100.0,
                                  height: 30.0,
                                  color: Theme
                                      .of(context)
                                      .buttonColor,
                                  child: Center(
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                onTap: () async {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))
            // _filterOptions(context),
          );
        });
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




