import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:fatigue_tester/data/common/constant/fatigue_test_icons.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/common/constant/styles.dart';

import '../widgets/button/button_picker.dart';

class FatigueTestForm extends StatelessWidget {
  const FatigueTestForm({
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
                FatigueTest.kingBed,
                color: FTColor.red,
                size: 32.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.med),
              child: Text(
                'Kapan dan jam berapa Anda terakhir tidur?',
                style: TextStyles.text20Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xxl),
              child: PickerButton(
                title: 'Tanggal',
                icon: Icon(FatigueTest.calendarOutlilne),
                value: provider.selectedDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('dd/MM/yyyy')
                        .format(provider.selectedDate as DateTime),
                function: () => provider.selectDate(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: PickerButton(
                title: 'Waktu',
                icon: Icon(Icons.alarm),
                value: provider.selectedTimeSleep == null
                    ? 'Pilih Waktu'
                    : provider.selectedTimeSleep!.format(context),
                function: () => provider.selectTime(context),
              ),
            ),
            verticalSpace(Sizes.lg)
          ],
        ),
      ),
    );
  }
}
