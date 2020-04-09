
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/employeeDashboard.dart';
import 'package:scoped_model/scoped_model.dart';


mixin EmployeeDashboardScopedModel on Model{
  List<EmployeeDashboard> _attendances = [];
  bool _isLoading = false;


  List<EmployeeDashboard> get allAttendances{
    return List.from(_attendances);
  }

  Future<Null> fetchCurrentDateAttendanceList() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeDashboard> attendanceList = [];
    final Map<String, dynamic> data = await ApiService.getCurrentDatePersonalAttendanceList1();
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<data['data'].length;i++){
      final EmployeeDashboard attendanceData  = EmployeeDashboard(
        flag: data['data'][i]['flag'].toString(),
        time: data['data'][i]['time'],
//        reason: data['data'][i]['request_reason'],
        reason: data['data'][i]['request_reason'] != null?data['data'][i]['request_reason']['value']:null,
      );
      attendanceList.add(attendanceData);
    }
    _attendances = attendanceList;
    _isLoading = false;
    notifyListeners();
    return;
  }

}

