
import 'package:baniadam/models/adminDashboard.dart';
import 'package:baniadam/models/employeeOperations.dart';
import 'package:baniadam/pages/employee/empAttendanceDetailList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/widgets/approver/leave_approval_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';



class LeaveRequestsListWidget extends StatelessWidget {

  final MainModel model;
  final Map<String,dynamic> filters;

  LeaveRequestsListWidget(this.model,this.filters);

  Widget _buildEmployeeList(List<LeaveRequest> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            LeaveRequestItemCard(data[index],filters),
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
        return _buildEmployeeList(model.allLeaveRequests);
      },
    );
  }
}





class LeaveRequestItemCard extends StatelessWidget {
  final LeaveRequest requestData;
  final Map<String,dynamic> filters;


  LeaveRequestItemCard(this.requestData,this.filters);

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

  Future<List> _leaveApprovalDialog(BuildContext context, id, approveType) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => LeaveApprovalDialog(
        id: id,
        type: approveType,
        filters: filters,
      ),
    );
  }


  Widget _buildItemRow(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model){
          return Container(
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
                            child: Text(requestData.employeeName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
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
//                          margin: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'From: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                  child: requestData.fromDate !=
                                      null &&
                                      requestData.fromDate !=
                                          'n/a'
                                      ? Text(
                                    requestData.fromDate,
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
//                          margin: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'To: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                  child: requestData.toDate !=
                                      null &&
                                      requestData.toDate !=
                                          'n/a'
                                      ? Text(
                                      requestData.toDate
                                  )
                                      : Text('No data')),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width * .8/ 5,
                                  child: Text(
                                    'Reason: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width * 3/ 5,
//                          margin: EdgeInsets.only(top: 5.0),
                                  child: requestData.reason != null
                                      ? Text(requestData.reason)
                                      : Text('No data')),
                            ],
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
                                  child: requestData.appliedOn!= null
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
                      requestData.status == "Pending"
                          || requestData.status =="Requested for Cancellation"
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
                                List data = await _leaveApprovalDialog(
                                    context, requestData.id, 'DECLINED');
                                if (data != null) {
                                }
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
                                List data = await _leaveApprovalDialog(
                                    context, requestData.id, 'APPROVED');
                                if (data != null) {
                                }
                              },
                            ),
                          ],
                        ),
                      )
                          : SizedBox(
                        width: 0.0,
                        height: 0.0,
                      ),
                    ],
                  ),
                ),

                onTap: (){
                },
              )
          );
        }
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


