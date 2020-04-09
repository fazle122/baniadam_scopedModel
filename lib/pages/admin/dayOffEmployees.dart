import 'package:baniadam/widgets/approver/listWidget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class DayOffEmployeesListPage extends StatefulWidget {
  final MainModel model;
  DayOffEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DayOffEmployeesListPageState();
  }
}

class _DayOffEmployeesListPageState extends State<DayOffEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchDayOffEmployees();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Employee Found!'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = ListWidget();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchDayOffEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day-off today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
