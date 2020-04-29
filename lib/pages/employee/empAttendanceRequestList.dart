import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:baniadam/widgets/employee/attendance_request_list_widget.dart';
import 'package:baniadam/widgets/employee/emp_attendance_requests_filter_dialog.dart';
import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class EmpAttendanceRequestListPage extends StatefulWidget {
  final MainModel model;
  EmpAttendanceRequestListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _EmpAttendanceRequestListPageState();
  }
}

class _EmpAttendanceRequestListPageState extends BaseState<EmpAttendanceRequestListPage> {
  Map<String,dynamic> _filters = Map();

  @override
  initState() {
    widget.model.fetchAttendanceRequests(_filters);
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No attendance request'));
        if (model.attendanceRequests.length > 0 && !model.isLoading) {
          content = AttendanceRequestListWidget();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchAttendanceRequestsForEmployeeForRefresh, child: content,) ;
      },
    );
  }

  Future<Map<String, dynamic>> _attendanceFilterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => EmployeeAttendanceRequestFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My attendance requests'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              widget.model.fetchAttendanceRequests(_filters);
            },
          ),


          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case 'FILTER':
                  _filters = await _attendanceFilterDialog(context);
//                  if (newFilters != filters) {
//                    setState(() {
//                      filters = newFilters;
//                    });
//                    if (filters['status'] != null) {
//                      List allStatus = [];
//                      for(int i = 0;i <filters['status'].length; i++)
//                      {
//                        allStatus.add(filters['status'][i]);
//                      }
//                    }
//                  }
                  widget.model.fetchAttendanceRequests(_filters);
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
