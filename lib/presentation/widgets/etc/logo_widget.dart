import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: 'Fatigue',
          style: TextStyles.text20Bold.copyWith(fontWeight: FontWeight.w900)),
      TextSpan(
        text: 'Tester',
        style: TextStyles.text20,
        recognizer: TapGestureRecognizer()..onTap = () {},
      ),
    ], style: const TextStyle(color: FTColor.red)));
  }
}
