
import 'package:baniadam/models/employeeOperations.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/style/app_theme.dart';
import 'package:baniadam/widgets/employee/leave_cancellation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';




class AppliedLeaveListWidget extends StatelessWidget {

  final MainModel model;
  AppliedLeaveListWidget(this.model);

  Widget _buildLeaveRequestsList(List<AppliedLeaves> data){
    Widget itemCards;
    if(data.length >0){
      itemCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AppliedLeaveItemCard(data[index],index,model),
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
        return _buildLeaveRequestsList(model.leaveRequests);
      },
    );
  }
}



class AppliedLeaveItemCard extends StatelessWidget {
  final AppliedLeaves leavesData;
  final int index;
  final MainModel model;

  AppliedLeaveItemCard(this.leavesData, this.index,this.model);

  Future<List> _cancelLeave(BuildContext context, id) async {
    return await showDialog<List>(
      context: context,
      builder: (BuildContext context) => LeaveCancellationDialog(id: id,),
    );
  }

  Widget _buildItemRow(BuildContext context) {
    return Card(
      color: (index % 2 == 0) ? Colors.white : Color(0xFFE7F2FB),

      child: InkWell(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 5.0,
                child: Container(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              ListTile(
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
//                        margin: EdgeInsets.only(top: 5.0),
                          child: Text(

                            leavesData.leaveType,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
//                        height: 30.0,
                          width: 140.0,
                          margin: EdgeInsets.only(top: 5.0),
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                          decoration: ShapeDecoration(
                              shape: AppTheme.roundedBorderDecoration(),
                              color: leavesData.status == "Pending"
                                  ? Color(0xFF5BC0DE)
                                  : leavesData.status == "Approved"
                                  ? Color(0xFF5CB85C)
                                  : Color(0xFFD9534F)
//                      color:Color(0xFF999999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Flexible(
                                  child: Center(
                                    child: Text(
                                      leavesData.status,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
//                          margin: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  'From: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child: leavesData.fromDate != null
                                    ? Text(DateFormat.yMMMd()
                                    .format(DateTime.parse(leavesData.fromDate)))
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child: leavesData.toDate != null
                                    ? Text(DateFormat.yMMMd()
                                    .format(DateTime.parse(leavesData.toDate)))
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Reason: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 3.5/5,
//                          margin: EdgeInsets.only(top: 5.0),
                                child: leavesData.reason != null
                                    ? Text(leavesData.reason)
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
//                          margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Applied on : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 3/5,
//                          margin: EdgeInsets.only(top: 5.0),
                                child: leavesData.appliedOn != null
                                    ? Text(DateFormat.yMMMd()
                                    .format(DateTime.parse(leavesData.appliedOn)))
                                    : Text('No data')),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    leavesData.status == "Pending" || leavesData.status == "Approved"
                        ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 100.0,
                              height: 35.0,
                              decoration: ShapeDecoration(
                                color: Theme.of(context).buttonColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                    'Cancel leave',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              List data =
                              await _cancelLeave(context, leavesData.id);
                              model.fetchLeaveRequests();
                            },
                          ),
                          SizedBox(width: 10.0),
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
  }
}


