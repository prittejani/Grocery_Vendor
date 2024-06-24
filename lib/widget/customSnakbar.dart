import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void CustomAlertDialog(
    {required context, required title, required message, required btnText}) async {
  return showCupertinoDialog(
      context: context,
      builder: (context)
      =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(btnText,style: TextStyle(color: Colors.green),),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ));
}
class customWidget
{
  static customSnackbar({
    required suberrorTitle,
    required errorTitle,
    required icon,
    required iconColor,
    required errorTitleColor,
    required backgroundColor,
  }) {
    return Get.snackbar(
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            '${errorTitle}',
            style: TextStyle(
                color: errorTitleColor, fontSize: 25, fontFamily: 'Poppins'),
          )
        ],
      ),
      '',
      "${suberrorTitle}",
      backgroundColor: backgroundColor,
    );
  }
}