import 'package:baniadam/widgets/approver/leave_requests_list_Widget.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:baniadam/widgets/approver/leave_request_filter_dialog.dart';
import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class LeaveRequestsListPage extends StatefulWidget {
  final MainModel model;
  LeaveRequestsListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LeaveRequestsListPageState();
  }
}

class _LeaveRequestsListPageState extends State<LeaveRequestsListPage> {
  Map<String, dynamic> filters = Map();

  @override
  initState() {
    filters['status'] = ['Pending','Requested for Cancellation'];
    widget.model.fetchLeaveRequestsList(filters);
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No leave request data'));
        if (model.allLeaveRequests.length > 0 && !model.isLoading) {
          content = LeaveRequestsListWidget(model,filters);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchLeaveRequestsListForRefresh, child: content,) ;
      },
    );
  }

  Future<Map<String, dynamic>> _leaveFilterDialog(BuildContext context,MainModel model) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LeaveRequestFilterDialog(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Leave request list'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
//                    widget.model.fetchLeaveRequestsList();
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (val) async {
                    switch (val) {
                      case 'FILTER':
//                        var newFilters = await _leaveFilterDialog(context, model);
                        filters = await _leaveFilterDialog(context, model);
//                        if (newFilters != filters) {
//                          setState(() {
//                            filters = newFilters;
//                            title = '';
//                          });
//                          if (filters['branchName'] != null &&
//                              filters['branchName'] != '') {
//                            setState(() {
//                              title = 'Branch : ' + filters['branchName'] + ',\n';
//                            });
//                          }
//                          if (filters['departmentName'] != null &&
//                              filters['departmentName'] != '') {
//                            setState(() {
//                              title += 'Department : ' +
//                                  filters['departmentName'] +
//                                  ',\n';
//                            });
//                          }
//                          if (filters['designationName'] != null &&
//                              filters['designationName'] != '') {
//                            setState(() {
//                              title += 'Designation : ' +
//                                  filters['designationName'] +
//                                  ',\n';
//                            });
//                          }
//                          if (filters['leaveTypeName'] != null &&
//                              filters['leaveTypeName'] != '') {
//                            setState(() {
//                              title += 'Leave type : ' +
//                                  filters['leaveTypeName'] +
//                                  ',\n';
//                            });
//                          }
//                          if (filters['status'] != null) {
//                            List allStatus = [];
//                            for(int i = 0;i <filters['status'].length; i++)
//                            {
//                              allStatus.add(filters['status'][i]);
//                            }
//                            setState(() {
//                              title += 'Status : ' + allStatus.toString();
//                            });
////                        setState(() {
////                          title += 'Status : ' + filters['status'];
////                        });
//                          }
//                        }
                        widget.model.fetchLeaveRequestsList(filters);
//                        widget.model.fetchLeaveRequestsList(newFilters);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      value: 'FILTER',
                      child: Text('Filter'),
                    ),
                  ],
                ),
              ],

            ),
            body: _buildAttendanceList(),
          );
        }
    );
  }

}
