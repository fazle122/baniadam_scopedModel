import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:location/location.dart';
import 'package:flutter/services.dart';




class LogOutConfirmationDialog extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> filters;

  LogOutConfirmationDialog({this.id, this.type, Key key, this.filters})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogOutConfirmationDialogState();
  }
}

class _LogOutConfirmationDialogState
    extends BaseState<LogOutConfirmationDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        contentPadding: EdgeInsets.all(25.0),
        title: Center(child: Text('Confirmation required')),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text('Are you sure, you want to logout ?'),
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
                        _cancelButton(context),
                        _confirmButton(context)

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      // _filterOptions(context),
    );
  }

  void _submitForm(Function logOut) {
    logOut().then((success) {
      if(success)
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        print('[stop] success: $state');
      });
      Navigator.pushNamed(context, '/logIn');
    });
  }

  Widget _confirmButton(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context,Widget child, MainModel model){
        return Material(
          child: InkWell(
            child: Container(
              width: 100.0,
              height: 35.0,
              decoration: ShapeDecoration(
                color: Theme.of(context).buttonColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Colors.grey.shade500),
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: Center(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            onTap: () async {
              _submitForm(model.logOut);
            },
          ),
        );
      }
    );

  }

  Widget _cancelButton(BuildContext context) {
    return Material(
                        child: InkWell(
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
                                      color: Theme.of(context).primaryColorDark),
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
  }
}
