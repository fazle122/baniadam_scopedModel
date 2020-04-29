import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/present_list_Widget.dart';
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

class _PresentEmployeesListPageState extends BaseState<PresentEmployeesListPage> {
  @override
  initState() {
    widget.model.fetchPresentEmployees();
    widget.model.fetchCompanyId();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Employee Found!'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = PresentListWidget(widget.model,widget.model.companyId.companyID);
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
