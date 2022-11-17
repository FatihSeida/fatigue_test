import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/assets.dart';
import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';
import '../../../data/model/result_test.dart';
import '../../providers/provider_fatigue_test.dart';
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
    return Consumer<FatigueTestProvider>(
      builder: (_, ftProvider, __) => Padding(
        padding: EdgeInsets.only(top: Insets.xl),
        child: Container(
          decoration: FTStyle.coloredBorder(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: FTColor.red,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image:
                                  AssetImage(Assets.containerBackgroundImage),
                              fit: BoxFit.cover)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Insets.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: Insets.xl),
                              child: InkWell(
                                onTap: () {
                                  ftProvider.deleteData(ftProvider.user!.nik,
                                      resultTest.testNumber);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
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
                            value: StopWatchTimer.getDisplayTime(
                                resultTest.result,
                                hours: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Insets.med, bottom: Insets.med),
                          child: InformationItemRed(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Insets.lg),
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
                              value:
                                  DateFormat.Hm().format(resultTest.sleepDate),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: Insets.med),
                            child: InformationItem(
                              title: 'Waktu Bangun',
                              value:
                                  DateFormat.Hm().format(resultTest.wakeupDate),
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
                            padding: EdgeInsets.only(
                                top: Insets.med, bottom: Insets.med),
                            child: StatusTestWidget(
                                statusTest: resultTest.statusTest),
                          ),
                        ],
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
