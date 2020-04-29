import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/common_list_Widget.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:baniadam/scoped-models/main.dart';

class OnLeaveEmployeesListPage extends StatefulWidget {
  final MainModel model;
  OnLeaveEmployeesListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _OnLeaveEmployeesListPageState();
  }
}

class _OnLeaveEmployeesListPageState extends BaseState<OnLeaveEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchOnLeaveEmployees();
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
        return RefreshIndicator(onRefresh: model.fetchOnLeaveEmployees, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On-leave today'),
      ),
      body: _buildEmployeesList(),
    );
  }
}
