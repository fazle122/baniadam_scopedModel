import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/pages/admin/leaveRequestsList.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:baniadam/widgets/approver/leave_approval_dialog.dart';
import 'package:baniadam/widgets/approver/leave_request_detail_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class LeaveRequestDetailPage extends StatefulWidget {
  final int id;
  final MainModel model;

  LeaveRequestDetailPage(
    this.id,
    this.model);

  @override
  _LeaveRequestDetailPageState createState() => _LeaveRequestDetailPageState();
}

class _LeaveRequestDetailPageState extends BaseState<LeaveRequestDetailPage> {
  @override
  void initState() {
    widget.model.fetchLeaveRequestDetail(widget.id);
    super.initState();
  }

  Widget _buildLeaveDetailWidget() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No data Found!'));
        if (model.leaveRequestDetail != null && !model.isLoading) {
          content =
              LeaveRequestDetailItemWidget(model.leaveRequestDetail, model);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return content;
//        return RefreshIndicator(onRefresh:(){
//          widget.model.fetchLeaveRequestDetail(widget.id);
//        }, child: content,);
      },
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/leaveRequests');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leave detail'),
        ),
        body: WillPopScope(
            child: _buildLeaveDetailWidget(), onWillPop: _onBackPressed));
  }
}
