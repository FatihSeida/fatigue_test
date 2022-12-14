import 'package:fatigue_tester/presentation/forms/form_fatigue_test.dart';
import 'package:fatigue_tester/presentation/pages/page_result.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';
import '../forms/form_fatigue_test2.dart';
import '../forms/form_fatigue_test3.dart';
import '../providers/provider_fatigue_test.dart';
import '../widgets/etc/widget_appbar.dart';

class FatigueTestPage extends StatefulWidget {
  static const routeName = '/fatigue-test-form';

  const FatigueTestPage({Key? key}) : super(key: key);

  @override
  State<FatigueTestPage> createState() => _FatigueTestPageState();
}

class _FatigueTestPageState extends State<FatigueTestPage> {
  final _controller = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int pages = 1;
  double width = 0.13;

  @override
  Widget build(BuildContext context) {
    context.read<FatigueTestProvider>().context = context;
    List<Widget> fatiguePages = [
      FatigueTestForm(),
      FatigueTestForm2(),
      FatigueTestForm3(),
    ];
    return Consumer<FatigueTestProvider>(
      builder: (_, provider, __) => Scaffold(
          appBar: FTAppBar(
            leading: IconButton(
                onPressed: () {
                  if (pages == 3 || pages == 2) {
                    _controller.previousPage(
                        duration: _kDuration, curve: _kCurve);
                  } else {
                    provider.stopWatchTimer.onStopTimer();
                    provider.stopWatchTimer.onResetTimer();
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.chevron_left)),
            title: Text(
              '',
              style: TextStyles.text16Bold.copyWith(color: Colors.black),
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: PageView.builder(
                  onPageChanged: (page) {
                    provider.isReady = false;
                    provider.countdown.onStopTimer();
                    provider.countdown.onResetTimer();
                    provider.stopWatchTimer.onStopTimer();
                    provider.stopWatchTimer.onResetTimer();
                    setState(() {
                      pages = page + 1;
                      width = pages == 3 ? 0.5 : 0.05 + (pages / 10);
                    });
                  },
                  physics: NeverScrollableScrollPhysics(),
                  controller: _controller,
                  itemCount: fatiguePages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return fatiguePages[index % fatiguePages.length];
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Insets.xs),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                          child: Column(
                            children: [
                              Container(
                                height: 10,
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: FTStyle.coloredContainer(
                                    color: FTColor.grey),
                                child: Wrap(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: MediaQuery.of(context).size.width *
                                          width,
                                      decoration: FTStyle.coloredContainer(
                                          color: FTColor.red),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Step'),
                                  Text('$pages of ${fatiguePages.length}')
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                backgroundColor: pages == 3 && provider.equal
                                    ? FTColor.red
                                    : pages == 2 &&
                                            provider.selectedDateWakeUp !=
                                                null &&
                                            provider.selectedTimeWakeUp != null
                                        ? FTColor.red
                                        : pages == 1 &&
                                                provider.selectedDateSleep !=
                                                    null &&
                                                provider.selectedTimeSleep !=
                                                    null
                                            ? FTColor.red
                                            : FTColor.grey),
                            onPressed: () async {
                              if (pages == 1 || pages == 2) {
                                if (provider.selectedDateSleep != null &&
                                    provider.selectedTimeSleep != null) {
                                  _controller.nextPage(
                                      duration: _kDuration, curve: _kCurve);
                                }
                                if (provider.selectedDateWakeUp != null &&
                                    provider.selectedTimeWakeUp != null) {
                                  _controller.nextPage(
                                      duration: _kDuration, curve: _kCurve);
                                }
                              } else {
                                if (provider.equal) {
                                  await provider.sendResult().then((_) {
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.of(context)
                                        .pushNamed(ResultPage.routeName);
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Insets.xl),
                              child: Text(
                                pages == 1 || pages == 2
                                    ? 'Selanjutnya'
                                    : 'Selesai',
                                style: TextStyles.text12
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
