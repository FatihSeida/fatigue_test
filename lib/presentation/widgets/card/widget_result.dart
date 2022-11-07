import 'package:flutter/material.dart';

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
    var duration = Duration(seconds: resultTest.result);
    return Container(
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
                            '$duration',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Nomor Pengujian',
                        value: '${resultTest.idTest}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: InformationItem(
                        title: 'Tanggal Tidur',
                        value: 'Mon, 25 Aug 2021',
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: Insets.med, bottom: Insets.med),
                      child: InformationItem(
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
                        child: InformationItem(
                          title: 'Tanggal Pengujian',
                          value: 'Thu, 26 Aug 2021',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: InformationItem(
                          title: 'Waktu Tidur',
                          value: '21.00',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Insets.med, bottom: Insets.med),
                        child: InformationItemRed(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: FTColor.red,
                      image: DecorationImage(
                          image: AssetImage(Assets.containerBackgroundImage),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Insets.med),
                      child: Column(
                        children: [
                          Text(
                            'Status Driver',
                            style:
                                TextStyles.text12.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Unsafe',
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
