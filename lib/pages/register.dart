import 'package:baniadam/base_state.dart';
import 'package:baniadam/helper/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'dart:io';
import 'dart:async';

class RegisterPage extends StatefulWidget {

  final MainModel model;

  RegisterPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends BaseState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  bool showPass = false;
  String _deviceId;
  String myInstanceId;

  final Map<String, dynamic> _formData = {
    'companyId': null,
  };

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    try {
      if (Platform.isAndroid) {
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    setState(() {
      _deviceId = build.androidId;
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    setState(() {
      _deviceId = data.model;
    });
  }

  generateInstanceId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myInstanceId = prefs.getString('myInstanceId');
    if(myInstanceId == null){
      setState(() {
        myInstanceId = _deviceId+ DateTime.now().toString();
        prefs.setString('myInstanceId', myInstanceId);
        print('instance Id:' + myInstanceId);
      });
    }
  }


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
            hintText: 'company id',
            prefixIcon: Icon(Icons.confirmation_number),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: (String value) {
            if (value.isEmpty || value.length < 0) {
              return 'Please enter valid company ID';
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
      generateInstanceId();
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
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child:Form(
              key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Utility.logoContainer(
                        Image.asset('assets/icons/BaniAdam-Logo_Final.png')),
                    SizedBox(height: 30.0),
                    Center(
                        child: Text('Register',
                            style: Theme.of(context).textTheme.title)),
                    SizedBox(height: 50.0),
                    Center(child: Text('Register with your portal name')),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(width: 250.0, child: _buildCompanyIdField()),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return RaisedButton(
                            textColor: Colors.white,
                            child: Text('Register'),
                            onPressed: () => _submitForm(model.setCompanyId),
                          );
                        },
                      ),),
                  ],
                )
            )
          ),
        ));
  }
}

