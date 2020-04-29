import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/common_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class TrackableEmployeesListPage extends StatefulWidget {
  final MainModel model;
  TrackableEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TrackableEmployeesListPageState();
  }
}

class _TrackableEmployeesListPageState extends BaseState<TrackableEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchTrackableEmployees();
    widget.model.fetchCompanyId();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No trackable employee'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = ListWidget(model,widget.model.companyId.companyID);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchTrackableEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackable Employee today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
