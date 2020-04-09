
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/widgets/approver/attendance_request_approval_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';



class AdminAttendanceRequestListWidget extends StatelessWidget {
  final MainModel model;
  final Map<String,dynamic> filters;

  AdminAttendanceRequestListWidget(this.model,this.filters);



  Widget _buildAttendanceRequestsList(List<AdminAttendanceRequestList> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AttendanceRequestItemCard(data[index],index,filters),
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
        return _buildAttendanceRequestsList(model.attendanceRequestForAdmin);
      },
    );
  }
}





class AttendanceRequestItemCard extends StatelessWidget {
  final AdminAttendanceRequestList requestData;
  final int index;
  final Map<String,dynamic> filters;

  AttendanceRequestItemCard(this.requestData, this.index,this.filters);

  String convert12(String s) {
    String finalTime;
    String str = s.substring(0,5);
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


  Future<List> _approveAttendanceRequest(BuildContext context, id, approveType) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => AttendanceRequestApprovalDialog(
        id: id,
        type: approveType,
        filters: filters,
      ),
    );
  }


  Widget _buildItemRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: InkWell(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width:MediaQuery.of(context).size.width * 3.5/5,
                          child: Text(
                            requestData.employeeName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
//                      width:MediaQuery.of(context).size.width * 2/5,
                          padding: EdgeInsets.all(5.0),
//                      padding: EdgeInsets.only(
//                          left: 15.0, right: 0.0, top: 5.0, bottom: 5.0),
                          decoration: ShapeDecoration(
                            shape: AppTheme.roundedBorderDecoration(),
                            color: Color(0xFF999999),
//                      color:Color(0xFF999999),
                          ),
                          child:Center(child:Text(
                            requestData.status,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
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
                            convert12(requestData.time)
                            + '  ' +
                            DateFormat('d-MMM-yy').format(DateTime.parse(requestData.date))
                          ,style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 1.2 / 5,
                                child: Text(
                                  'Applied on: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 2 / 5,
                                child: requestData.appliedOn != null
                                    ? Text(DateFormat.yMMMd().format(
                                    DateTime.parse(requestData.appliedOn)))
                                    : Text('No data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    requestData.status =="Requested for Cancellation"?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                child: Text(
                                  'Request type: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width * 3 / 5,
                              child:Text('Leave cancelation request',style: TextStyle(color: Colors.red),),
                            )
                          ],
                        ),
                      ],
                    ):SizedBox(width: 0.0,height: 0.0,),
                    SizedBox(
                      height: 10.0,
                    ),
                    requestData.status == "PENDING"
                        ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              color: Theme.of(context).buttonColor,
                              child: Center(
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              List data = await _approveAttendanceRequest(
                                  context, requestData.id, 'DECLINED');
//                              if (data != null) {
//                                newLeaveItems = [];
//                                setState(() {
//                                  newLeaveItems.addAll(data);
//                                });
//                              }
                            },
                          ),
                          SizedBox(width: 10.0),
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              color: Theme.of(context).buttonColor,
                              child: Center(
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              List data = await _approveAttendanceRequest(
                                  context, requestData.id, 'APPROVED');
//                              if (data != null) {
//                                newLeaveItems = [];
//                                setState(() {
//                                  newLeaveItems.addAll(data);
//                                });
//                              }
                            },
                          ),
                        ],
                      ),
                    )
                        : SizedBox(
                      width: 0.0,
                      height: 0.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          )),


//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Text('Time:' + requestData.time.toString()),
//          SizedBox( width: 8.0,),
//          Text('Flag:' + requestData.flag.toString()),
//          SizedBox( width: 8.0,),
//          Text(requestData.status),
////          SizedBox( width: 8.0,),
////          Text(leavesData.reason)
//        ],
//      ),
    );
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


