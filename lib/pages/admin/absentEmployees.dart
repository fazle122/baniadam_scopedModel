import 'package:baniadam/widgets/approver/listWidget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class AbsentEmployeesListPage extends StatefulWidget {
  final MainModel model;
  AbsentEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AbsentEmployeesListPageState();
  }
}

class _AbsentEmployeesListPageState extends State<AbsentEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchAbsentEmployees();
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
        return RefreshIndicator(onRefresh: model.fetchAbsentEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absent today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
