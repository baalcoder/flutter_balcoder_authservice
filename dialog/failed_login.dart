import 'package:flutter/material.dart';
import 'package:flutter_balcoder_verdorcompany/utils/constant.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class FailedLoginDialog extends StatefulWidget {
  @override
  _FailedLoginDialogState createState() => _FailedLoginDialogState();
}

class _FailedLoginDialogState extends State<FailedLoginDialog> {
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
                  '¡Hubo un error!',
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
                    'Por favor ingrese correctamente todos los datos.',
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
                  'Y vuelve a intertar nuevamente.',
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
