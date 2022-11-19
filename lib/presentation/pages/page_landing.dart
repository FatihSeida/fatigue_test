import 'package:fatigue_tester/data/common/constant/fatigue_test_icons.dart';
import 'package:fatigue_tester/data/common/enum/enum_status_test.dart';
import 'package:fatigue_tester/data/model/result_test.dart';
import 'package:fatigue_tester/presentation/pages/page_detail_result.dart';
import 'package:fatigue_tester/presentation/pages/page_fatigue_test.dart';
import 'package:fatigue_tester/presentation/pages/page_history_test.dart';
import 'package:fatigue_tester/presentation/providers/provider_auth.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:fatigue_tester/presentation/widgets/button/button_default.dart';
import 'package:fatigue_tester/presentation/widgets/card/widget_driver_result.dart';
import 'package:fatigue_tester/presentation/widgets/etc/widget_appbar.dart';
import 'package:fatigue_tester/presentation/widgets/text/widget_information_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/common/constant/assets.dart';
import '../../data/common/constant/authentication.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';
import '../../data/model/user.dart';
import '../widgets/button/button_picker.dart';
import '../widgets/input/text_form_field_text.dart';
import '../widgets/text/widget_status_driver.dart';

class LandingPage extends StatelessWidget {
  static const routeName = '/landing';
  const LandingPage({Key? key}) : super(key: key);

  Future<void> showMessage(
      bool success, String message, BuildContext context) async {
    showTopSnackBar(
      context,
      success
          ? CustomSnackBar.success(
              message: message,
            )
          : CustomSnackBar.error(
              message: message,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    context.read<FatigueTestProvider>().initData();
    return Consumer<FatigueTestProvider>(
      builder: (_, ftProvider, __) => Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  provider.user!.unit == 'Head Office'
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                          child: ListTile(
                            leading:
                                const Icon(Icons.download, color: FTColor.red),
                            title: Text(
                              'Unduh Data',
                              style: TextStyles.text14Bold,
                            ),
                            onTap: () {
                              ftProvider.getCsv();
                              showMessage(
                                  true, 'Data Berhasil Diunduh', context);
                            },
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                          child: ListTile(
                            leading: const Icon(FatigueTest.listAlt,
                                color: FTColor.red),
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
          title: Image.asset(Assets.logo, height: 40.h),
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(
                  FatigueTest.drawer,
                  color: Colors.black,
                )),
          ),
          actions: provider.user!.unit == 'Head Office'
              ? [
                  IconButton(
                      onPressed: () {
                        ftProvider.getModal(context);
                      },
                      icon: Icon(FatigueTest.filter))
                ]
              : [],
        ),
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
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
                              image:
                                  AssetImage(Assets.containerBackgroundImage),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                  provider.user!.unit == "Head Office"
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Insets.med),
                              child: Text(
                                'Daftar Hasil Test Driver',
                                style: TextStyles.text20Bold,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: Insets.med),
                                  child: DriverResult(
                                    user: ftProvider.listUser.singleWhere(
                                      (element) =>
                                          element!.nik ==
                                          ftProvider
                                              .resultTest[index].nikDriver,
                                      orElse: () =>
                                          User(name: '', nik: '', unit: ''),
                                    ),
                                    resultTest: ftProvider.resultTest[index],
                                  ),
                                );
                              },
                              itemCount: ftProvider.resultTest.length,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                style: TextStyles.text14
                                    .copyWith(color: FTColor.grey),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 45.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Insets.xxl),
                                child: Row(
                                  children: [
                                    ButtonDefault(
                                        title: 'Mulai Test',
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              FatigueTestPage.routeName);
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
                                    style: TextStyles.text12
                                        .copyWith(color: FTColor.grey),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                ],
              ),
            )),
      ),
    );
  }
}

class StatusTestFilterItem extends StatelessWidget {
  const StatusTestFilterItem({
    Key? key,
    required this.function,
    required this.title,
    required this.selected,
  }) : super(key: key);

  final bool selected;
  final Function() function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Insets.med),
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: FTStyle.coloredBorder(
                  color: selected ? FTColor.green : FTColor.greyColorBorder)
              .copyWith(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Insets.xs, vertical: Insets.med),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Insets.med),
                  child: selected
                      ? Icon(
                          Icons.trip_origin,
                          color: FTColor.green,
                        )
                      : Icon(Icons.panorama_fish_eye),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Insets.med,
                  ),
                  child: Text(
                    title,
                    style: TextStyles.text12.copyWith(
                        color: selected ? FTColor.green : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DriverResult extends StatelessWidget {
  const DriverResult({
    Key? key,
    required this.user,
    required this.resultTest,
  }) : super(key: key);

  final User? user;
  final ResultTest resultTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FTStyle.coloredBorder(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: Insets.med,
                      ),
                      child:
                          StatusTestWidget(statusTest: resultTest.statusTest),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Insets.med,
                      ),
                      child: InformationItem(
                          title: 'Tanggal Pengujian',
                          value: DateFormat('EEE, dd MMM yyyy')
                              .format(resultTest.dateCreated)),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: Insets.med,
                      ),
                      child: InformationItem(
                          title: 'Nomor Penguji',
                          value: "${resultTest.testNumber}"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Insets.med,
                      ),
                      child: InformationItem(
                          title: 'Nama Driver', value: user!.name),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Insets.med),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: FTColor.red,
                            elevation: 0,
                            side: BorderSide(width: 1.0, color: FTColor.red),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              DetailResultPage.routeName,
                              arguments: {'test': resultTest, 'user': user},
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FatigueTest.detail),
                              Text('Detail')
                            ],
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
