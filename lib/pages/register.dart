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

//            child: Center(
//              child: SingleChildScrollView(
//                child: Container(
//                  width: targetWidth,
//                  child: Form(
//                    key: _formKey,
//                    child: Column(
//                      children: <Widget>[
//                        _buildCompanyIdField(),
//                        SizedBox(height:20.0),
//                        ScopedModelDescendant<MainModel>(
//                          builder: (BuildContext context, Widget child,
//                              MainModel model) {
//                            return RaisedButton(
//                              textColor: Colors.white,
//                              child: Text('Register'),
//                              onPressed: () => _submitForm(model.setCompanyId),
//                            );
//                          },
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
          ),
        ));
  }
}

