import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:fatigue_tester/data/common/constant/styles.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';

import '../../data/common/constant/fatigue_test_icons.dart';
import '../widgets/card/history_testing_with_status.dart';
import '../widgets/card/history_testing_wo_status.dart';
import '../widgets/etc/widget_appbar.dart';

class HistoryTestPage extends StatelessWidget {
  static const routeName = '/history-test';
  const HistoryTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FatigueTestProvider>(
      builder: (_, ftProvider, __) => Scaffold(
        appBar: FTAppBar(
            actions: [
              IconButton(
                  onPressed: () async {
                    DateTime? newDateTime = await showRoundedDatePicker(
                        borderRadius: 0,
                        textActionButton: 'RESET',
                        onTapActionButton: () {},
                        context: context,
                        styleDatePicker: MaterialRoundedDatePickerStyle(
                            textStyleDayButton: TextStyles.text16Bold
                                .copyWith(color: Colors.black),
                            textStyleYearButton: TextStyles.text16Bold
                                .copyWith(color: Colors.white),
                            textStyleDayHeader: TextStyles.text16Bold
                                .copyWith(color: Colors.black),
                            textStyleCurrentDayOnCalendar: TextStyles.text14Bold
                                .copyWith(color: Colors.white),
                            textStyleDayOnCalendar:
                                TextStyles.text14.copyWith(color: Colors.black),
                            textStyleDayOnCalendarSelected: TextStyles.text14Bold
                                .copyWith(color: Colors.white),
                            textStyleDayOnCalendarDisabled: TextStyles.text16Bold
                                .copyWith(color: Colors.white.withOpacity(0.1)),
                            textStyleMonthYearHeader: TextStyles.text16Bold
                                .copyWith(color: Colors.black),
                            paddingDatePicker: const EdgeInsets.all(0),
                            paddingMonthHeader: const EdgeInsets.all(32),
                            paddingActionBar: const EdgeInsets.all(16),
                            paddingDateYearHeader: const EdgeInsets.all(32),
                            sizeArrow: 20,
                            colorArrowNext: Colors.black,
                            colorArrowPrevious: Colors.black,
                            marginLeftArrowPrevious: 16,
                            marginTopArrowPrevious: 16,
                            marginTopArrowNext: 16,
                            marginRightArrowNext: 32,
                            textStyleButtonAction: TextStyles.text16Bold
                                .copyWith(color: Colors.white),
                            textStyleButtonPositive: TextStyles.text16Bold
                                .copyWith(color: Colors.white),
                            textStyleButtonNegative: TextStyles.text16Bold
                                .copyWith(color: Colors.white.withOpacity(0.5)),
                            decorationDateSelected: const BoxDecoration(color: FTColor.red, shape: BoxShape.rectangle),
                            backgroundPicker: Colors.white,
                            backgroundActionBar: FTColor.red,
                            backgroundHeaderMonth: Colors.white,
                            backgroundHeader: FTColor.red),
                        styleYearPicker: MaterialRoundedYearPickerStyle(
                          textStyleYear: TextStyles.text16Bold
                              .copyWith(color: Colors.white, fontSize: 50),
                          textStyleYearSelected: TextStyles.text16Bold
                              .copyWith(color: Colors.white, fontSize: 50),
                          heightYearRow: 100,
                          backgroundPicker: FTColor.red,
                        ));
                  },
                  icon: const Icon(FatigueTest.calendarOutlilne))
            ],
            title: Text(
              'Riwayat Pengujian',
              style: TextStyles.text16Bold.copyWith(color: Colors.black),
            )),
        body: Padding(
          padding: EdgeInsets.only(
              left: Insets.xl, right: Insets.xl, top: Insets.med),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ftProvider.resultTest[index].statusTest.name ==
                      'notavailable'
                  ? HistoryTestingItem(resultTest: ftProvider.resultTest[index])
                  : HistoryTestingItemWithStatus(
                      resultTest: ftProvider.resultTest[index]);
            },
            itemCount: ftProvider.resultTest.length,
          ),
        ),
      ),
    );
  }
}
