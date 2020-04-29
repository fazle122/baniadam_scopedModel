import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/employee/attendance_detail_list_widget.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';

class AttendanceDetailListPage extends StatefulWidget {
  final MainModel model;
  final String date;
  AttendanceDetailListPage(this.model,this.date);

  @override
  State<StatefulWidget> createState() {
    return _AttendanceDetailListPageState();
  }
}

class _AttendanceDetailListPageState extends BaseState<AttendanceDetailListPage> {
  @override
  initState() {
    widget.model.fetchAttendanceDetailList(DateFormat("yyyy.MM.dd").format(DateTime.parse(widget.date)));
    super.initState();
  }


  Widget _buildAttendanceList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No attendance data'));
        if (model.attendanceDetailData.length > 0 && !model.isLoading) {
          content = AttendanceDetailListWidget();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchAttendanceDetailListForRefresh, child: content,) ;
//      return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text(
      'Attendance on ' +
          DateFormat.yMMMEd().format(DateTime.parse(widget.date)),
      style: TextStyle(fontSize: 18.0),
    )),
      body: _buildAttendanceList()
    );
  }
}

