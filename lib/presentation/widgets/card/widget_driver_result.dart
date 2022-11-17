import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/assets.dart';
import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';
import '../../../data/model/result_test.dart';
import '../../../data/model/user.dart';
import '../text/widget_information_item.dart';
import '../text/widget_information_item_red.dart';

class DriverResultDetailWidget extends StatelessWidget {
  const DriverResultDetailWidget({
    Key? key,
    required this.resultTes,
    required this.user,
  }) : super(key: key);

  final ResultTest resultTes;
  final User user;

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
                            StopWatchTimer.getDisplayTime(resultTes.result,
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
                        title: 'Nama Driver',
                        value: '${user.name}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Tanggal Tidur',
                        value: DateFormat('EEE, dd MMM yyyy')
                            .format(resultTes.sleepDate),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Waktu Tidur',
                        value: DateFormat.Hm().format(resultTes.sleepDate),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: InformationItem(
                        title: 'Tanggal Pengujian',
                        value: DateFormat('EEE, dd MMM yyyy')
                            .format(resultTes.dateCreated),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: Insets.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: InformationItem(
                          title: 'Nomor Pengujian',
                          value: '${resultTes.testNumber}',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: InformationItem(
                          title: 'Tanggal Bangun',
                          value: DateFormat('EEE, dd MMM yyyy')
                              .format(resultTes.wakeupDate),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: InformationItem(
                          title: 'Waktu Bangun',
                          value: DateFormat.Hm().format(resultTes.wakeupDate),
                        ),
                      ),
                      resultTes.rateTest == 0
                          ? Padding(
                              padding: EdgeInsets.only(top: Insets.med),
                              child: const InformationItemRed(),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: Insets.med, bottom: Insets.med),
                              child: InformationItemRed(
                                title: 'Rata-Rata Waktu',
                                value: StopWatchTimer.getDisplayTime(
                                    resultTes.rateTest,
                                    hours: true),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          resultTes.statusTest.name == 'notavailable'
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
                            color: resultTes.statusTest.name == 'buruburu'
                                ? FTColor.yellow
                                : resultTes.statusTest.name == 'safe'
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
                                  resultTes.statusTest.name == 'buruburu'
                                      ? 'Buru-Buru'
                                      : resultTes.statusTest.name == 'safe'
                                          ? 'Safe'
                                          : 'Unsafe',
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
