import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class CurrentDateAttendanceWidget extends StatefulWidget {
  final MainModel model;
  CurrentDateAttendanceWidget(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CurrentDateAttendanceWidgetState();
  }
}

class _CurrentDateAttendanceWidgetState extends State<CurrentDateAttendanceWidget> {
  @override
  initState() {
    widget.model.fetchCurrentDateAttendanceList();
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No attendance data'));
        if (model.allAttendances.length > 0 && !model.isLoading) {
          content = AttendanceListWidget();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchCurrentDateAttendanceList, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAttendanceList();
  }
}
