import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/styles.dart';
import '../../../data/common/enum/enum_status_test.dart';
import '../../../data/model/result_test.dart';
import '../text/widget_information_item.dart';
import '../text/widget_information_item_red.dart';
import '../text/widget_status_driver.dart';

class HistoryTestingItemWithStatus extends StatelessWidget {
  const HistoryTestingItemWithStatus({
    Key? key,
    required this.resultTest,
  }) : super(key: key);

  final ResultTest resultTest;

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
                    child: InformationItem(
                      title: 'Nomor Pengujian',
                      value: '${resultTest.testNumber}',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: InformationItem(
                      title: 'Tanggal Tidur',
                      value: DateFormat('EEE, dd MMM yyyy')
                          .format(resultTest.sleepDate),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: InformationItem(
                      title: 'Tanggal Bangun',
                      value: DateFormat('EEE, dd MMM yyyy')
                          .format(resultTest.wakeupDate),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: InformationItemRed(
                      title: 'Waktu Pengujian',
                      value: StopWatchTimer.getDisplayTime(resultTest.result,
                          hours: true),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                    child: InformationItemRed(),
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
                      child: InformationItem(
                        title: 'Tanggal Pengujian',
                        value: DateFormat('EEE, dd MMM yyyy')
                            .format(resultTest.dateCreated),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Waktu Tidur',
                        value: DateFormat.Hm().format(resultTest.sleepDate),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Waktu Bangun',
                        value: DateFormat.Hm().format(resultTest.wakeupDate),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItemRed(
                        title: 'Rata - Rata Waktu',
                        value: StopWatchTimer.getDisplayTime(
                            resultTest.rateTest,
                            hours: true),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: StatusTestWidget(statusTest: resultTest.statusTest),
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
