import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/admin_attendance_requests_filter_dialog.dart';
import 'package:baniadam/widgets/approver/attendance_requests_for_admin_list_widget.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:baniadam/widgets/employee/attendance_request_list_widget.dart';
import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class AdminAttendanceRequestListPage extends StatefulWidget {
  final MainModel model;
  AdminAttendanceRequestListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AdminAttendanceRequestListPageState();
  }
}

class _AdminAttendanceRequestListPageState extends BaseState<AdminAttendanceRequestListPage> {

  Map<String,dynamic> _filters = Map();

  @override
  initState() {
    _filters['status'] = ['Pending'];
    widget.model.fetchAttendanceRequestsForAdmin(_filters);
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No attendance request'));
        if (model.attendanceRequestForAdmin.length > 0 && !model.isLoading) {
          content = AdminAttendanceRequestListWidget(model,_filters);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchAttendanceRequestsForAdminForRefresh, child: content,) ;
      },
    );
  }

  Future<Map<String, dynamic>> _attendanceRequestFilterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AdminAttendanceRequestFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance requests'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              widget.model.fetchAttendanceRequestsForAdmin(_filters);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case 'FILTER':
                  debugPrint('filter');
                  _filters = await _attendanceRequestFilterDialog(context);
//                  if (newFilters != filters) {
//                    setState(() {
//                      filters = newFilters;
//                      title = '';
//                    });
//                    if (filters['status'] != null) {
//                      List allStatus = [];
//                      for(int i = 0;i <filters['status'].length; i++)
//                      {
//                        allStatus.add(filters['status'][i]);
//                      }
//                      setState(() {
//                        title += 'Status : ' + allStatus.toString();
//                      });
//                    }
//                  }
                  widget.model.fetchAttendanceRequestsForAdmin(_filters);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
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
}
