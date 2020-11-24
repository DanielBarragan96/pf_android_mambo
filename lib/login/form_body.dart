import 'package:entregable_2/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormBody extends StatelessWidget {
  // cambiar a un solo value changed que reciba enum de login
  final ValueChanged<bool> onEmailLoginTap;
  final ValueChanged<bool> onGoogleLoginTap;

  FormBody({
    Key key,
    @required this.onEmailLoginTap,
    @required this.onGoogleLoginTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //TODO logo
        // Image.network(
        //   "https://www.gstatic.com/devrel-devsite/prod/v36e9b4a2fdc696650f09851e8c880b958655492821ded3455f80aaef87b6b52b/firebase/images/lockup.png?dcb_=0.4717481784324855",
        //   height: 256,
        //   width: 256,
        // ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Start discovering \nStart living",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
        ),
        SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () => onEmailLoginTap(true),
                  color: kLightPurple,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.user,
                        color: kWhite,
                      ),
                      SizedBox(width: 14),
                      Text(
                        "Log in with user",
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Expanded(
                child: GoogleSignInButton(
                  onPressed: () => onGoogleLoginTap(true),
                  text: "Log in with Google",
                  borderRadius: 18.0,
                  darkMode: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
