import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/assets.dart';
import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';
import '../../../data/model/result_test.dart';
import '../text/widget_information_item.dart';
import '../text/widget_information_item_red.dart';

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    Key? key,
    required this.resultTest,
  }) : super(key: key);

  final ResultTest resultTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FTStyle.coloredBorder(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                          image: AssetImage(Assets.containerBackgroundImage),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Insets.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Waktu Pengujian',
                          style:
                              TextStyles.text12.copyWith(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: Insets.xs),
                          child: Text(
                            StopWatchTimer.getDisplayTime(resultTest.result,
                                hours: true),
                            style:
                                TextStyles.textXl.copyWith(color: Colors.white),
                          ),
                        ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: InformationItem(
                        title: 'Waktu Tidur',
                        value: DateFormat.Hm().format(resultTest.sleepDate),
                      ),
                    ),
                    const InformationItemRed()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: Insets.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          title: 'Tanggal Bangun',
                          value: DateFormat('EEE, dd MMM yyyy')
                              .format(resultTest.wakeupDate),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: InformationItem(
                          title: 'Waktu Bangun',
                          value: DateFormat.Hm().format(resultTest.wakeupDate),
                        ),
                      ),
                      resultTest.rateTest == 0
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: Insets.med, bottom: Insets.med),
                              child: InformationItemRed(
                                title: 'Rata-Rata Waktu',
                                value: StopWatchTimer.getDisplayTime(
                                    resultTest.rateTest,
                                    hours: true),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          resultTest.statusTest.name == 'notavailable'
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: resultTest.statusTest.name == 'buruburu'
                                ? FTColor.yellow
                                : resultTest.statusTest.name == 'safe'
                                    ? FTColor.green
                                    : FTColor.lightRed,
                            image: const DecorationImage(
                                image:
                                    AssetImage(Assets.containerBackgroundImage),
                                fit: BoxFit.cover),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Insets.med),
                            child: Column(
                              children: [
                                Text(
                                  'Status Driver',
                                  style: TextStyles.text12
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  resultTest.statusTest.name == 'buruburu'
                                      ? 'Buru-Buru'
                                      : resultTest.statusTest.name == 'safe'
                                          ? 'safe'
                                          : 'unsafe',
                                  style: TextStyles.text16Bold
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          verticalSpace(Sizes.sm)
        ],
      ),
    );
  }
}
