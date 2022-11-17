import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';
import '../../../data/common/enum/enum_status_test.dart';

class StatusTestWidget extends StatelessWidget {
  const StatusTestWidget({
    Key? key,
    required this.statusTest,
  }) : super(key: key);

  final StatusTest statusTest;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.06,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Driver',
            style: TextStyles.text12.copyWith(color: FTColor.grey),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7.h),
            child: Container(
              decoration: FTStyle.coloredContainer(
                  color: statusTest.name == 'buruburu'
                      ? FTColor.yellow
                      : statusTest.name == 'safe'
                          ? FTColor.green
                          : FTColor.lightRed),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                child: Text(
                  statusTest.name == 'buruburu'
                      ? 'Buru-Buru'
                      : statusTest.name == 'safe'
                          ? 'Safe'
                          : 'Unsafe',
                  style: TextStyles.text12Bold.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
