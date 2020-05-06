import 'package:baniadam/base_state.dart';
import 'package:baniadam/widgets/approver/leave_requests_list_Widget.dart';
import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
import 'package:baniadam/widgets/approver/leave_request_filter_dialog.dart';
import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';

import 'package:baniadam/models/adminDashboard.dart';

class LeaveRequestsListPage extends StatefulWidget {
  final MainModel model;

  LeaveRequestsListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LeaveRequestsListPageState();
  }
}

class _LeaveRequestsListPageState extends BaseState<LeaveRequestsListPage> {
  ScrollController _scrollController = new ScrollController();
  Map<String, dynamic> filters = Map();
  int currentPage = 1;
  bool isLoading = false;
  int lastItemId = 0;

  @override
  initState() {
    filters['status'] = ['Pending', 'Requested for Cancellation'];
//    widget.model.fetchLeaveRequestsListForAdmin(filters: filters,currentPage: currentPage);
    this._getMoreData(filters,currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          currentPage += 1;
        });
        _getMoreData(filters,currentPage);
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        setState(() {
          currentPage -= 1;
        });
        _getMoreData(filters,currentPage);
      }
    });
    super.initState();
  }

  void _getMoreData(Map<String, dynamic> filter,int currentPage) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      List<LeaveRequest> tempList = [];
      tempList = await widget.model.fetchLeaveRequestsListForAdminForPagination(
          filters: filter, currentPage: currentPage);

      if (tempList == null || tempList.isEmpty) {
        if (model.allLeaveRequests.isNotEmpty) animateScrollBump();
      } else {
        setState(() {
          isLoading = false;
          model.allLeaveRequests.addAll(tempList);
        });
      }
    }
  }

  Widget _buildEmployeeList(List<LeaveRequest> data) {
    Widget itemCards;
    if (data.length > 0) {
      itemCards = ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == data.length) {
            return _buildProgressIndicator();
          } else {
            return LeaveRequestItemCard(data[index], filters, model);
          }
        },
        controller: _scrollController,
      );
    } else {
      itemCards = Container();
    }
    return itemCards;
  }

  Widget _buildAttendanceList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No leave request data'));
        if (model.allLeaveRequests.length > 0 && !model.isLoading) {
          content = _buildEmployeeList(model.allLeaveRequests);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return content;
//        return RefreshIndicator(
//          onRefresh: model.fetchLeaveRequestsListForRefresh,
//          child: content,
//        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Leave request list'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                List<LeaveRequest> refreshList = await widget.model
                    .fetchLeaveRequestsListForAdminForPagination(
                        filters: filters, currentPage: 1);
                setState(() {
                  model.allLeaveRequests.clear();
                  model.allLeaveRequests.addAll(refreshList);
                });
              },
            ),
            PopupMenuButton<String>(
              onSelected: (val) async {
                switch (val) {
                  case 'FILTER':
                    var newFilters = await _leaveFilterDialog(context, model);
                    if (newFilters != filters) {
                      setState(() {
                        filters = newFilters;
                        currentPage = 1;
                        isLoading = true;
                      });
                        List<LeaveRequest> tempList = [];
                        tempList = await widget.model.fetchLeaveRequestsListForAdminForPagination(filters: filters, currentPage: currentPage);
                        if (tempList == null || tempList.isEmpty) {
                          if (model.allLeaveRequests.isNotEmpty) animateScrollBump();
                        } else {
                          setState(() {
                            isLoading = false;
                            model.allLeaveRequests.addAll(tempList);
                          });
                        }
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
        body: _buildAttendanceList(),
      );
    });
  }

  Future<Map<String, dynamic>> _leaveFilterDialog(
      BuildContext context, MainModel model) async {
    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => LeaveRequestFilterDialog(model),
    );
  }

  void animateScrollBump() {
    double edge = 50.0;
    double offsetFromBottom = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (offsetFromBottom < edge) {
      _scrollController.animateTo(
          _scrollController.offset - (edge - offsetFromBottom),
          duration: new Duration(milliseconds: 500),
          curve: Curves.easeOut);
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}









//import 'package:baniadam/base_state.dart';
//import 'package:baniadam/widgets/approver/leave_requests_list_Widget.dart';
//import 'package:baniadam/widgets/employee/attendance_list_Widget.dart';
//import 'package:baniadam/widgets/approver/leave_request_filter_dialog.dart';
//import 'package:baniadam/widgets/employee/monthly_attendance_list_Widget.dart';
//import 'package:flutter/material.dart';
//
//import 'package:scoped_model/scoped_model.dart';
//
//import 'package:baniadam/scoped-models/main.dart';
//
//class LeaveRequestsListPage extends StatefulWidget {
//  final MainModel model;
//  LeaveRequestsListPage(this.model);
//
//  @override
//  State<StatefulWidget> createState() {
//    return _LeaveRequestsListPageState();
//  }
//}
//
//class _LeaveRequestsListPageState extends BaseState<LeaveRequestsListPage> {
//  Map<String, dynamic> filters = Map();
//  int currentPage = 1;
//
//
//  @override
//  initState() {
//    filters['status'] = ['Pending','Requested for Cancellation'];
//    widget.model.fetchLeaveRequestsListForAdmin(filters: filters,currentPage: currentPage);
//    super.initState();
//  }
//
//
//  Widget _buildAttendanceList() {
//    return ScopedModelDescendant<MainModel>(
//      builder: (BuildContext context, Widget child, MainModel model) {
//        Widget content = Center(child: Text('No leave request data'));
//        if (model.allLeaveRequests.length > 0 && !model.isLoading) {
//          content = LeaveRequestsListWidget(model,filters);
//        } else if (model.isLoading) {
//          content = Center(child: CircularProgressIndicator());
//        }
//        return RefreshIndicator(onRefresh: model.fetchLeaveRequestsListForRefresh, child: content,) ;
//      },
//    );
//  }
//
//  Future<Map<String, dynamic>> _leaveFilterDialog(BuildContext context,MainModel model) async {
//    return showDialog<Map<String, dynamic>>(
//      barrierDismissible: false,
//      context: context,
//      builder: (BuildContext context) => LeaveRequestFilterDialog(model),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModelDescendant<MainModel>(
//        builder: (BuildContext context, Widget child, MainModel model) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text('Leave request list'),
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
////                    widget.model.fetchLeaveRequestsList();
//                  },
//                ),
//                PopupMenuButton<String>(
//                  onSelected: (val) async {
//                    switch (val) {
//                      case 'FILTER':
//                        var newFilters = await _leaveFilterDialog(context, model);
////                        filters = await _leaveFilterDialog(context, model);
//                        if (newFilters != filters) {
//                          widget.model.fetchLeaveRequestsListForAdmin(filters:newFilters,currentPage: currentPage);
////                          setState(() {
////                            filters = newFilters;
////                            title = '';
////                          });
////                          if (filters['branchName'] != null &&
////                              filters['branchName'] != '') {
////                            setState(() {
////                              title = 'Branch : ' + filters['branchName'] + ',\n';
////                            });
////                          }
////                          if (filters['departmentName'] != null &&
////                              filters['departmentName'] != '') {
////                            setState(() {
////                              title += 'Department : ' +
////                                  filters['departmentName'] +
////                                  ',\n';
////                            });
////                          }
////                          if (filters['designationName'] != null &&
////                              filters['designationName'] != '') {
////                            setState(() {
////                              title += 'Designation : ' +
////                                  filters['designationName'] +
////                                  ',\n';
////                            });
////                          }
////                          if (filters['leaveTypeName'] != null &&
////                              filters['leaveTypeName'] != '') {
////                            setState(() {
////                              title += 'Leave type : ' +
////                                  filters['leaveTypeName'] +
////                                  ',\n';
////                            });
////                          }
////                          if (filters['status'] != null) {
////                            List allStatus = [];
////                            for(int i = 0;i <filters['status'].length; i++)
////                            {
////                              allStatus.add(filters['status'][i]);
////                            }
////                            setState(() {
////                              title += 'Status : ' + allStatus.toString();
////                            });
//////                        setState(() {
//////                          title += 'Status : ' + filters['status'];
//////                        });
////                          }
//                        }
//                        break;
//                    }
//                  },
//                  itemBuilder: (BuildContext context) =>
//                  <PopupMenuItem<String>>[
//                    PopupMenuItem<String>(
//                      value: 'FILTER',
//                      child: Text('Filter'),
//                    ),
//                  ],
//                ),
//              ],
//
//            ),
//            body: _buildAttendanceList(),
//          );
//        }
//    );
//  }
//
//}
