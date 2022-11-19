import 'package:fatigue_tester/data/common/constant/color.dart';
import 'package:fatigue_tester/data/common/constant/styles.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/card/history_testing_with_status.dart';
import '../widgets/card/history_testing_wo_status.dart';
import '../widgets/etc/widget_appbar.dart';

class HistoryTestPage extends StatelessWidget {
  static const routeName = '/history-test';
  const HistoryTestPage({Key? key}) : super(key: key);

  void handleClick(String value, BuildContext context,
      FatigueTestProvider ftProvider) async {
    switch (value) {
      case 'Filter':
        debugPrint('1');
        await ftProvider.selectDateFilter(context);
        await ftProvider.resultTestFiltered(
            null,
            null,
            ftProvider.selectedDateFilterStart,
            ftProvider.selectedDateFilterEnd);
        break;
      case 'Delete All':
        debugPrint('2');
        ftProvider.deleteAll(ftProvider.user!.nik);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FatigueTestProvider>(
      builder: (_, ftProvider, __) => Scaffold(
        appBar: FTAppBar(
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) => handleClick(value, context, ftProvider),
                itemBuilder: (BuildContext context) {
                  return {'Filter', 'Delete All'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            title: Text(
              'Riwayat Pengujian',
              style: TextStyles.text16Bold.copyWith(color: Colors.black),
            )),
        body: Padding(
          padding: EdgeInsets.only(
              left: Insets.xl, right: Insets.xl, top: Insets.med),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ftProvider.resultTest[index].statusTest.name ==
                      'notavailable'
                  ? HistoryTestingItem(resultTest: ftProvider.resultTest[index])
                  : HistoryTestingItemWithStatus(
                      resultTest: ftProvider.resultTest[index]);
            },
            itemCount: ftProvider.resultTest.length,
          ),
        ),
      ),
    );
  }
}
