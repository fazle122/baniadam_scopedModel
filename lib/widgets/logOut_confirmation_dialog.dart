import 'package:baniadam/base_state.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:baniadam/helper/AuthHelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';




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

  int id;
  Location _locationService = new Location();
  LocationData _currentLocation;
  String error;
  String myInstanceId;


  @override
  void initState() {
    super.initState();
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 100);

    var location = new Location();
    try {
      setState(() async{
        _currentLocation = await location.getLocation();

      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
  }

  void createActivityLog(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cid = prefs.getString('curr-cid');
    String instanceIdFromPrefs = prefs.getString('myInstanceId');

    final Map<String, dynamic> detailData =
    await ApiService.getEmployeeDetail();
    if (detailData != null) {
      setState(() {
        id = detailData['data']['id'];
        myInstanceId = instanceIdFromPrefs;
      });
    }

    final Map<String, dynamic> createLog =
    await ApiService.createActivityLog(
      cid,token,'app',myInstanceId,id.toString(),'logOut',
      _currentLocation.latitude.toString(),_currentLocation.longitude.toString(),DateTime.now().toString(),'',
    );

  }

  void logOut() async {
    AuthHelper.logOutUser();
    Navigator.pushNamed(context, '/logIn');
//    bool internetConnectivity = await updateConnectionStatus();
//    if(!internetConnectivity){
//      Toast.show('No internet, You need internet connectivity to logout', context,
//          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//    }else{
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      String cid = prefs.getString('curr-cid');
//      String token = prefs.getString('curr-user');
//      String instanceIdFromPrefs = prefs.getString('myInstanceId');
//      final Map<String, dynamic> detailData =
//      await ApiService.getEmployeeDetail();
//      if (detailData != null) {
//        setState(() {
//          id = detailData['data']['id'];
//          myInstanceId = instanceIdFromPrefs;
//        });
//      }
//
////      final Map<String, dynamic> createLog =
////      await ApiService.createActivityLog(
////        cid,token,'app',myInstanceId,id.toString(),'logOut',
////        _currentLocation.latitude.toString(),_currentLocation.longitude.toString(),DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),'',
////      );
//
////      bg.BackgroundGeolocation.stop().then((bg.State state) {
////        print('[stop] success: $state');
////      });
//
//      AuthHelper.logOutUser();
//      Navigator.pushNamed(context, '/logIn');
//    }
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
                        Material(
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
                        ),
                        Material(
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
                              logOut();
                            },
                          ),
                        )

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
}
