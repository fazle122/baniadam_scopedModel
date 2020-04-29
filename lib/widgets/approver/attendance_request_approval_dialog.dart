import 'package:baniadam/base_state.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:scoped_model/scoped_model.dart';

class AttendanceRequestApprovalDialog extends StatefulWidget {
  final MainModel model;
  final int id;
  final String type;
  final Map<String, dynamic> filters;

  AttendanceRequestApprovalDialog({
    this.model,
    this.id,
    this.type,
    this.filters,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttendanceRequestApprovalDialogState();
  }
}

class _AttendanceRequestApprovalDialogState extends BaseState<AttendanceRequestApprovalDialog> {
  Map<String, dynamic> data;
  TextEditingController commentController;
  TextEditingController declineReasonController;
  List newAttendanceRequestList;
  String approvalType;
  int selectedDeclineValue;
  bool isConfirmed = false;

  @override
  void initState() {
    newAttendanceRequestList = [];
    commentController = TextEditingController();
    declineReasonController = TextEditingController();
    data = Map();
    approvalType = widget.type;
    super.initState();
  }

  Future<List> _approveAttendanceRequest(Function approveAttendanceRequest,int id, String status, String note, String declinedReason) async {
    approveAttendanceRequest(id,status,note,declinedReason).then((Map<String, dynamic> response){
      if(response['msg'] != null){
        Toast.show(response['msg'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
      }else{
        Toast.show('Something wrong, please try again.', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
      }
    });

  }




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(15.0),
        title: Center(
            child: Text(
              'Confirmation Required',
              style: TextStyle(fontSize: 20.0),
            )),
        content: SingleChildScrollView(
          child: isConfirmed ? Container(height: 200.0,child: Center(child:CircularProgressIndicator(),)):Column(
            children: <Widget>[
              Text('Are you sure, you want to perform this operation ?'),
              SizedBox(
                height: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  approvalType == 'DECLINED'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Note: '),
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        width: 150.0,
                        child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a note',
//                              contentPadding:
//                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            )),
                      )
                    ],
                  ): SizedBox(
                    width: 0.0,
                    height: 0.0,
                  ),
                  approvalType == 'DECLINED'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Reason: '),
                      Container(
                        margin: EdgeInsets.only(left: 25.0),
                        width: 150.0,
                        child: TextFormField(
                            controller: declineReasonController,
                            decoration: InputDecoration(
                              hintText: 'Decline reason',
//                          contentPadding:
//                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            )),
                      )
                    ],
                  )
                      : SizedBox(
                    width: 0.0,
                    height: 0.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(

                        child: Container(
                          width: 100.0,
                          height: 35.0,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade500),
                              borderRadius:
                              BorderRadius.all(Radius.circular(3.0)),
                            ),
                          ),

                          child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark),
                              )),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context,Widget child,MainModel model){
                          return InkWell(
                            child: Container(
                              width: 100.0,
                              height: 30.0,
                              color: Theme.of(context).buttonColor,
                              child: Center(
                                  child: Text(
                                    'YES',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () async {
                              setState(() {
                                isConfirmed = true;
                              });
                              List list;
                              list = await _approveAttendanceRequest(
                                  model.approveAttendanceRequest,
                                  widget.id,
                                  approvalType,
                                  commentController.text,
                                  declineReasonController.text);
                            },
                          );
                        }
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      // _filterOptions(context),
    );
  }
}
