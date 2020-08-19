import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/employeeDashboard.dart';
import 'package:baniadam/models/employeeOperations.dart';
import 'package:dio/dio.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';




mixin EmployeeOperationsScopedModel on Model {
  bool _isLoading = false;
  CompanyInfo _companyInfo;
  EmployeeInfo _empInformation;
  Map<int, dynamic> _reasons = Map();
  Map<int, dynamic> _leaveTypes = Map();
  Map<int, dynamic> _leaveBalance = Map();
  List<MonthlyAttendance> _monthlyAttendance = [];
  List<AppliedLeaves> _leaveRequests = [];
  List<AttendanceRequests> _attendanceRequests = [];
  List<AttendanceDetail> _attendanceDetail = [];
  Map<String, dynamic> filter = Map();
  Map<int, dynamic> _branches = Map();
  Map<int, dynamic> _departments = Map();
  Map<int, dynamic> _designations = Map();
  Map<int, dynamic> _allLeaveTypes = Map();


  CompanyInfo get allCompanyInformation {
    return _companyInfo;
  }

  EmployeeInfo get employeeInformation {
    return _empInformation;
  }

  Map<int, dynamic> get attendanceRequestReasons {
    return _reasons;
  }

  Map<int, dynamic> get leaveTypesForLeaveApply {
    return _leaveTypes;
  }

  List<MonthlyAttendance> get monthlyAttendaceData {
    return List.from(_monthlyAttendance);
  }

  List<AppliedLeaves> get leaveRequests {
    return List.from(_leaveRequests);
  }

  List<AttendanceRequests> get attendanceRequests {
    return List.from(_attendanceRequests);
  }

  List<AttendanceDetail> get attendanceDetailData {
    return List.from(_attendanceDetail);
  }

  Map<int, dynamic> get allBranches {
    return _branches;
  }

  Map<int, dynamic> get allDepartments {
    return _departments;
  }

  Map<int, dynamic> get allDesignations {
    return _designations;
  }

  Map<int, dynamic> get allLeaveTypes {
    return _allLeaveTypes;
  }

  Future<Null> fetchCompanyInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> data = await ApiService.getLogo(cid);
    if (data == null) {
      _companyInfo = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    final CompanyInfo companyInfo = CompanyInfo(
      companyLogoUrl: ApiService.CDN_URl + "$cid" + data['value'],
    );

    _companyInfo = companyInfo;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Map<String, dynamic>> createAttendance(FormData attendanceData) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> successInformation =
        await ApiService.attendanceRequest(attendanceData);
    if (successInformation['id'] != null) {
//      ApiService.updateAttendanceRequest(successInformation['id'], selfieData);
      _isLoading = false;
      notifyListeners();
      return successInformation;
    } else {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Null> updateSelfie(int id, FormData selfieData) async {
    ApiService.updateAttendanceRequest(id, selfieData);
  }

  Future<Map<String, dynamic>> createAttendanceRequest(
      FormData attendanceRequestData, int flag) async {
    Map<String, dynamic> successInformation;
    _isLoading = true;
    notifyListeners();
    if (flag == 0) {
      successInformation =
          await ApiService.manualAttendanceRequestIn(attendanceRequestData);
    } else {
      successInformation =
          await ApiService.manualAttendanceRequestOut(attendanceRequestData);
    }
    if (successInformation['id'] != null) {
      _isLoading = false;
      notifyListeners();
      return null;
    } else {
      _isLoading = false;
      notifyListeners();
      return successInformation;
    }
  }

  Future<Null> fetchEmployeeInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> empInfo = await ApiService.getEmployeeDetail();
    if (empInfo == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final EmployeeInfo userData = EmployeeInfo(
        id: empInfo['data']['id'],
        employeeId: empInfo['data']['employeeId'],
        empName: empInfo['data']['fullName'],
        empDesignation: empInfo['data']['designation']['value'],
//      photoUrl: empInfo['data']['photoAttachment'],
        photoUrl:
            ApiService.CDN_URl + "$cid/" + empInfo['data']['photoAttachment']);
    _empInformation = userData;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAttendanceRequestReasons() async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    final List<dynamic> reasonsData =
        await ApiService.getAttendanceRequestReasons();
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      data[reasonsData[i]['id']] = reasonsData[i]['value'];
    }
    _reasons = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchBranches() async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    List<dynamic> reasonsData = await ApiService.getBranchTypes();
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      data[reasonsData[i]['id']] = reasonsData[i]['value'];
    }
    _branches = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchDepartments() async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    List<dynamic> reasonsData = await ApiService.getDepartments();
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      data[reasonsData[i]['id']] = reasonsData[i]['value'];
    }
    _departments = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchDesignations() async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    List<dynamic> reasonsData = await ApiService.getDesignations();
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      data[reasonsData[i]['id']] = reasonsData[i]['value'];
    }
    _designations = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAllLeaveTypes() async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    List<dynamic> reasonsData = await ApiService.getAllLeaveTypes();
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      data[reasonsData[i]['id']] = reasonsData[i]['value'];
    }
    _allLeaveTypes = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchLeaveBalance(DateTime from, DateTime to) async {
    _isLoading = true;
    notifyListeners();
    Map<int, dynamic> data = Map();
    final Map<String, dynamic> reasonsData =
        await ApiService.getLeaveBalanceForLeaveApply(from, to);
    ;
    if (reasonsData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < reasonsData.length; i++) {
      Map<String, dynamic> tmp = Map();
      tmp['label'] = reasonsData['data'][i]['leave_type']['value'];
      tmp['balance'] = reasonsData['data'][i]['balance'];
      _leaveTypes[reasonsData['data'][i]['leave_type']['id']] = tmp;
    }
//    _leaveTypes = data;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchMonthlyAttendanceList() async {
    _isLoading = true;
    notifyListeners();
    await fetchEmployeeInformation();
    final List<MonthlyAttendance> attendanceList = [];
    final Map<String, dynamic> data =
        await ApiService.getMonthlyAttendanceData(_empInformation.id, filter);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    var listItem = data['data']['attendances'][0];

    List<dynamic> leaveListItem = [];
    Map<String, dynamic> lType = Map();
    Map<String, dynamic> tmp;
    Map<String, dynamic> leaveItem = Map();
    leaveListItem.addAll(listItem['offdays']);

    for (int j = 0; j < leaveListItem.length; j++) {
      tmp = Map();
      tmp['type'] = leaveListItem[j]['type'];
      tmp['status'] = leaveListItem[j]['status'];
      lType[leaveListItem[j]['date']] = tmp;
    }

    for (int i = 0; i < listItem.length; i++) {
      if (lType.containsKey(listItem['data'][i]['dates'])) {
        leaveItem[listItem['data'][i]['dates']] =
            lType[leaveListItem[i]['date']];
      } else {
        leaveItem[listItem['data'][i]['dates']] = null;
      }
    }

    for (int i = 0; i < listItem['data'].length; i++) {
      final MonthlyAttendance attendanceData = MonthlyAttendance(
        status: listItem['data'][i]['status'] != null
            ? listItem['data'][i]['status']
            : null,
        inTime: listItem['data'][i]['in_time'] != null
            ? listItem['data'][i]['in_time']
            : null,
        outTime: listItem['data'][i]['out_time'] != null
            ? listItem['data'][i]['out_time']
            : null,
        dates: listItem['data'][i]['dates'] != null
            ? listItem['data'][i]['dates']
            : null,
        offDayType: leaveItem.containsKey(listItem['data'][i]['dates']) && leaveItem[listItem['data'][i]['dates']] != null ? leaveItem[listItem['data'][i]['dates']]['type']:null,
        offDayStatus: leaveItem.containsKey(listItem['data'][i]['dates']) && leaveItem[listItem['data'][i]['dates']] != null ?leaveItem[listItem['data'][i]['dates']]['status']:null,
//////        offDayDate: test[i]['date'],
//        offDayType: leaveItem[listItem['data'][i]['dates']] != null
//            ? leaveItem[listItem['data'][i]['dates']]['type']
//            : null,
//        offDayStatus: leaveItem[listItem['data'][i]['dates']] != null
//            ? leaveItem[listItem['data'][i]['dates']]['status']
//            : null,
      );
      attendanceList.add(attendanceData);
    }
    _monthlyAttendance = attendanceList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAttendanceDetailListForRefresh() async {
    await fetchAttendanceDetailList;
  }

  Future<Null> fetchAttendanceDetailList(String date) async {
    _isLoading = true;
    notifyListeners();
    await fetchEmployeeInformation;
    final List<AttendanceDetail> attendanceDetailList = [];
    final List<dynamic> data =
        await ApiService.getDateWisePersonalAttendanceList(
            _empInformation.id, date);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for (int i = 0; i < data.length; i++) {
      final AttendanceDetail attendanceData = AttendanceDetail(
        date: data[i]['date'],
        flag: data[i]['flag'],
        time: data[i]['time'],
      );
      attendanceDetailList.add(attendanceData);
    }
    _attendanceDetail = attendanceDetailList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchLeaveRequests() async {
    _isLoading = true;
    notifyListeners();
    final List<AppliedLeaves> leaveList = [];
    final List<dynamic> data = await ApiService.getPersonalLeavesList();
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < data.length; i++) {
      final AppliedLeaves leaveData = AppliedLeaves(
          id: data[i]['id'],
          leaveType: data[i]['leave_type']['value'],
          status: data[i]['status'],
          fromDate: data[i]['from'],
          toDate: data[i]['to'],
          reason: data[i]['reason'],
          appliedOn: data[i]['created_at']);
      leaveList.add(leaveData);
    }
    _leaveRequests = leaveList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAttendanceRequestsForEmployeeForRefresh() async {
    await fetchAttendanceRequests;
  }

  Future<Null> fetchAttendanceRequests(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    final List<AttendanceRequests> requestList = [];
    final List<dynamic> data =
        await ApiService.getAttendanceRequestListForEmployee(filters);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < data.length; i++) {
      final AttendanceRequests requestData = AttendanceRequests(
        status: data[i]['status'],
        flag: data[i]['flag'],
        time: data[i]['time'],
        date: data[i]['date'],
      );
      requestList.add(requestData);
    }
    _attendanceRequests = requestList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Map<String, dynamic>> applyForLeave(
      String leaveType,
      String fromDate,
      String toDate,
      String reason,
      String leaveMode,
      String leaveModeShift) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> response = await ApiService.leaveRequest(
        leaveType, fromDate, toDate, reason, leaveMode, leaveModeShift);

    if (response == null) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
    _isLoading = false;
    notifyListeners();
    return response;
  }

  Future<Map<String, dynamic>> applyForLeaveCancel(
      int id, String cancellationReason) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> successInformation =
        await ApiService.applyLeaveCancel(id, cancellationReason);
    if (successInformation['data'] != null) {
      _isLoading = false;
      notifyListeners();
      return successInformation['data'];
    } else {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>> updateEmployeeProfilePic(FormData data) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> successInformation =
        await ApiService.updateEmployeeInfo(data);
    if (successInformation != null) {
      _isLoading = false;
      notifyListeners();
      return successInformation;
    } else {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }


  bool get
  isActivityLoading {
    return _isLoading;
  }

}
