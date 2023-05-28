import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/common/widgets/action_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(56),
                  bottomRight: Radius.circular(56),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'edumet',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 70,
                        color: CustomColors.background,
                      ),
                    ),
                    Text(
                      'Platform of online learning',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: CustomColors.background,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionButton(
                    title: 'Join a meeting',
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          title: 'Login',
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: ActionButton(
                          title: 'Sign up',
                          filled: false,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
