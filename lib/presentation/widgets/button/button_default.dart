import 'package:flutter/material.dart';

import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';

class ButtonDefault extends StatelessWidget {
  ButtonDefault(
      {Key? key,
      required this.title,
      this.disable = false,
      required this.onTap})
      : super(key: key);

  final String title;
  final VoidCallback onTap;
  bool disable;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: Insets.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: FTColor.red,
        disabledColor: FTColor.grey,
        elevation: 0,
        onPressed: disable ? null : onTap,
        child: Text(
          title,
          style: TextStyles.text14.copyWith(
              color: disable ? FTColor.grey : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
  }
}
