import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../data/common/constant/styles.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/fatigue_test_icons.dart';

class FatigueTestForm3 extends StatefulWidget {
  const FatigueTestForm3({
    Key? key,
  }) : super(key: key);

  @override
  State<FatigueTestForm3> createState() => _FatigueTestForm3State();
}

class _FatigueTestForm3State extends State<FatigueTestForm3> {
  @override
  void initState() {
    super.initState();
    Provider.of<FatigueTestProvider>(context, listen: false).initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FatigueTestProvider>(
      builder: (_, provider, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.xl),
        child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: provider.isReady
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Insets.lg),
                        child: Text(
                          'Urutkan nomor 1 - 20 berikut ini',
                          style: TextStyles.text20Bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: Insets.med),
                          child: ReorderableGridView.extent(
                            physics: const NeverScrollableScrollPhysics(),
                            onReorder: provider.onReorder,
                            shrinkWrap: true,
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 1,
                            children: provider.shuffleItems.map((item) {
                              return ReorderableGridDragStartListener(
                                key: ValueKey(item),
                                index: item,
                                child: Padding(
                                  key: ValueKey(item),
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    decoration: FTStyle.coloredBorder(),
                                    child: Padding(
                                      padding: EdgeInsets.all(Insets.med),
                                      child: Center(
                                        child: Text(
                                          "${item + 1}",
                                          style: TextStyles.text20Bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Insets.xl),
                        child: Icon(
                          FatigueTest.dialpad,
                          color: FTColor.red,
                          size: 32.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.lg),
                        child: Text(
                          'Urutkan nomor 1-20 berikut ini secepat yang anda bisa',
                          style: TextStyles.text20Bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.xxl),
                        child: Text(
                          'Test akan segera dimulai',
                          style: TextStyles.text20Bold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: StreamBuilder<int>(
                          stream: provider.countdown.rawTime,
                          initialData: provider.countdown.rawTime.value,
                          builder: (context, snap) {
                            final value = snap.data!;
                            final displayTime = StopWatchTimer.getDisplayTime(
                                value,
                                hours: false,
                                minute: false,
                                milliSecond: false);
                            return Column(
                              children: <Widget>[
                                Text(
                                  displayTime,
                                  style: TextStyles.text20Bold
                                      .copyWith(fontSize: 100.h),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.med),
                        child: ElevatedButton(
                          onPressed: () {
                            provider.startTest();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            backgroundColor: FTColor.red, // <-- Button color
                            foregroundColor: Colors.white, // <-- Splash color
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Insets.xxl, vertical: Insets.sm),
                            child: Text(
                              'Mulai',
                              style: TextStyles.text14Bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Insets.xl),
                        child: Text(
                          'Anda bisa mengulang test dengan menekan tombol kembalu lalu menekan tombol selanjutnya',
                          style: TextStyles.text14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
