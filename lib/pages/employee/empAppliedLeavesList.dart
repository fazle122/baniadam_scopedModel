import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/employee/applied_leave_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';

class AppliedLeaveLIstPage extends StatefulWidget {
  final MainModel model;
  AppliedLeaveLIstPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AppliedLeaveLIstPageState();
  }
}

class _AppliedLeaveLIstPageState extends BaseState<AppliedLeaveLIstPage> {

  @override
  initState() {
    widget.model.fetchLeaveRequests();
    super.initState();
  }


  Widget _buildLeaveList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No pending leave request'));
        if (model.leaveRequests.length > 0 && !model.isLoading) {
          content = AppliedLeaveListWidget(widget.model);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchLeaveRequests, child: content,) ;
      },
    );
  }

  Future<bool> _onBackPressed() {
//    Navigator.pushNamed<String>(context, '/dashboard');
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: _onBackPressed,
          child:
          Scaffold(
      appBar: AppBar(title: Text('Leave requests'),),
      body: _buildLeaveList(),
    )
      );
  }
}
