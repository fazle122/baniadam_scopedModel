
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/models/EmployeeList.dart';
import 'package:baniadam/models/adminDashboard.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


mixin AdminUtilityScopedModel on Model{

  bool _isLoading = false;

  List<EmployeeList> _employees = [];
  List<AdminAttendanceRequestList> _adminAttendanceRequests= [];
  Map<String,dynamic> leaveListFilter = Map();
  Map<String,dynamic> trackableEmpFilter = Map();
  List<LeaveRequest> _leaveRequests=[];

  List<EmployeeList> get allEmployees{
    return List.from(_employees);
  }

  List<AdminAttendanceRequestList> get attendanceRequestForAdmin{
    return List.from(_adminAttendanceRequests);
  }

  List<LeaveRequest> get allLeaveRequests{
    return List.from(_leaveRequests);
  }

  Future<Null> fetchCurrentShiftEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getCurrentShiftEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchDayOffEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getDayOffEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchOnTimeEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getOnTimeEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchLateEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getLateEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchPresentEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getPresentEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAbsentEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getAbsentEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchOnLeaveEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getOnleaveEmployee();
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image: empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchLeaveRequestsListForRefresh() async{
    await fetchLeaveRequestsListForAdmin;
    notifyListeners();
    return;
  }

  Future<Null> fetchLeaveRequestsListForAdmin({Map<String,dynamic> filters,int currentPage}) async{
    _isLoading = true;
    notifyListeners();
    final List<LeaveRequest> leaveRequestsList = [];
    final Map<String, dynamic> data = await ApiService.getLeavesList(filters);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<data['data'].length;i++){
      final LeaveRequest attendanceData  = LeaveRequest(
        id:data['data'][i]['id'],
        employeeName: data['data'][i]['employee']['fullName'],
        fromDate: data['data'][i]['from'],
        toDate: data['data'][i]['to'],
        reason: data['data'][i]['reason'],
        appliedOn: data['data'][i]['created_at'],
        status: data['data'][i]['status'],
      );
      leaveRequestsList.add(attendanceData);
    }
    _leaveRequests = leaveRequestsList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchAttendanceRequestsForAdminForRefresh() async{
    await fetchAttendanceRequestsForAdmin;

  }

  Future<Null> fetchAttendanceRequestsForAdmin(Map<String,dynamic> filters) async{
    _isLoading = true;
    notifyListeners();
    final List<AdminAttendanceRequestList> requestList = [];
    final List<dynamic> data = await ApiService.getAttendanceRequestListForAdmin(filters);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    for (int i = 0; i < data.length; i++) {
      final AdminAttendanceRequestList requestData = AdminAttendanceRequestList(
        id: data[i]['id'],
        employeeName: data[i]['employee']['fullName'],
        status: data[i]['status'],
        flag: data[i]['flag'],
        time: data[i]['time'],
        date:data[i]['date'],
        appliedOn: data[i]['created_at'],

      );
      requestList.add(requestData);
    }
    _adminAttendanceRequests = requestList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Null> fetchTrackableEmployees() async{
    _isLoading = true;
    notifyListeners();
    final List<EmployeeList> fetchedEmployeeList = [];
    final Map<String, dynamic> empData = await ApiService.getTrackedEmployees(trackableEmpFilter);
    if (empData == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<empData['data'].length;i++){
      final EmployeeList emp = EmployeeList(
        id: empData['data'][i]['id'].toString(),
        name: empData['data'][i]['fullName'],
        image:  empData['data'][i]['photoAttachment'],
      );
      fetchedEmployeeList.add(emp);
    }
    _employees = fetchedEmployeeList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  Future<Map<String, dynamic>> leaveApprove(int id, String status, String note, String declinedReason) async{
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> successInformation = await ApiService.leaveApproval(id, status, note, declinedReason);
    if(successInformation != null){
      _isLoading = false;
      notifyListeners();
      return successInformation;
    }
    else{
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>> approveAttendanceRequest(int id, String status, String note, String declinedReason) async{
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> response;
    if(status == 'APPROVED'){
      response = await ApiService.approveAttendanceRequest(id);
    }else{
      response = await ApiService.declineAttendanceRequest(id,note, declinedReason);
    }
    if(response != null){
      _isLoading = false;
      notifyListeners();
      return response;
    }
    else{
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  List<AttendanceDetailForAdmin> _attendanceDetailForAdmin = [];


  List<AttendanceDetailForAdmin> get allAttendanceDetailForAdmin{
    return List.from(_attendanceDetailForAdmin);
  }

  Future<Null> fetchAttendanceDetailListForAdmin(String id,String date) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');

    _isLoading = true;
    notifyListeners();
    final List<AttendanceDetailForAdmin> detailList = [];
    final Map<String, dynamic> data = await ApiService.getCurrentDateAttendanceDetail(id,date);
    if (data == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    for(int i=0; i<data['data']['attendance'].length;i++){
      final AttendanceDetailForAdmin attendanceData  = AttendanceDetailForAdmin(
        id: data['data']['attendance'][i]['id'],
        flag: data['data']['attendance'][i]['flag'],
        selfieUrl: ApiService.CDN_URl + '$cid/' + data['data']['attendance'][i]['selfie'],
        time: data['data']['attendance'][i]['time'],
        deviceType: data['data']['attendance'][i]['device_type'],
        lat: data['data']['attendance'][i]['lat'],
        lng: data['data']['attendance'][i]['lng'],
      );
      detailList.add(attendanceData);
    }
    _attendanceDetailForAdmin = detailList;
    _isLoading = false;
    notifyListeners();
    return;
  }

  bool get isLoading {
    return _isLoading;
  }

}


//
//mixin UtilityModel on EmployeesListScopedModel {
//
//  bool get isLoading {
//    return _isLoading;
//  }
//}

