import 'package:baniadam/scoped-models/adminDashboardScopedModel.dart';
import 'package:baniadam/scoped-models/authenticateUserScopedModel.dart';
import 'package:baniadam/scoped-models/employeeDashboardScopedModel.dart';
import 'package:baniadam/scoped-models/employeeUtilityScopedModel.dart';
//import 'package:baniadam/scoped-models/utilityScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/adminUtilityScopedModel.dart';


class MainModel extends Model with AdminUtilityScopedModel, AuthenticateUserScopedModel,AdminDashboardScopedModel,EmployeeDashboardScopedModel,EmployeeOperationsScopedModel {
}
