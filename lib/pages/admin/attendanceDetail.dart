
import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/pages/admin/locationOnMap.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/widgets/approver/admin_attendance_detail_list_Widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';



class AttendanceDetailListPageForAdmin extends StatefulWidget {
  final MainModel model;
  final String empId;
  final String date;

  AttendanceDetailListPageForAdmin(this.model,this.empId,this.date);

  @override
  State<StatefulWidget> createState() {
    return _AttendanceDetailLisForAdminPageState();
  }
}

class _AttendanceDetailLisForAdminPageState extends BaseState<AttendanceDetailListPageForAdmin> {
  @override
  initState() {
    widget.model.fetchAttendanceDetailListForAdmin(widget.empId,widget.date);
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No data Found!'));
        if (model.allAttendanceDetailForAdmin.length > 0 && !model.isLoading) {
          content = AdminAttendanceDetailListWidget();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh:(){
          widget.model.fetchAttendanceDetailListForAdmin(widget.empId,widget.date);
        }, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance detail'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
