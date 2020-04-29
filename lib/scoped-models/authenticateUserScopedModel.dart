
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/models/authenticateUser.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';



mixin AuthenticateUserScopedModel on Model {

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

//  Future<bool> getUserCurrentRole() async{
//    _isLoading = true;
//    notifyListeners();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String role = prefs.getString('user-current-role');
//    if(role == 'Employee') {
//      _switchUser = true;
//    }
//    else{
//      _switchUser = false;
//    }
//    _isLoading = false;
//    notifyListeners();
//    return _switchUser;
//  }

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
//      userRoles.addAll(loginResponse['user_roles']);
      for(int i=0; i<loginResponse['user_roles'].length; i++){
        userRoles.add(loginResponse['user_roles'][i]);
      }
      if(userRoles.contains('Admin') || userRoles.contains('Approver')){
        currentUserRole = 'Admin';
      }else{
        currentUserRole= 'Employee';
      }
      prefs.setString('currentUserRole', currentUserRole);
      AuthHelper.setLoginUser(loginResponse['access_token'], loginResponse['user_type'],userRoles,currentUserRole,loginResponse['is_tracking']);

      return loginResponse;
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

}