import 'package:fatigue_tester/data/model/result_test.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/styles.dart';
import '../text/widget_information_item.dart';
import '../text/widget_information_item_red.dart';

class HistoryTestingItem extends StatelessWidget {
  const HistoryTestingItem({
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
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: InformationItemRed(
                        title: 'Waktu Pengujian',
                        value: StopWatchTimer.getDisplayTime(resultTest.result,
                            hours: true),
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
