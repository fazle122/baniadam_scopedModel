import 'package:baniadam/widgets/approver/listWidget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class PresentEmployeesListPage extends StatefulWidget {
  final MainModel model;
  PresentEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PresentEmployeesListPageState();
  }
}

class _PresentEmployeesListPageState extends State<PresentEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchPresentEmployees();
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
        return RefreshIndicator(onRefresh: model.fetchPresentEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Present today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
