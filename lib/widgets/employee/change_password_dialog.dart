import 'package:baniadam/base_state.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';

class ChangePasswordDialog extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> filters;

  ChangePasswordDialog({this.id, this.type, Key key, this.filters})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordDialogState();
  }
}

class _ChangePasswordDialogState extends BaseState<ChangePasswordDialog> {
  TextEditingController _oldPassController;
  TextEditingController _newPassController;
  TextEditingController _confirmPassController;
  bool autoValidate = false;
  bool showPass = false;
  bool _disableButton = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _oldPassController = TextEditingController();
    _newPassController = TextEditingController();
    _confirmPassController = TextEditingController();
    super.initState();
  }


  Widget _oldPassField() {
    return TextFormField(

        keyboardType: TextInputType.text,
        inputFormatters: [
          BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
        ],
        validator: (String arg) {
          if (arg.length < 0)
            return 'please provide old password';
          else
            return null;
        },
        obscureText: !showPass,
        controller: _oldPassController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
          labelText: 'Old password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget _newPassField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [
          BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
        ],
        validator: (String arg) {
          if (arg.length < 0)
            return 'please provide new password';
          else
            return null;
        },
        obscureText: !showPass,
        controller: _newPassController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
          labelText: 'New password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget _confirmPassField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        inputFormatters: [
          BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
        ],
        validator: (String arg) {
          if (arg.length < 0)
            return 'please provide new password';
          else
            return null;
        },
        obscureText: !showPass,
        controller: _confirmPassController,
        decoration: InputDecoration(
          labelStyle: TextStyle(color:Theme.of(context).primaryColorDark),
          labelText: 'Confirm password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            border:
//                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ));
  }

  Widget _changePassButton(BuildContext context) {
    return Material(
        elevation: 5.0,
//        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).buttonColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            setState(() {
//              _loginUser();
            });
          },
          child: Text(
            'LOGIN',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget _form(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(child: Text('Please provide necessary informations')),
        SizedBox(
          height: 30.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _oldPassField(),
            SizedBox(
              height: 20.0,
            ),
            _newPassField(),
            SizedBox(
              height: 20.0,
            ),
            _confirmPassField(),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 240.0,
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: showPass,
                    onChanged: (bool value) {
                      setState(() {
                        showPass = value;
                      });
                    },
                  ),
                  Text("Show password"),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCancelButton(context),
                _buildSubmitButton(context),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return InkWell(
          child: Container(
            width: 100.0,
            height: 35.0,

            decoration: ShapeDecoration(
              color: !_disableButton
                  ? Theme.of(context).buttonColor
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          onTap: _disableButton
              ? null
              : () async {
            if (_oldPassController.text.length <= 0) {
              Toast.show("Please provide old password", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
            } else if (_newPassController.text.length <= 0) {
              Toast.show("Please provide new password", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
            } else if (_confirmPassController.text.length <= 0) {
              Toast.show(
                  "Please provide confirm password", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
            } else if (_newPassController.text !=
                _confirmPassController.text) {
              Toast.show(
                  "Confirm password didn\'t match", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
            } else {
              if (_formKey.currentState.validate()) {
                if (_newPassController.text.length < 6) {
                  Toast.show(
                      "Please provide atleast 6 characters for new password.",
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER);
                } else {
                  await _submitForm(model.changePassword,_oldPassController.text,
                      _newPassController.text);
                }
              }
            }
          },
        );
      }
    );

  }

  Future<Null> _submitForm(Function changePassword,String oldPassword,String newPassword) async {

    changePassword(oldPassword, newPassword).then((Map<String,dynamic> response){
      if(response != null){
        Toast.show(response['msg'], context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        Navigator.of(context).pop();
      }else{
        Toast.show('Something wrong, please try again.', context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }

    });

  }

  Widget _buildCancelButton(BuildContext context) {
    return InkWell(
                child: Container(
                  width: 100.0,
                  height: 35.0,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    ),
                  ),
                  child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).primaryColorDark),
                      )),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(25.0),
        title: Center(child: Text('Change password')),
        content: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  autovalidate: autoValidate,
                  child: _form(context),
                )))
      // _filterOptions(context),
    );
  }
}
