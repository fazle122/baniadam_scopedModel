import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/common_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class OnTimeEmployeesListPage extends StatefulWidget {
  final MainModel model;
  OnTimeEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _OnTimeEmployeesListPageState();
  }
}

class _OnTimeEmployeesListPageState extends BaseState<OnTimeEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchOnTimeEmployees();
    widget.model.fetchCompanyId();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Employee Found!'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = ListWidget(model,widget.model.companyId.companyID);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: model.fetchOnTimeEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On-time today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
