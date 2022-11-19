import 'package:fatigue_tester/presentation/widgets/card/widget_driver_result.dart';
import 'package:flutter/material.dart';

import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';
import '../widgets/etc/widget_appbar.dart';

class DetailResultPage extends StatelessWidget {
  static const routeName = '/detail-result';
  const DetailResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
        appBar: FTAppBar(
          title: Text(
            'Detail Pengujian',
            style: TextStyles.text16Bold.copyWith(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.xl, vertical: Insets.xxl),
                child: Column(
                  children: [
                    DriverResultDetailWidget(
                      resultTes: arguments['test'],
                      user: arguments['user'],
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: FTColor.red,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: Insets.lg),
                            child: Text(
                              'Unduh Data Pengujian',
                              style: TextStyles.text12Bold
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
