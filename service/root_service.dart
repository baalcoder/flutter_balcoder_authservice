import 'package:flutter/material.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/auth_screen.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/service/auth.service.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/model/user_model.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/root_screen.dart';
import 'package:provider/provider.dart';

class RootService extends StatefulWidget {
  RootService({required this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootServiceState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  NOT_PHONE_NUMBER,
  LOGGED_IN,
}

class _RootServiceState extends State<RootService> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  UserModel _userModel = new UserModel();

  @override
  void initState() {
    super.initState();
    _onLoggedIn();
  }

  _onLoggedIn() async {
    print("ACA");
    await widget.auth.getUser().then((user) {
      setState(() {
        print("USER");
        if (user != null) {
          _userModel = user;
          print("ACA ESTAMOS");
          print(_userModel.uid);

          authStatus = _userModel.uid == null
              ? AuthStatus.NOT_LOGGED_IN
              : AuthStatus.LOGGED_IN;
        } else {
          authStatus = AuthStatus.NOT_LOGGED_IN;
        }

        print(authStatus);
      });
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userModel = new UserModel();
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new AuthScreen(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userModel.uid != null && _userModel.uid!.length > 0) {
          return RootHomeScreen(
            userModel: _userModel,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
          );
        } else
          return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
