import 'package:fatigue_tester/data/common/constant/fatigue_test_icons.dart';
import 'package:fatigue_tester/presentation/pages/page_fatigue_test.dart';
import 'package:fatigue_tester/presentation/pages/page_history_test.dart';
import 'package:fatigue_tester/presentation/providers/provider_auth.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:fatigue_tester/presentation/widgets/button/button_default.dart';
import 'package:fatigue_tester/presentation/widgets/etc/widget_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/common/constant/assets.dart';
import '../../data/common/constant/authentication.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';

class LandingPage extends StatelessWidget {
  static const routeName = '/landing';
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    Provider.of<FatigueTestProvider>(context, listen: false).getData();
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Important: Remove any padding from the ListView
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(Assets.containerBackgroundImage),
                        fit: BoxFit.fitWidth),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Insets.xxl),
                        child: CircleAvatar(
                          maxRadius: 40.h,
                          backgroundImage: const AssetImage(
                              'assets/images/profile_avatar.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.lg),
                        child: Text(
                          provider.user!.name,
                          style: TextStyles.text20Bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.sm),
                        child: Text(
                          provider.user!.unit,
                          style:
                              TextStyles.text12.copyWith(color: FTColor.grey),
                        ),
                      )
                    ],
                  ),
                ),
                verticalSpace(Sizes.med),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: ListTile(
                    leading:
                        const Icon(FatigueTest.listAlt, color: FTColor.red),
                    title: Text(
                      'Riwayat Pengujian',
                      style: TextStyles.text14Bold,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(HistoryTestPage.routeName);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: ListTile(
                    leading:
                        const Icon(FatigueTest.helpDesk, color: FTColor.red),
                    title: Text(
                      'Bantuan',
                      style: TextStyles.text14Bold,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context
                          .read<AuthProvider>()
                          .setStatus(Authentication.unauthenticated);
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (route) => false);
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: FTColor.red),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Insets.lg, horizontal: Insets.xl),
                        child: Center(
                          child: Text(
                            'Keluar',
                            style: TextStyles.text14Bold
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: FTAppBar(
        title: SvgPicture.asset(Assets.logoSvg, height: 40.h),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                FatigueTest.drawer,
                color: Colors.black,
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: Text(
                'Hi, Selamat Datang',
                style: TextStyles.text16Bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xs),
              child: Text(
                provider.user!.name,
                style: TextStyles.text14.copyWith(color: FTColor.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: Container(
                decoration: FTStyle.coloredBorder().copyWith(
                    image: const DecorationImage(
                        image: AssetImage(Assets.containerBackgroundImage),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: EdgeInsets.all(Insets.xl),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.avatarHelper,
                        height: 82.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: Insets.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Utamakan keselamatan dalam bekerja',
                                style: TextStyles.text16Bold
                                    .copyWith(color: FTColor.red),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: Insets.med),
                                child: Text(
                                  'Keselamatan dimulai dari diri sendiri',
                                  style: TextStyles.text12
                                      .copyWith(color: FTColor.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: Text(
                'Kenapa keselamatan kerja itu penting?',
                style: TextStyles.text16Bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.xl),
              child: Text(
                'Upaya kita untuk menciptakan lingkungan kerja yang sehat dan aman, sehingga dapat mengurangi porbabilitas kecelakaan kerja / penyakit akibat kelalaian yang mengakibatkan demotivasi dan defisiensi produktifitas kerja.',
                style: TextStyles.text14.copyWith(color: FTColor.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 45.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.xxl),
                child: Row(
                  children: [
                    ButtonDefault(
                        title: 'Mulai Test',
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FatigueTestPage.routeName);
                        }),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Insets.lg),
                  child: Text(
                    'Tap tombol mulai, untuk melakukan Fatigue test',
                    style: TextStyles.text12.copyWith(color: FTColor.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
