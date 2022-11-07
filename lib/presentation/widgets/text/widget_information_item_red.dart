import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:flutter/material.dart';

import '../../../data/common/constant/styles.dart';

class InformationItemRed extends StatelessWidget {
  const InformationItemRed({
    Key? key,
     this.title,
     this.value,
  }) : super(key: key);

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return title == null && value == null
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          )
        : SizedBox(
            height: size.height * 0.06,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyles.text12.copyWith(color: FTColor.grey),
                ),
                Text(
                  value!,
                  style: TextStyles.text14Bold.copyWith(color: FTColor.red),
                ),
              ],
            ),
          );
  }
}
