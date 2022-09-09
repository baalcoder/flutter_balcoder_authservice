import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/screen/signup_screen.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/service/auth.service.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/dialog/failed_login.dart';
import 'package:flutter_balcoder_verdorcompany/utils/components/default_button.dart';
import 'package:flutter_balcoder_verdorcompany/utils/constant.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.auth, required this.onSignedIn})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  GlobalKey _formKey = GlobalKey();

  bool _obscureTextLogin = true;
  bool _isLoading = false;
  bool isRememberPassword = false;
  late String _errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

// Perform login or signup
  void _validateAndSubmit(context) async {
    print("ENTRAMOS");
    setState(() {
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userId = "";
      print("ACA");
      try {
        userId = await widget.auth
            .signIn(loginEmailController.text, loginPasswordController.text);
        print('Signed in: $userId');

        if (userId != null && userId.length > 0) {
          widget.onSignedIn();
          Navigator.of(context).pop();
        }
      } catch (e) {
        print(e);
        print("NEED INFO");
        return showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => FailedLoginDialog());
      }
    } else {
      print("NEED INFO");
      return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => FailedLoginDialog());
      // setState(() {
      //   _errorMessage = "Necesitamos más información...";

      //   _isLoading = false;
      // });
    }
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (loginEmailController.text.isNotEmpty &&
        loginPasswordController.text.isNotEmpty) {
      var email = loginEmailController.text;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (emailValid) {
        // form.save();
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        shadowColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Container(
        height: _height,
        child: Stack(
          children: [
            Container(
              height: _height * 0.4,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(120, 30),
                      bottomRight: Radius.elliptical(120, 30))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60.0,
                      bottom: 56.0,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8),
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45.0,
                            backgroundImage: AssetImage(
                              "assets/images/logo_white.png",
                            )),
                      ),
                    ),
                  ),
                  Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // light
                        color: kPrimaryLightColor),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Por favor, ingresa tu información de contacto a continuación.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600, // light
                                  color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              controller: loginEmailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                                hintText: "micorreo@correo.com",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 17.0),
                              ),
                            ),
                          ),
                          !isRememberPassword
                              ? Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                )
                              : Container(),
                          !isRememberPassword
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 15.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextFormField(
                                    validator: (value) => value!.length >= 6
                                        ? 'mínimo 6 dígitos'
                                        : null,
                                    controller: loginPasswordController,
                                    obscureText: _obscureTextLogin,
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        size: 22.0,
                                        color: Colors.black,
                                      ),
                                      hintText: "Contraseña",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 17.0),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureTextLogin =
                                                !_obscureTextLogin;
                                          });
                                        },
                                        child: Icon(
                                          _obscureTextLogin
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            height: 36,
                            child: Row(
                              children: [
                                Spacer(),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        isRememberPassword =
                                            !isRememberPassword;
                                      });
                                    },
                                    child: Text(
                                      isRememberPassword
                                          ? "Volver"
                                          : "¿Olvidó su contraseña?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600, // light
                                          color: Colors.black54),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                      child: DefaultButton(
                          color: Color(0xFF000000),
                          text: isRememberPassword
                              ? "Restaurar"
                              : "Iniciar sesión",
                          press: () => isRememberPassword
                              ? _resetPassword()
                              : _validateAndSubmit(context))),
                ],
              ),
            ),
          ],
          alignment: Alignment.topCenter,
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SignupScreen(
                        auth: widget.auth,
                        onSignedIn: widget.onSignedIn,
                      )));
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            // child: SvgPicture.asset(
            //   "assets/images/login_footer.svg",
            //   height: 20.0,
            //   width: 149.0,
            //   fit: BoxFit.scaleDown,
            // ),
          ),
        ),
      ),
    );
  }

  _resetPassword() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (loginEmailController.text.isNotEmpty) {
      widget.auth
          .sendPasswordResetEmail(loginEmailController.text.toString())
          .then((value) => setState(() {
                isRememberPassword = false;

                // showDialog(
                //     barrierDismissible: false,
                //     context: context,
                //     builder: (_) => NetworkGiffyDialog(
                //           key: Key("NetworkDialog"),
                //           image: Image.network(
                //             'https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF\'s/gif7.gif',
                //             fit: BoxFit.cover,
                //           ),
                //           entryAnimation: EntryAnimation.TOP_LEFT,
                //           title: Text(
                //             'Contraseña Restablecida ',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //                 fontSize: 22.0, fontWeight: FontWeight.w600),
                //           ),
                //           description: Text(
                //             'Se han enviado las instrucciones para un efectivo restablecimiento de contraseña a su correo electrónico.',
                //             textAlign: TextAlign.center,
                //           ),
                //           buttonOkText: Text(
                //             'Ok',
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           onlyOkButton: true,
                //           onCancelButtonPressed: () {
                //             Navigator.pop(context);
                //           },
                //           onOkButtonPressed: () {
                //             Navigator.pop(context);
                //           },
                //         ));
              }));
    } else {
      return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => FailedLoginDialog());
    }
  }
}
