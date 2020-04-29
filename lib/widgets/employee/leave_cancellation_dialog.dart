import 'package:baniadam/base_state.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:toast/toast.dart';

class LeaveCancellationDialog extends StatefulWidget {
  final int id;

  LeaveCancellationDialog({
    this.id,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaveCancellationDialogState();
  }
}

class _LeaveCancellationDialogState extends BaseState<LeaveCancellationDialog> {
  Map<String, dynamic> data;
  TextEditingController reasonController;
  List newLeaveList;
  String approvalType;
  int selectedDeclineValue;

  @override
  void initState() {
    newLeaveList = [];
    reasonController = TextEditingController();
    data = Map();
    super.initState();
  }

  Future<List> _applyLeaveCancel(Function applyForLeaveCancel,int id, String cancellationReason) async {

    applyForLeaveCancel(id, cancellationReason).then((Map<String,dynamic> response){
      if(response['status'] == 'Cancelled'){
        Toast.show('Leave' + response['msg'].toString().toLowerCase() + ' successfully' ,
            context, duration: Toast.LENGTH_LONG,
            gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
      }
      else{
        Toast.show('Something wrong, please try again.',
            context, duration: Toast.LENGTH_LONG,
            gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(10.0),
        title: Center(
            child: Text(
              'Confirmation Required',
              style: TextStyle(fontSize: 20.0),
            )),
        content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Are you sure, you want to perform this operation ?'),
                  Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Reason: '),
                          Container(
                            width: 180.0,
                            child: TextFormField(
                                keyboardType: TextInputType.multiline,
//                            maxLines: 2,
                                controller: reasonController,
                                decoration: InputDecoration(
                                  hintText: 'Cancellation reason',
//                              contentPadding:
//                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                )),
                          )
                        ],
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
                                    'NO',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColorDark),
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ScopedModelDescendant<MainModel>(
                          builder: (BuildContext context, Widget child,MainModel model){
                            return InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Theme.of(context).buttonColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade500),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                      'YES',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              onTap: () async {
                                List list;
                                if (reasonController.text != null) {
                                  list = await _applyLeaveCancel(
                                      model.applyForLeaveCancel,
                                      widget.id,
                                      reasonController.text);
                                } else {
                                  Toast.show('Please write a reason', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.CENTER);
                                }

                                Navigator.of(context).pop(list);
                              },
                            );
                          }
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              ),
            ))
      // _filterOptions(context),
    );
  }
}
