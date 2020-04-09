import 'package:baniadam/helper/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';

class RegisterPage extends StatefulWidget {

  final MainModel model;

  RegisterPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPass = false;

  final Map<String, dynamic> _formData = {
    'companyId': null,
  };


  Widget _buildCompanyIdField() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 4 / 5,
        child: TextFormField(
          decoration: InputDecoration(
            focusColor: Theme
                .of(context)
                .primaryColorDark,
            labelStyle: TextStyle(color: Theme
                .of(context)
                .primaryColorDark),
            hintText: 'protal id',
            prefixIcon: Icon(Icons.confirmation_number),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)),
          ),
//      decoration: InputDecoration(
//          labelText: 'Password', filled: true, fillColor: Colors.white),
          obscureText: true,
          validator: (String value) {
            if (value.isEmpty || value.length < 0) {
              return 'Password invalid';
            }
          },
          onSaved: (String value) {
            _formData['companyId'] = value;
          },
        )
    );
  }

  void _submitForm(Function setCompany) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setCompany(_formData['companyId'],).then((bool success) {

        Navigator.pushReplacementNamed(context, '/logIn');
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.all(25.0),
              title: Center(child: Text('Exit app confirmation')),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text('You are sure, you want to exit the application?'),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade500),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color:
                                          Theme
                                              .of(context)
                                              .primaryColorDark),
                                    )),
                              ),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            InkWell(
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: ShapeDecoration(
                                  color: Theme
                                      .of(context)
                                      .buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              onTap: () async {
                                await SystemChannels.platform.invokeMethod<
                                    void>('SystemNavigator.pop');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            // _filterOptions(context),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('BaniAdam HR - register'),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildCompanyIdField(),
                        SizedBox(height:20.0),
                        ScopedModelDescendant<MainModel>(
                          builder: (BuildContext context, Widget child,
                              MainModel model) {
                            return RaisedButton(
                              textColor: Colors.white,
                              child: Text('Register'),
                              onPressed: () => _submitForm(model.setCompanyId),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}









//import 'package:baniadam/scoped-models/main.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import '../helper/AuthHelper.dart';
//import 'package:flutter/services.dart';
//import 'package:toast/toast.dart';
//import 'package:random_string/random_string.dart';
//import 'package:device_info/device_info.dart';
//import 'dart:io';
//import 'dart:async';
//import 'package:flutter/foundation.dart';
//
//class RegisterPage extends StatefulWidget {
//  RegisterPage({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _RegisterPageState createState() => _RegisterPageState();
//}
//
//class _RegisterPageState extends State<RegisterPage> {
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  TextEditingController nameController;
//  TextEditingController idController;
//  bool showPass = false;
//  Map<String, dynamic> personalDetail;
//  int userType = 0;
//  Color buttonColor;
//  String myInstanceId;
//  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//  Map<String, dynamic> _deviceData = <String, dynamic>{};
//  String _deviceId;
//
//  final Map<String, dynamic> _formData = {
//    'companyID': null,
//  };
//
//  @override
//  void initState() {
//    super.initState();
//    buttonColor = Colors.grey;
//    initPlatformState();
//    nameController = TextEditingController();
//    idController = TextEditingController();
//  }
//
//  Future<void> initPlatformState() async {
//    Map<String, dynamic> deviceData;
//    try {
//      if (Platform.isAndroid) {
//        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
//      } else if (Platform.isIOS) {
//        _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
//      }
//    } on PlatformException {
//      deviceData = <String, dynamic>{
//        'Error:': 'Failed to get platform version.'
//      };
//    }
//
//    if (!mounted) return;
//
//    setState(() {
//      _deviceData = deviceData;
//    });
//  }
//
//  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
//    setState(() {
//      _deviceId = build.androidId;
//    });
//  }
//
//  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
//    setState(() {
//      _deviceId = data.model;
//    });
//  }
//
//  generateInstanceId() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    myInstanceId = prefs.getString('myInstanceId');
//    if (myInstanceId == null) {
//      String random = randomAlpha(10);
//      setState(() {
////        myInstanceId = random.toString()+ DateTime.now().toString();
//        myInstanceId = _deviceId + DateTime.now().toString();
//        prefs.setString('myInstanceId', myInstanceId);
//        print('instance Id:' + myInstanceId);
//      });
//    }
//  }
//
//  Future<bool> _onBackPressed() {
//    return showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
//              contentPadding: EdgeInsets.all(25.0),
//              title: Center(child: Text('Exit app confirmation')),
//              content: SingleChildScrollView(
//                child: Column(
//                  children: <Widget>[
//                    Text('You are sure, you want to exit the application?'),
//                    SizedBox(
//                      height: 30.0,
//                    ),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            InkWell(
//                              child: Container(
//                                width: 100.0,
//                                height: 35.0,
//                                decoration: ShapeDecoration(
//                                  color: Colors.white,
//                                  shape: RoundedRectangleBorder(
//                                    side: BorderSide(
//                                        width: 1.0,
//                                        style: BorderStyle.solid,
//                                        color: Colors.grey.shade500),
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(3.0)),
//                                  ),
//                                ),
//                                child: Center(
//                                    child: Text(
//                                  'No',
//                                  style: TextStyle(
//                                      color:
//                                          Theme.of(context).primaryColorDark),
//                                )),
//                              ),
//                              onTap: () {
//                                Navigator.of(context).pop(false);
//                              },
//                            ),
//                            InkWell(
//                              child: Container(
//                                width: 100.0,
//                                height: 35.0,
//                                decoration: ShapeDecoration(
//                                  color: Theme.of(context).buttonColor,
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(3.0)),
//                                  ),
//                                ),
//                                child: Center(
//                                    child: Text(
//                                  'Yes',
//                                  style: TextStyle(color: Colors.white),
//                                )),
//                              ),
//                              onTap: () async {
//                                await SystemChannels.platform
//                                    .invokeMethod<void>('SystemNavigator.pop');
//                              },
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              )
//              // _filterOptions(context),
//              );
//        });
//  }
//
////  Widget _idField() {
////    return TextFormField(
////      onChanged: (_) {
////        setState(() {
////          buttonColor = Theme.of(context).buttonColor;
////        });
////      },
////      textAlign: TextAlign.center,
////      controller: idController,
////      decoration: InputDecoration(
////        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 30.0, 15.0),
////        hintText: 'Portal name',
//////          prefixIcon: Icon(Icons.person),
////        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
////      ),
////      validator: (String value) {
////        if (value.isEmpty || value.length < 0) {
////          return 'Please provide portal Id';
////        }
////      },
////      onSaved: (String value) {
////        _formData['companyID'] = value;
////      },
////    );
////  }
////
////  void _submitForm(Function setCompany) {
////    if (!_formKey.currentState.validate()) {
////      return;
////    }
////    _formKey.currentState.save();
////    setCompany(
////      _formData['companyID'],
////    ).then((bool success) {
////      AuthHelper.setCompanyId(_formData['companyID']);
////      Navigator.pushReplacementNamed(context, '/logIn');
////    });
////  }
//
//  Widget _idField() {
//    return TextFormField(
//          decoration: InputDecoration(
//            focusColor: Theme
//                .of(context)
//                .primaryColorDark,
//            labelStyle: TextStyle(color: Theme
//                .of(context)
//                .primaryColorDark),
//            hintText: 'Portal name',
//            prefixIcon: Icon(Icons.confirmation_number),
//            border: OutlineInputBorder(
//                borderRadius: BorderRadius.circular(32.0)),
//          ),
////      decoration: InputDecoration(
////          labelText: 'Password', filled: true, fillColor: Colors.white),
//          validator: (String value) {
//            if (value.isEmpty || value.length < 0) {
//              return 'Password portalName';
//            }
//          },
//          onSaved: (String value) {
//            _formData['companyID'] = value;
//          },
//        );
//  }
//
//  void _submitForm(Function setCompany) {
//    if (!_formKey.currentState.validate()) {
//      return;
//    }
//    _formKey.currentState.save();
//    setCompany(
//        _formData['companyID']
//    ).then((bool success) {
//        Navigator.pushReplacementNamed(context, '/logIn');
//    });
//  }
//
//  Widget _registerButton(BuildContext context) {
//    return ScopedModelDescendant<MainModel>(
//        builder: (BuildContext context, Widget child, MainModel model) {
//      return Container(
//          margin: EdgeInsets.all(12),
//          height: 50.0,
//          width: 100.0,
//          decoration: BoxDecoration(
//            boxShadow: [
//              BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(3, 3))
//            ],
//            borderRadius: BorderRadius.all(Radius.circular(5.0)),
//          ),
//          child: Material(
//              borderRadius: BorderRadius.all(Radius.circular(5.0)),
//              color: idController.text.length <= 0
//                  ? Theme.of(context).disabledColor
//                  : Theme.of(context).buttonColor,
//              child: InkWell(
//                  onTap: () {
//                    _submitForm(model.setCompanyId);
////                    generateInstanceId();
//                  },
//                  child: Center(
//                    child: Text(
//                      'Register',
//                      style: TextStyle(
//                          color: idController.text.length <= 0
//                              ? Colors.black
//                              : Colors.white),
//                    ),
//                  ))));
//    });
//  }
//
////  void _registerUser() async {
////    if (idController.text.length <= 0) {
////      Toast.show(' Please provide portal Id', context,
////          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
////    } else {
////      AuthHelper.setCompanyId(idController.text);
////      Navigator.pushNamed(context, '/logIn');
////    }
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModelDescendant<MainModel>(
//        builder: (BuildContext context, Widget child, MainModel model) {
//      return WillPopScope(
//          onWillPop: _onBackPressed,
//          child: Scaffold(
//            appBar: AppBar(
//                title: Text('BaniAdam HR - register'),
//                automaticallyImplyLeading: false),
//            body: SingleChildScrollView(
//                child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                SizedBox(
//                  height: 20.0,
//                ),
//                _sizedContainer(
//                    Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
//                SizedBox(height: 30.0),
//                Center(
//                    child: Text('Register',
//                        style: Theme.of(context).textTheme.title)),
//                SizedBox(height: 50.0),
//                Center(child: Text('Register with your portal name')),
//                SizedBox(
//                  height: 20.0,
//                ),
//                Container(width: 250.0, child: _idField()),
//                SizedBox(
//                  height: 20.0,
//                ),
//                Container(width: 150.0, child: _registerButton(context)),
//              ],
//            )),
//          ));
//    });
//  }
//
//  Widget _sizedContainer(Widget child) {
//    return new SizedBox(
//      width: 100.0,
//      height: 50.0,
//      child: new Center(
//        child: child,
//      ),
//    );
//  }
//}
