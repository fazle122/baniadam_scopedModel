import 'package:baniadam/base_state.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;



class UnRegisterConfirmationDialog extends StatefulWidget {
  final int id;
  final String type;
  final Map<String, dynamic> filters;
  UnRegisterConfirmationDialog({this.id,this.type,Key key,this.filters}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UnRegisterConfirmationDialogState();
  }
}

class _UnRegisterConfirmationDialogState extends BaseState<UnRegisterConfirmationDialog> {


  void _unRegister() async {
    AuthHelper.unregisterUser();
    bg.BackgroundGeolocation.stop().then((bg.State state) {
      print('[stop] success: $state');
    });
    Navigator.pushNamed(context, '/register');
  }

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
              Center(

                  child:Text('Are you sure, you want to cancel your registration ?')),
              SizedBox(height: 30.0,),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        child:InkWell(
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
                                  'No',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark),
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Material(
                        child: InkWell(
                          child: Container(
                            width: 100.0,
                            height: 35.0,
                            decoration: ShapeDecoration(
                              color: Theme.of(context).buttonColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey.shade500),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            child: Center(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          onTap: () async{
                            _unRegister();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),)
        )
      // _filterOptions(context),
    );
  }
}