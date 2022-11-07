import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:fatigue_tester/data/common/constant/styles.dart';
import 'package:fatigue_tester/data/common/enum/enum_status_test.dart';
import 'package:fatigue_tester/presentation/widgets/text/widget_status_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import '../../data/common/constant/fatigue_test_icons.dart';
import '../widgets/etc/widget_appbar.dart';
import '../widgets/text/widget_information_item.dart';
import '../widgets/text/widget_information_item_red.dart';

class HistoryTestPage extends StatelessWidget {
  static const routeName = '/history-test';
  const HistoryTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          decorationDateSelected:
                              const BoxDecoration(color: FTColor.red, shape: BoxShape.rectangle),
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
        padding:
            EdgeInsets.only(left: Insets.xl, right: Insets.xl, top: Insets.med),
        child: ListView(
          children: const [
            HistoryTestingItem(),
            HistoryTestingItemWithStatus()
          ],
        ),
      ),
    );
  }
}

class HistoryTestingItem extends StatelessWidget {
  const HistoryTestingItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Insets.xl),
      child: Container(
        decoration: FTStyle.coloredBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: const InformationItem(
                      title: 'Nomor Pengujian',
                      value: '09',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: const InformationItem(
                      title: 'Tanggal Tidur',
                      value: 'Mon, 25 Aug 2021',
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                    child: const InformationItem(
                      title: 'Waktu Bangun',
                      value: '06.30',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: Insets.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: const InformationItem(
                        title: 'Tanggal Pengujian',
                        value: 'Thu, 26 Aug 2021',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: const InformationItem(
                        title: 'Waktu Tidur',
                        value: '21.00',
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: const InformationItemRed(
                        title: 'Waktu Pengujian',
                        value: '00:00:40',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryTestingItemWithStatus extends StatelessWidget {
  const HistoryTestingItemWithStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Insets.xl),
      child: Container(
        decoration: FTStyle.coloredBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child:
                        const StatusTestWidget(statusTest: StatusTest.unsafe),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: const InformationItem(
                      title: 'Tanggal Pengujian',
                      value: 'Thu, 26 Aug 2021',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: const InformationItem(
                      title: 'Waktu Tidur',
                      value: '21.00',
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                    child: const InformationItemRed(
                      title: 'Waktu Pengujian',
                      value: '00:01:10',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: Insets.xxl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: const InformationItem(
                        title: 'Nomor Pengujian',
                        value: '09',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: const InformationItem(
                        title: 'Tanggal Tidur',
                        value: 'Mon, 25 Aug 2021',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: const InformationItem(
                        title: 'Waktu Bangun',
                        value: '06.30',
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: const InformationItemRed(
                        title: 'Rata - Rata Waktu',
                        value: '00:00:45',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
