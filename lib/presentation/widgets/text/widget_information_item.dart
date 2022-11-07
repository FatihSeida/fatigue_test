import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:flutter/material.dart';

import '../../../data/common/constant/styles.dart';

class InformationItem extends StatelessWidget {
  const InformationItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.06,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.text12.copyWith(color: FTColor.grey),
          ),
          Text(
            value,
            style: TextStyles.text14Bold,
          ),
        ],
      ),
    );
  }
}
