import 'dart:async';
import 'dart:io';
import 'package:baniadam/scoped-models/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:access_settings_menu/access_settings_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show Random;


JsonEncoder encoder = new JsonEncoder.withIndent("     ");

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final MainModel model = MainModel();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isOnline = true;
  var token;
  var cID;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final notifications = FlutterLocalNotificationsPlugin();

  String notificationForSpecificUser;
  String notificationForAll = "ideaxen_all";
  String currentUserId = '34';
  String payloadData;
  Map<String, dynamic> notificationData;
  final List<Message> messages = [];

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var randomizer = new Random();
  String notificationTitle;

  String title = "Title";
  String helper = "helper";

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
        if (!isOnline) {
          showDialog(
            context: context,
            builder: (BuildContext context) => _connectionDialog(context),
          );
        } else {
//          Navigator.pushReplacementNamed(context, '/dashboard');

//          model.companyId.companyID != null
//              ? model.userAuthenticationInfo.token != null
//              ? Navigator.pushReplacementNamed(context, '/dashboard')
//              : Navigator.pushReplacementNamed(context, '/logIn')
//              : Navigator.pushReplacementNamed(context, '/register');

//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => cID != null
//                  ? token != null ? DashboardPage() : LogInPage()
//                  : RegisterPage(),
//            ),
//          );
        }
      }));
    });
  }

  Future<void> initConnectivity() async {
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    /// If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await updateConnectionStatus().then((bool isConnected) => setState(() {
      isOnline = isConnected;
    }));
  }



  _connectionDialog(context) {
    return AlertDialog(
      title: Center(
        child: Text('Internet interruption'),
      ),
      content: Text('No internet. Please check your internet connection.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Network setting'),
          onPressed: () {
            openSettingsMenu('ACTION_WIFI_SETTINGS');
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }

  openSettingsMenu(settingsName) async {
    var resultSettingsOpening = false;

    try {
      resultSettingsOpening =
      await AccessSettingsMenu.openSettings(settingsType: settingsName);
    } catch (e) {
      resultSettingsOpening = false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    _connectivitySubscription.pause();
    super.deactivate();
  }

  Future<bool> updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }
}

