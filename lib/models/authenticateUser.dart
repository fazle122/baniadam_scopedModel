import 'package:flutter/material.dart';

class AuthenticateUser {
  final String token;
  final String userType;
  final List<String> userRoles;
  final String userCurrentRole;
  final int isTrackable;

  AuthenticateUser({
    @required this.token,
    @required this.userType,
    @required this.userRoles,
    @required this.userCurrentRole,
    @required this.isTrackable
  });
}


class AuthenticateCompanyId {
  final String companyID;

  AuthenticateCompanyId({
    @required this.companyID,
  });
}
