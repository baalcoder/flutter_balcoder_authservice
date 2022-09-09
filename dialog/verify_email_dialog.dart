import 'package:flutter/material.dart';
import 'package:flutter_balcoder_verdorcompany/utils/constant.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class VerifyEmailDialog extends StatefulWidget {
  @override
  _VerifyEmailDialogState createState() => _VerifyEmailDialogState();
}

class _VerifyEmailDialogState extends State<VerifyEmailDialog> {
  TextEditingController keyNameController = TextEditingController();
  TextEditingController keyDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kPrimaryLightColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          height: 220,
          width: 340,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                Text(
                  '¡Verificación!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700, // light
                      color: kPrimaryColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Por favor verifique su correo electrónico.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal, // light
                        color: kPrimaryColor),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Y continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal, // light
                      color: kPrimaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
