import 'package:fatigue_tester/presentation/pages/page_landing.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';
import '../widgets/button/button_default.dart';
import '../widgets/card/widget_result.dart';

class ResultPage extends StatelessWidget {
  static const routeName = '/result';
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FatigueTestProvider>(context);
    context.read<FatigueTestProvider>().context = context;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            image: DecorationImage(
                alignment: Alignment.center,
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.xl),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: Text(
                  'Hasil Pengujian',
                  style: TextStyles.text20Bold.copyWith(color: FTColor.red),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Insets.xl),
                child: Text(
                  'Berikut adalah hasil dari pengujian yang sudah dilakukan',
                  style: TextStyles.text14.copyWith(color: FTColor.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Insets.xl),
                child: ResultWidget(
                  resultTest: provider.lastResultTest,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Insets.xxl, horizontal: Insets.xxl),
                child: Row(
                  children: [
                    ButtonDefault(
                        title: 'OK',
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              LandingPage.routeName,
                              (Route<dynamic> route) => false);
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
