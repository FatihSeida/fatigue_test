import 'package:fatigue_tester/presentation/pages/page_result.dart';
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
    // final provider = Provider.of<FatigueTestProvider>(context, listen: false);
  }

  // final _isHours = true;

  // final StopWatchTimer _stopWatchTimer = StopWatchTimer(
  //   mode: StopWatchMode.countUp,
  //   onChange: (value) => debugPrint('onChange $value'),
  //   onChangeRawSecond: (value) => debugPrint('onChangeRawSecond $value'),
  //   onChangeRawMinute: (value) => debugPrint('onChangeRawMinute $value'),
  //   onStopped: () {
  //     debugPrint('onStop');
  //   },
  //   onEnded: () {
  //     debugPrint('onEnded');
  //   },
  // );

  // @override
  // void initState() {
  //   super.initState();
  //   _stopWatchTimer.rawTime.listen((value) =>
  //       debugPrint('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
  //   _stopWatchTimer.minuteTime
  //       .listen((value) => debugPrint('minuteTime $value'));
  //   _stopWatchTimer.secondTime
  //       .listen((value) => debugPrint('secondTime $value'));
  //   _stopWatchTimer.records.listen((value) => debugPrint('records $value'));
  //   _stopWatchTimer.fetchStopped
  //       .listen((value) => debugPrint('stopped from stream'));
  //   _stopWatchTimer.fetchEnded
  //       .listen((value) => debugPrint('ended from stream'));
  // }

  // @override
  // void dispose() async {
  //   super.dispose();
  //   await _stopWatchTimer.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FatigueTestProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.xl),
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Insets.lg),
              child: Icon(
                FatigueTest.dialpad,
                color: FTColor.red,
                size: 32.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.med),
              child: Text(
                'Urutkan nomor 1-20 berikut ini secepat yang anda bisa',
                style: TextStyles.text16Bold,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: StreamBuilder<int>(
                stream: provider.stopWatchTimer.rawTime,
                initialData: provider.stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: provider.isHours);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: TextStyles.text20Bold,
                        ),
                      ),
                    ],
                  );
                },
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

            /// Button
            Padding(
              padding: EdgeInsets.only(top: Insets.med),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () async {
                        await provider.startStopWatch();
                        // .then((_) {
                        //   if (!mounted) {
                        //     return;
                        //   }
                        //   if (provider.play == false && provider.same == true) {
                        //     Navigator.of(context)
                        //         .pushNamed(ResultPage.routeName);
                        //   }
                        // });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: FTColor.red, // <-- Button color
                        foregroundColor: Colors.white, // <-- Splash color
                      ),
                      child: Icon(provider.play == false
                          ? Icons.play_arrow
                          : Icons.pause),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        provider.resetTime();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: FTColor.red, // <-- Button color
                        foregroundColor: Colors.white, // <-- Splash color
                      ),
                      child: Icon(Icons.stop),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
