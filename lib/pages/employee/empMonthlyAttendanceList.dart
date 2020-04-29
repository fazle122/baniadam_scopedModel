import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class MonthlyAttendanceLIstPage extends StatefulWidget {
  final MainModel model;
  MonthlyAttendanceLIstPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MonthlyAttendanceLIstPageState();
  }
}

class _MonthlyAttendanceLIstPageState extends BaseState<MonthlyAttendanceLIstPage> {

  @override
  initState() {
    widget.model.fetchMonthlyAttendanceList();
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No attendance data'));
        if (model.monthlyAttendaceData.length > 0 && !model.isLoading) {
          content = MonthlyAttendanceListWidget(model);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchMonthlyAttendanceList, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My monthly attendance list'),),
      body: _buildAttendanceList(),
    );
  }
}
