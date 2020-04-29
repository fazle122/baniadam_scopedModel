import 'dart:async';
import 'dart:io';
import 'package:baniadam/base_state.dart';
import 'package:baniadam/scoped-models/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:baniadam/data_provider/api_service.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class PicturePreviewScreen extends StatefulWidget {
  final MainModel model;

  const PicturePreviewScreen({
    this.model,
  });

  @override
  PicturePreviewScreenState createState() => PicturePreviewScreenState();
}

class PicturePreviewScreenState extends BaseState<PicturePreviewScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String _timeString;

  @override
  void initState() {
    super.initState();
    widget.model.fetchEmployeeInformation();
    _initializeCamera();
//    _controller = CameraController(
//      widget.camera,
//      ResolutionPreset.low,
//    );
//    _initializeControllerFuture = _controller.initialize();
  }

  _initializeCamera() async {
    final cameras = await availableCameras();
    final lastCamera = cameras.last;

    _controller = CameraController(
      lastCamera,
      ResolutionPreset.low,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 4 / 5,
                      child: CameraPreview(_controller)),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .5 / 5,
                      child: Center(
                        child: Text(
                          'Take selfie',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 25.0),
                        ),
                      )),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    child: Container(
                      width: 100.0,
                      height: 30.0,
                      child: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
//                child:InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * 9 / 10,
                  height: MediaQuery.of(context).size.height * 7 / 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3.0,
                        color: Colors.grey,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildCameraButton(),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _buildCameraButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return FloatingActionButton(
        heroTag: "btn22",
        backgroundColor: Colors.grey,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            await _controller.takePicture(path);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: path,
                    userName: model.employeeInformation.empName,
                    model: widget.model,
                  ),
                ));
          } catch (e) {
            print(e);
          }
        },
        child: Icon(
          Icons.camera_alt,
          color: Theme.of(context).buttonColor,
        ),
      );
    });
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String userName;
  final MainModel model;

  const DisplayPictureScreen(
      {Key key, this.userName, this.imagePath, this.model})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends BaseState<DisplayPictureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String img;
  File file;
  bool _processImage = false;

  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  Location _locationService = new Location();
  bool _permission = false;
  String error;

//  Map<String, dynamic> reasonData;
  List<dynamic> reasonData;
  Map<int, dynamic> _reasons;
  int selectedValue;

//  MediaQueryData queryData;

  @override
  void initState() {
    widget.model.fetchAttendanceRequestReasons();
    reasonData = [];
    _reasons = new Map();
    super.initState();
    getImage();
  }


  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 100);

    var location = new Location();
    try {
      _currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
  }

  slowRefresh() async {
//    _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        setState(() {
          _currentLocation = result;
        });
      }
    });
  }

  Future getImage() async {
    file = await FlutterExifRotation.rotateImage(
      path: widget.imagePath,
    );
    if (file != null) {
      setState(() {
        img = file.path;
      });
    }
//    }
  }

  bool isLocationFound = false;

  List<DropdownMenuItem> _menuItems(Map<dynamic, dynamic> items) {
    List<DropdownMenuItem> itemWidgets = List();
    items.forEach((k, v) {
      itemWidgets.add(DropdownMenuItem(
        value: k,
        child: Text(v.toString()),
      ));
    });
    return itemWidgets;
  }

  _buildReasonDropdown() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context,Widget child,MainModel model){
          return DropdownButton(
            hint: Text(
              'Select reason (optional)',
              style: TextStyle(fontSize: 15.0),
            ),
            // Not necessary for Option 1
            value: selectedValue,
            elevation: 3,
            onChanged: (newValue) {
              selectedValue = newValue;
              print(selectedValue.toString());
            },
            items: _menuItems(model.attendanceRequestReasons),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context,Widget chilt,MainModel model){
        return !_processImage
            ? Scaffold(
          appBar: AppBar(
            title: Text('Confirm attendance'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/dashboard'),
            ),
          ),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 4 / 10,
                    child: Center(
                      child: Image.file(File(widget.imagePath)),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 1.5 / 10,
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Center(
                      child: Text(
                        widget.userName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 30.0),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildReasonDropdown(),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 4 / 5,
                      height: MediaQuery.of(context).size.height * .8 / 10,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(3, 3))
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Material(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.0)),
                          color: Theme.of(context).buttonColor,
                          child: InkWell(
                              onTap: _processImage
                                  ? null
                                  : () async {
                                await initPlatformState();
                                if (_currentLocation == null) {
                                  Toast.show(
                                      'Please turn on gps location and try again',
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                } else {
                                  slowRefresh();
                                  _submitForm(model.createAttendance,model.updateSelfie);
                                }
                              },
                              child: Center(
                                child: Text('Confirm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                              )))),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2 / 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 4 / 5,
                      height: MediaQuery.of(context).size.height * .8 / 10,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    1.9 /
                                    5,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        offset: Offset(3, 3))
                                  ],
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Material(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: Theme.of(context).buttonColor,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(
                                          child: Text('Another selfie',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        )))),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    1.9 /
                                    5,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        offset: Offset(3, 3))
                                  ],
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Material(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: Theme.of(context).buttonColor,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/dashboard');
                                        },
                                        child: Center(
                                          child: Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ))))
                          ])),
                ],
              )),
        )
            : Scaffold(
          appBar: AppBar(
            title: Text('Confirm attendance'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushNamed(context, '/dashboard')),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );

  }

  void _submitForm(Function createAttendance,Function updateSelfie) {
    FormData data = FormData();
    FormData selfieData = FormData();
    selfieData.add('selfie', UploadFileInfo(file, 'test.png'));

    if (selectedValue != null) {
      data = new FormData.from({
        'did': '10',
        'lng': _currentLocation.longitude.toString(),
        'lat': _currentLocation.latitude.toString(),
        'request_reason': selectedValue.toString(),
      });
    } else {
      data = new FormData.from({
        'did': '10',
        'lng': _currentLocation.longitude.toString(),
        'lat': _currentLocation.latitude.toString(),
      });
    }
    createAttendance(data).then((Map<String,dynamic> response) {
      if (response['success']) {
          Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          updateSelfie(response['id'],selfieData);
          Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Toast.show(response['message'], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.pushReplacementNamed(context, '/dashboard');
//        showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return AlertDialog(
//                title: Text('Something went wrong'),
//                content: Text('Please try again!'),
//                actions: <Widget>[
//                  FlatButton(
//                    onPressed: () => Navigator.of(context).pop(),
//                    child: Text('Okay'),
//                  )
//                ],
//              );
//            });
      }
    });
  }
}
