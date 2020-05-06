import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/track_employees_filter_dialog.dart';
import 'package:baniadam/widgets/approver/trackable_employee_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Map<String, dynamic> filters = Map();
  DateTime selectedDate;
  final format = DateFormat('yyyy-MM-dd');

  @override
  initState() {
    selectedDate = DateTime.now();
    filters['date'] = DateFormat('yyyy-MM-dd').format(selectedDate);
    widget.model.fetchTrackableEmployees(filters);
    widget.model.fetchCompanyId();
    super.initState();
  }


  Widget _buildEmployeesList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No trackable employee'));
        if (model.allEmployees.length > 0 && !model.isLoading) {
          content = TrackableEmployeeListWidget(model,widget.model.companyId.companyID,selectedDate);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(onRefresh: (){
          model.fetchTrackableEmployees(filters);
        }, child: content,) ;
      },
    );
  }

  Future<Map<String, dynamic>> _trackedEmployeeFlterDialog(BuildContext context) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => TrackEmployeesFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackable Employee'),
        actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    _getListItems();
//                  },
//                ),
          PopupMenuButton<String>(
            onSelected: (val) async {
              switch (val) {
                case 'FILTER':
                  debugPrint('filter');
                  var newFilters = await _trackedEmployeeFlterDialog(context);
                  if (newFilters != filters) {
                    setState(() {
                      filters = newFilters;
//                      selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(filters['date']));
                      selectedDate = DateTime.parse(filters['date']);
//                            title = '';
                    });
                    widget.model.fetchTrackableEmployees(filters);

//                    if (filters['status'] != null) {
//                      List allStatus = [];
//                      for(int i = 0;i <filters['status'].length; i++)
//                      {
//                        allStatus.add(filters['status'][i]);
//                      }
////                            setState(() {
////                              title += 'Status : ' + allStatus.toString();
////                            });
//                    }
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'FILTER',
                child: Text('Filter'),
              ),
            ],
          ),
        ],
      ),
      body: _buildEmployeesList(),
    );
  }
}
