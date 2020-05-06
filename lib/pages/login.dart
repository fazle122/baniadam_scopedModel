import 'package:baniadam/base_state.dart';
import 'package:baniadam/helper/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:toast/toast.dart';



class LoginPage extends StatefulWidget {
  final MainModel model;

  LoginPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BaseState<LoginPage> {
  bool showPass = false;
  String companyLogo;

  @override
  void initState() {
    widget.model.fetchCompanyInformation();
    super.initState();
  }

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmailTextField() {
    return Container(
        width: MediaQuery.of(context).size.width * 4 / 5,
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 30.0, 15.0),
            hintText: 'Username',
            prefixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
//      decoration: InputDecoration(
//          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return 'Please enter a valid email';
            }
          },
          onSaved: (String value) {
            _formData['email'] = value;
          },
        ));
  }

  Widget _buildPasswordTextField() {
    return Container(
        width: MediaQuery.of(context).size.width * 4 / 5,
        child: TextFormField(
          decoration: InputDecoration(
            focusColor: Theme.of(context).primaryColorDark,
            labelStyle: TextStyle(color: Theme.of(context).primaryColorDark),
            hintText: 'Password',
            prefixIcon: Icon(Icons.confirmation_number),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
//      decoration: InputDecoration(
//          labelText: 'Password', filled: true, fillColor: Colors.white),
          obscureText: showPass?false:true,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Password invalid';
            }
          },
          onSaved: (String value) {
            _formData['password'] = value;
          },
        ));
  }

  Widget _showPassCheckBox() {
    return Container(
      width: 240.0,
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Theme.of(context).primaryColorDark,
            value: showPass,
            onChanged: (bool value) {
              setState(() {
                showPass = value;
              });
            },
          ),
          Text("Show Password"),
        ],
      ),
    );
  }

  void _submitForm(Function login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    login(
      _formData['email'],
      _formData['password'],
    ).then((Map<String, dynamic> response) {
      if (response['access_token'] != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Toast.show(response['message'], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

      }
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
                                          Theme.of(context).primaryColorDark),
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
                                  color: Theme.of(context).buttonColor,
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
                                await SystemChannels.platform
                                    .invokeMethod<void>('SystemNavigator.pop');
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
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('BaniAdam HR - login'),
              actions: <Widget>[
                PopupMenuButton<String>(
                    onSelected: (val) async {
                      switch (val) {
                        case 'UNREGISTER':
                          debugPrint('UNREGISTER');
                          Utility.unRegisterDialog(context);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'UNREGISTER',
                            child: Text('Unregister'),
                          ),
                        ]),
              ],
            ),
            body: _buildLoginBody(context)));
  }

  Widget _buildLoginBody(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          Widget content = Center(child: Text('Register with valid company id'));
          if (model.allCompanyInformation != null && !model.isActivityLoading)
          {
            content = Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
//                                  SizedBox(
//                                    height: 20.0,
//                                  ),
                          FadeInImage(
                            image: NetworkImage(widget.model
                                .allCompanyInformation.companyLogoUrl),
                            height: 80,
                            width: 100,
                            fit: BoxFit.contain,
                            placeholder: AssetImage('assets/icons/BaniAdam-Logo_Final.png'),
                          ),
                          SizedBox(height: 10.0),
                          Center(
                              child: Text('Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .title)),
                          SizedBox(height: 50.0),
                          _buildEmailTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _showPassCheckBox(),
                          SizedBox(height: 20.0),
                          ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context,
                                Widget child, MainModel model) {
                              return RaisedButton(
                                textColor: Colors.white,
                                child: Text('LOGIN'),
                                onPressed: () =>
                                    _submitForm(model.logInUser),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          else if (model.isActivityLoading) {
            content = Center(child: CircularProgressIndicator());
          }
          return content ;
        });
  }
}
