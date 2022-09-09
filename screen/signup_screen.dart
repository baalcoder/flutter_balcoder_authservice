import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/model/user_model.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/screen/login_screen.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/service/auth.service.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/dialog/verify_email_dialog.dart';
import 'package:flutter_balcoder_verdorcompany/utils/components/default_button.dart';
import 'package:flutter_balcoder_verdorcompany/utils/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key, required this.auth, required this.onSignedIn})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  late bool _isIos;
  late String _errorMessage;
  bool _obscureTextLogin = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userId = "";
      print("ACA");
      try {
        userId = await widget.auth.signUp(
            signupEmailController.text.toLowerCase(),
            signupPasswordController.text);
        widget.auth.sendEmailVerification();

        UserModel userModel = new UserModel();

        userModel.uid = userId;
        userModel.name = "TEST TEST";
        userModel.lastName = '';
        userModel.phoneNumber = '';
        userModel.email = signupEmailController.text.toLowerCase();
        userModel.amountCoin = '0';
        userModel.createdDate = Timestamp.now();
        userModel.lastLogin = Timestamp.now();
        userModel.emailVerified = false;
        userModel.phoneVerified = false;
        userModel.isNew = true;
        userModel.isSubscribed = false;
        userModel.urlPhoto =
            'https://cdn.discordapp.com/attachments/546739213341687810/736398427566506034/Untitled-1.jpg';
        userModel.userType = 'Usuario';

        if (userId != null && userId.length > 0) {
          // widget.onSignedIn();

          await FirebaseFirestore.instance
              .collection('userCollection')
              .doc(userModel.uid)
              .set(userModel.toJson())
              .then((result) async {
            print("GUARDO user");
            widget.onSignedIn();
            Navigator.of(context).pop();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => MultiProvider(
            //               providers: [
            //                 Provider<LoginStore>(
            //                   create: (_) => LoginStore(),
            //                 )
            //               ],
            //               child: MaterialApp(
            //                 home: SplashPage(
            //                   auth: widget.auth,
            //                   userModel: userModel,
            //                   onSignedIn: widget.onSignedIn,
            //                 ),
            //               ),
            //             )));
          }).catchError((err) => print(err));

          print("MELO TENEMOS USERID");
        }
      } catch (e) {
        print("ERROR");
        print(e.toString());

        if (_isIos) {
          _errorMessage = e.toString();
          switch (e.toString()) {
            case 'Error 17011':
              _errorMessage = "No hay registro de este usuario.";
              break;
            case 'Error 17009':
              _errorMessage = "Contraseña incorrecta.";
              break;
            case 'Error 17020':
              _errorMessage = "Un error de conexión a la red.";
              break;
            // ...
            default:
              print('Case ${e.toString()} is not jet implemented');
          }
        } else
          _errorMessage = e.toString();
        switch (e.toString()) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            _errorMessage = "No hay registro de este usuario.";
            break;
          case 'The password is invalid or the user does not have a password.':
            _errorMessage = "La contraseña es incorrecta.";
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            _errorMessage = "Error de conexión a la red.";
            break;
          case 'The email address is badly formatted.':
            _errorMessage = "Correo electrónico no válido.";
            break;
          case 'The email address is already in use by another account.':
            _errorMessage =
                'La dirección de correo electrónico ya está siendo utilizada por otra cuenta.';
            break;
          case 'Password should be at least 6 characters':
            _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
            break;
          // ...
          default:
            print('Case ${e.toString()} is not jet implemented');
        }

        _scaffoldKey.currentState!.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            _errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        ));
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      print("NEED INFO");
      return showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => VerifyEmailDialog());
      // setState(() {
      //   _errorMessage = "Necesitamos más información...";

      //   _isLoading = false;
      // });
    }
  }

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (signupEmailController.text.isNotEmpty &&
        signupPasswordController.text.isNotEmpty) {
      var email = signupEmailController.text;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (emailValid) {
        form!.save();
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
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        shadowColor: kPrimaryColor,
        elevation: 0,
      ),
      body: Container(
        height: _height,
        width: _width,
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
                    'Regístrate para continuar',
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
                              'Por favor, completa los siguientes datos para acceder a nuestro servicio.',
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
                            child: TextFormField(
                              validator: (value) =>
                                  value!.isEmpty ? 'Campo Requerido' : null,
                              controller: signupEmailController,
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
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextFormField(
                              validator: (value) =>
                                  (value!.isEmpty && value.length >= 6)
                                      ? 'Campo Requerido'
                                      : null,
                              controller: signupPasswordController,
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
                                      _obscureTextLogin = !_obscureTextLogin;
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
                    child: DefaultButton(
                      color: Color(0xFF000000),
                      text: "Continuar",
                      press: _validateAndSubmit,
                    ),
                  ),
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
                  builder: (_) => LoginScreen(
                        auth: widget.auth,
                        onSignedIn: widget.onSignedIn,
                      )));
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            // child: SvgPicture.asset(
            //   "assets/images/sign_footer.svg",
            //   height: 20.0,
            //   width: 149.0,
            //   fit: BoxFit.scaleDown,
            // ),
          ),
        ),
      ),
    );
  }
}
