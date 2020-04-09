import 'package:baniadam/widgets/approver/listWidget.dart';
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

class _TrackableEmployeesListPageState extends State<TrackableEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchTrackableEmployees();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No trackable employee'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = ListWidget();
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
