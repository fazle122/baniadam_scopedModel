import 'package:baniadam/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  MainModel model;

  SplashScreen(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  var token;
  var cID;

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('curr-user');
    cID = prefs.getString('curr-cid');
  }

  @override
  void initState() {
    _getUserInfo();
    widget.model.fetchUserAuthenticationInfo();
    widget.model.fetchCompanyId();
    _appRoute();
    super.initState();
  }

  _appRoute() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        widget.model.companyId.companyID != null
            ? widget.model.userAuthenticationInfo.token != null
                ? Navigator.pushReplacementNamed(context, '/dashboard')
                : Navigator.pushReplacementNamed(context, '/logIn')
            : Navigator.pushReplacementNamed(context, '/register');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Material(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Image(
                      width: 200.0,
                      image: AssetImage(
                        'assets/icons/BaniAdam-Logo_Final.png',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Text(
                      'version 1.0',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    Animation<Offset> leftToRight =
        Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);

    return new SlideTransition(
      position: leftToRight,
      child: child,
    );
  }
}
