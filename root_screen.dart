import 'package:flutter/material.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/model/user_model.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/service/auth.service.dart';
import 'package:flutter_balcoder_verdorcompany/ui/drawer/verdor_drawer.dart';

import 'package:flutter_balcoder_verdorcompany/utils/constant.dart';

class RootHomeScreen extends StatefulWidget {
  RootHomeScreen(
      {Key? key, required this.auth, this.userModel, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback? onSignedOut;
  UserModel? userModel;
  @override
  _RootHomeScreenState createState() => _RootHomeScreenState();
}

class _RootHomeScreenState extends State<RootHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  bool isColorBlack = true;

  bool isAdmin = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isColorBlack = true;

    if (widget.userModel != null) {
      widget.userModel!.isSubscribed =
          widget.userModel!.isSubscribed != null ? true : false;

      print(widget.userModel!.isSubscribed);
    } else {
      getCurrentUserLogged();
    }
  }

  getCurrentUserLogged() async {
    await widget.auth.getUser().then((value) => setState(() {
          widget.userModel = value;
          print(widget.userModel!.uid!);
        }));
  }

  _onWillSingOut() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          'Salir',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, // light
              color: kTextColor),
        ),
        content: new Text(
          '¿Desea cerrar sesión?',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal, // light
              color: kTextColor),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal, // light
                  color: kTextColor),
            ),
          ),
          new FlatButton(
            onPressed: () async {
              Navigator.of(context).pop(false);
              try {
                await widget.auth.signOut();
                widget.onSignedOut!();
              } catch (e) {
                print(e);
                Navigator.of(context).popAndPushNamed('/');
              }
            },
            child: new Text(
              'Cerrar',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal, // light
                  color: kTextColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return widget.userModel != null
        ? new VerdorDrawer(
            userModel: widget.userModel!, onLogOut: _onWillSingOut)
        : Container();
  }
}
