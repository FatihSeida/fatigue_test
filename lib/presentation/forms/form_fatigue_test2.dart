import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/common/constant/styles.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/fatigue_test_icons.dart';
import '../providers/provider_fatigue_test.dart';
import '../widgets/button/button_picker.dart';

class FatigueTestForm2 extends StatelessWidget {
  const FatigueTestForm2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FatigueTestProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.xl),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Insets.xxl),
              child: Icon(
                FatigueTest.alarmOn,
                color: FTColor.red,
                size: 32.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.med),
              child: Text(
                'Bangun jam berapa anda hari ini?',
                style: TextStyles.text20Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xxl),
              child: PickerButton(
                title: 'Tanggal',
                icon: Icon(FatigueTest.calendarOutline),
                value: provider.selectedDateWakeUp == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd/MM/yyyy')
                        .format(provider.selectedDateWakeUp as DateTime),
                function: () => provider.selectDateWakeUp(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: PickerButton(
                title: 'Waktu',
                icon: Icon(Icons.alarm),
                value: provider.selectedTimeWakeUp == null
                    ? 'Pilih Waktu'
                    : provider.selectedTimeWakeUp!.format(context),
                function: () => provider.selectTimeWakeUp(context),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: Insets.xl),
            //   child: SizedBox(
            //     height: MediaQuery.of(context).size.height * 0.2,
            //     child: CupertinoDatePicker(
            //       onDateTimeChanged: (time) {
            //         provider.selectedTimeWakeUp = time;
            //       },
            //       mode: CupertinoDatePickerMode.time,
            //     ),
            //   ),
            // ),
            verticalSpace(Sizes.lg)
          ],
        ),
      ),
    );
  }
}
