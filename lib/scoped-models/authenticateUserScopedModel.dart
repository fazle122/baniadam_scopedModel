
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/models/authenticateUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';



mixin AuthenticateUserScopedModel on Model {
  Location _locationService = new Location();
  LocationData _currentLocation;
  String error;

  AuthenticateUser _authenticatedUser;
  AuthenticateCompanyId _companyId;
  bool _switchUser=false;
  bool _isLoading = false;
  List<String> userRoles;
  String userType;

  AuthenticateUser get userAuthenticationInfo{
    fetchUserAuthenticationInfo();
    return _authenticatedUser;
  }

  AuthenticateCompanyId get companyId{
    return _companyId;
  }

  bool get userCurrentRole{
    return _switchUser;
  }

  Future<Null> switchUserRole(bool value){
    AuthHelper.updateUserCurrentRole(value);
    fetchUserAuthenticationInfo();
  }


  Future<String> getUserCurrentRole() async{
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('user-current-role');
    _isLoading = false;
    notifyListeners();
    return role;
  }

  Future<bool> setCompanyId(String companyId) async{
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthHelper.setCompany(companyId);
  }

  Future<Null> fetchCompanyId() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final AuthenticateCompanyId companyData = AuthenticateCompanyId(
      companyID: preferences.getString('curr-cid'),
    );

    _companyId = companyData;
    _isLoading = false;
    notifyListeners();
    return;

  }

  Future<Map<String, dynamic>> logInUser(String userName, String passWord) async {
    _isLoading = true;
    notifyListeners();
    int trackable;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    final Map<String, dynamic> loginResponse = await ApiService.login(
        userName, passWord, cid, 'ideaxen123');

    if (!loginResponse.containsKey('access_token') && loginResponse['access_token'] == null) {
      return loginResponse;
    }

    if (loginResponse.containsKey('access_token') && loginResponse['access_token'] != null) {
      String currentUserRole;
      prefs.setString('curr-cid', 'ideaxen');

      userRoles = [];
      for(int i=0; i<loginResponse['user_roles'].length; i++){
        userRoles.add(loginResponse['user_roles'][i]);
      }
      if(userRoles.contains('Admin') || userRoles.contains('Approver')){
        currentUserRole = 'Admin';
      }else{
        currentUserRole= 'Employee';
      }
      prefs.setString('currentUserRole', currentUserRole);

      if(loginResponse.containsKey('is_tracking') && loginResponse['is_tracking'] != null){
          trackable = loginResponse['is_tracking'];
        prefs.setInt('isTrackable',trackable);
      }
      AuthHelper.setLoginUser(loginResponse['access_token'], loginResponse['user_type'],userRoles,currentUserRole,loginResponse['is_tracking']);
      createActivityLog(loginResponse['access_token'],'logIn');
      return loginResponse;
    }
  }

  Future<void> logOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('user-token');
    createActivityLog(token, 'logOut');
    AuthHelper.logOutUser();
  }

  void createActivityLog(String token,String status) async{
    var location = new Location();
    var id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cid = prefs.getString('curr-cid');
    var myInstanceId = prefs.getString('myInstanceId');
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 100);
    try {
      _currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
    final Map<String, dynamic> detailData = await ApiService.getEmployeeDetail();
    if (detailData != null && _currentLocation != null) {
      id = detailData['data']['id'];
      await ApiService.createActivityLog(
        cid,token,'app',myInstanceId,id.toString(),status,
        _currentLocation.latitude.toString(),_currentLocation.longitude.toString(),DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),'',
      );
    }
  }

  Future<Map<String,dynamic>> changePassword(String oldPassword,String newPassword) async{
    _isLoading = true;
    notifyListeners();
    final Map<String,dynamic> response = await ApiService.changePassword(oldPassword, newPassword);
    if (response != null) {
      return response;
    }else{
      return null;
    }
  }
  
  Future<Null> fetchUserAuthenticationInfo() async{
    _isLoading = true;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final AuthenticateUser userData = AuthenticateUser(
      token: preferences.getString('user-token'),
      userType: preferences.getString('user-type'),
      userRoles: preferences.getStringList('user-roles'),
      userCurrentRole: preferences.getString('user-current-role'),
      isTrackable: preferences.getInt('isTreckable'),
    );

    _authenticatedUser = userData;
    _isLoading = false;
    notifyListeners();
    return;
    
  }

  bool get isAuthenticationLoading {
    return _isLoading;
  }

//  initPlatformState() async {
//    await _locationService.changeSettings(
//        accuracy: LocationAccuracy.HIGH, interval: 100);
//
//    var location = new Location();
//    try {
//        _currentLocation = await location.getLocation();
//
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        error = 'Permission denied';
//      }
//      _currentLocation = null;
//    }
//  }



}