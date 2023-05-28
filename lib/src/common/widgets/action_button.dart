import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool filled;

  const ActionButton({
    required this.title,
    required this.onPressed,
    bool? filled,
    Key? key,
  })  : this.filled = filled ?? true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: filled ? CustomColors.primary : CustomColors.background,
          border: !filled
              ? Border.all(
                  color: CustomColors.primary,
                  width: 3,
                )
              : null),
      child: Text(
        title,
        style: TextStyle(
            color: filled ? CustomColors.background : CustomColors.primary,
            fontSize: 20.0,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
