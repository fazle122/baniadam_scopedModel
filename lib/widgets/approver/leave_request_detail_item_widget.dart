import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/widgets/approver/leave_approval_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';


class LeaveRequestDetailItemWidget extends StatelessWidget {

  final LeaveRequestsDetailForAdmin _leaveDetailData;
  final MainModel model;

  LeaveRequestDetailItemWidget(this._leaveDetailData,this.model);

  Future<List> _leaveApprovalDialog(BuildContext context, id, approveType) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => LeaveApprovalDialog(
        model: model,
        id: id,
        type: approveType,
//        filters: filters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top:10.0),
            height: MediaQuery.of(context).size.height * .8/10,
            width: MediaQuery.of(context).size.width * 4.5/5,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).backgroundColor,
              child: Center(
                child: Text('Request detail',style: Theme.of(context).textTheme.title,),
              ),)
        ),
        SizedBox(height: 10.0,),
        Text('Request',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
        SizedBox(height: 5.0,),
        _listItem(context,'Leave type', _leaveDetailData.leaveType),
        SizedBox(height: 5.0,),
        _listItem(context,'From', _leaveDetailData.from),
        SizedBox(height: 5.0,),
        _listItem(context,'To', _leaveDetailData.to),
        SizedBox(height: 5.0,),
        _listItem(context,'Applied for', _leaveDetailData.totalDays),
        SizedBox(height: 5.0,),
        _listItem(context,'Applied on', DateFormat.yMMMd().format(
            DateTime.parse(_leaveDetailData.appliedOn))),
        SizedBox(height: 5.0,),
        _listItem2(context,'Leave reason', _leaveDetailData.reason),


        SizedBox(height: 10.0,),
        Center(child:Text('Employee',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),),
        SizedBox(height: 5.0,),
        _listItem(context, 'Name', _leaveDetailData.employeeName),
//          SizedBox(height: 5.0,),
//          _listItem(context,'ID', personalLeaveDetail['id'].toString()),
        SizedBox(height: 5.0,),
        _listItem(context,'Branch', _leaveDetailData.brunch),
        SizedBox(height: 5.0,),
        _listItem(context,'Department', _leaveDetailData.department),
        SizedBox(height: 5.0,),
        _listItem(context,'Designation', _leaveDetailData.designation),

        SizedBox(height: 20.0,),

        _leaveDetailData.status == "Pending" || _leaveDetailData.status == "Requested for Cancellation"
            ? Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  width: 100.0,
                  height: 30.0,
                  color: Theme.of(context).buttonColor,
                  child: Center(
                      child: Text(
                        'DECLINE',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                onTap: () async{
                  List data = await _leaveApprovalDialog(context, _leaveDetailData.id, 'DECLINED');
                  model.fetchDashboardData();
                  model.fetchLeaveRequestDetail(_leaveDetailData.id);
                  model.fetchLeaveRequestsListForAdmin();
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
                        'APPROVE',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                onTap: () async{
                  List data = await _leaveApprovalDialog(context, _leaveDetailData.id, 'APPROVED');
                  model.fetchDashboardData();
                  model.fetchLeaveRequestDetail(_leaveDetailData.id);
                  model.fetchLeaveRequestsListForAdmin();
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

    ));
  }



  _listItem(BuildContext context,String title,String value){
    return  Container(
        decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
//          padding: const EdgeInsets.only(top:10.0),
        height: 25.0,
        width: MediaQuery.of(context).size.width * 4.7/5,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 1.5/5,
                color: Theme.of(context).backgroundColor,
                child: Center(child:Text(title,style: TextStyle(fontSize: 12.0),)),
              ),
              SizedBox(width: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width * 2.5/5,
                child: Text(value,style: TextStyle(fontSize: 12.0),),
              ),
            ],
          ),
        )
    );
  }

  _listItem2(BuildContext context,String title,String value){
    return  Container(
        decoration: BoxDecoration(border: Border.all(color:Color(0xFFD8EAFB)),borderRadius: BorderRadius.circular(10.0)),
        height: 40.0,
        width: MediaQuery.of(context).size.width * 4.7/5,
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 1.5/5,
                color: Theme.of(context).backgroundColor,
                child: Center(child:Text(title,style: TextStyle(fontSize: 12.0),)),
              ),
              SizedBox(width: 20.0,),
              Container(
                width: MediaQuery.of(context).size.width * 2.5/5,
                child: Text(value,style: TextStyle(fontSize: 12.0),),
              ),
            ],
          ),
        )
    );
  }
}
