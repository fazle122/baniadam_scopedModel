import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/common_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class CurrentShiftEmployeesListPage extends StatefulWidget {
  final MainModel model;
  CurrentShiftEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CurrentShiftEmployeesListPageState();
  }
}

class _CurrentShiftEmployeesListPageState extends BaseState<CurrentShiftEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchCurrentShiftEmployees();
    widget.model.fetchCompanyId();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No employee found!'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = ListWidget(model,widget.model.companyId.companyID);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchCurrentShiftEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current shift employees'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
