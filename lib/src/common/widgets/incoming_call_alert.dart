import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

void showIncomingCallAlert(
  BuildContext context,
  String callerId, {
  required VoidCallback onTakeCall,
  required VoidCallback onRejectCall,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return IncomingCallDialogBox(
        callerId,
        onTakeCall: onTakeCall,
        onRejectCall: onRejectCall,
      );
    },
  );
}

class IncomingCallDialogBox extends StatefulWidget {
  final String callerId;
  final VoidCallback onTakeCall;
  final VoidCallback onRejectCall;
  const IncomingCallDialogBox(
    this.callerId, {
    required this.onTakeCall,
    required this.onRejectCall,
    Key? key,
  }) : super(key: key);

  @override
  _IncomingCallDialogBoxState createState() => _IncomingCallDialogBoxState();
}

class _IncomingCallDialogBoxState extends State<IncomingCallDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: CustomColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Входящий звонок',
                style: TextStyle(
                  color: CustomColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.callerId,
                style: TextStyle(
                  color: CustomColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: widget.onTakeCall,
                    child: Text(
                      'Принять',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.cancelCallColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      widget.onRejectCall();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Отклонить',
                      style: TextStyle(
                        color: CustomColors.background,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
