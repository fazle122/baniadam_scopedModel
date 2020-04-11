import 'package:flutter/material.dart';

class EmployeeDashboard {
  final String flag;
  final String time;
  final String reason;

  EmployeeDashboard({
    @required this.flag,
    @required this.time,
    @required this.reason,
  });
}

class CompanyInfo {
  final String companyLogoUrl;

  CompanyInfo({
    @required this.companyLogoUrl,
  });
}
