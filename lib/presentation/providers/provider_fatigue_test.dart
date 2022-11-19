import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';

import 'package:external_path/external_path.dart';
import 'package:fatigue_tester/data/model/result_test.dart';
import 'package:fatigue_tester/presentation/pages/page_landing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../data/common/constant/color.dart';
import '../../data/common/constant/fatigue_test_icons.dart';
import '../../data/common/constant/styles.dart';
import '../../data/common/enum/enum_status_test.dart';
import '../../data/model/user.dart';
import '../../utils/db_helper.dart';
import '../widgets/dialog/loading_dialog.dart';

class FatigueTestProvider extends ChangeNotifier {
  User? user;

  FatigueTestProvider(this.user);

  final database = DatabaseSqflite().openDB();
  User userDriver = User(name: '', nik: '', unit: '');
  List<User?> listUser = [];
  Function eq = const ListEquality().equals;
  final comparingItems = List<int>.generate(20, (index) => index);
  final items = List<int>.generate(20, (index) => index);
  final isHours = true;
  final _loadingDialog = LoadingDialog();
  var play = false;
  late var shuffleItems = items;
  late bool same = false;
  late BuildContext _context;

  bool isReady = false;

  int pages = 1;
  double width = 0.13;

  DateTime? selectedDateSleep;
  TimeOfDay? selectedTimeSleep;
  DateTime? selectedDateWakeUp;
  TimeOfDay? selectedTimeWakeUp;
  int? testNumber;
  StatusTest statusTest = StatusTest.notavailable;

  DateTime? selectedDateFilterStart;
  DateTime? selectedDateFilterEnd;
  StatusTest? _selectedStatusTest = StatusTest.all;
  TextEditingController? driverNameFilter = TextEditingController();

  Future<void> setStatus(StatusTest statusTestFilterItem) async {
    _selectedStatusTest = statusTestFilterItem;
    notifyListeners();
  }

  StatusTest? get getStatusTest => _selectedStatusTest;

  Future<void> resultTestFiltered(
      String? nameFilter,
      StatusTest? statusTestFilter,
      DateTime? dateStart,
      DateTime? dateEnd) async {
    var userFilter;
    if (userFilter != null) {
      userFilter = listUser.singleWhere(
          (element) => element!.name == nameFilter,
          orElse: () => User(name: '', nik: '', unit: ''));
    }
    if (userFilter != null &&
        statusTestFilter != null &&
        dateStart != null &&
        dateEnd != null) {
      await getData();
      resultTest = resultTest
          .where((result) =>
              result.nikDriver == userFilter.nik && 
              result.statusTest == statusTestFilter &&
              dateStart.isBefore(result.dateCreated) &&
              dateEnd.isAfter(result.dateCreated))
          .toList();
      notifyListeners();
    } else if (userFilter != null &&
        statusTestFilter != null &&
        dateStart == null &&
        dateEnd == null) {
      await getData();
      resultTest = resultTest
          .where((result) =>
              result.nikDriver == userFilter.nik &&
              result.statusTest == statusTestFilter)
          .toList();
      notifyListeners();
    } else if (userFilter == null &&
        statusTestFilter != null &&
        dateStart != null &&
        dateEnd != null) {
      await getData();
      resultTest = resultTest
          .where((result) =>
              result.statusTest == statusTestFilter &&
              dateStart.isBefore(result.dateCreated) &&
              dateEnd.isAfter(result.dateCreated))
          .toList();
      notifyListeners();
    } else if (userFilter != null &&
        statusTestFilter == null &&
        dateStart != null &&
        dateEnd != null) {
      await getData();
      resultTest = resultTest
          .where((result) =>
              result.nikDriver == userFilter.nik &&
              dateStart.isBefore(result.dateCreated) &&
              dateEnd.isAfter(result.dateCreated))
          .toList();
      notifyListeners();
    } else if (userFilter != null &&
        statusTestFilter == null &&
        dateStart == null &&
        dateEnd == null) {
      await getData();
      resultTest = resultTest
          .where((result) => result.nikDriver == userFilter.nik)
          .toList();
      notifyListeners();
    } else if (userFilter == null &&
        statusTestFilter != null &&
        dateStart == null &&
        dateEnd == null) {
      await getData();
      resultTest = resultTest
          .where((result) => result.statusTest == statusTestFilter)
          .toList();
      notifyListeners();
    } else {
      await getData();
      resultTest = resultTest
          .where((result) =>
              dateStart!.isBefore(result.dateCreated) &&
              dateEnd!.isAfter(result.dateCreated))
          .toList();
      notifyListeners();
    }
  }

  List<ResultTest> resultTest = [];
  ResultTest lastResultTest = ResultTest(
      statusTest: StatusTest.notavailable,
      result: 0,
      idTest: 0,
      testNumber: 0,
      sleepDate: DateTime.now(),
      wakeupDate: DateTime.now(),
      dateCreated: DateTime.now(),
      rateTest: 0,
      nikDriver: '');

  int rateTest = 0;
  bool equal = false;

  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChangeRawSecond: (value) => debugPrint('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => debugPrint('onChangeRawMinute $value'),
    onStopped: () {
      debugPrint('onStop');
    },
    onEnded: () {
      debugPrint('onEnded');
    },
  );

  final StopWatchTimer countdown = StopWatchTimer(
    presetMillisecond: 5000,
    mode: StopWatchMode.countDown,
    onChangeRawSecond: (value) => debugPrint('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => debugPrint('onChangeRawMinute $value'),
    onStopped: () {
      debugPrint('onStop');
    },
    onEnded: () {
      debugPrint('onEnded');
    },
  );

  void getRateAndStatusTest() {
    var accumulate = 0;
    if (resultTest.length + 1 == 10) {
      for (var i = 0; i < resultTest.length; i++) {
        accumulate = accumulate + resultTest[i].result;
      }
      accumulate = accumulate ~/ resultTest.length;
      rateTest = accumulate;
      statusTest = StatusTest.safe;
    } else if (resultTest.length + 1 > 10) {
      for (var i = 0; i < resultTest.length; i++) {
        accumulate = accumulate + resultTest[i].result;
      }
      accumulate = accumulate ~/ resultTest.length;
      rateTest = accumulate;
      if (rateTest <= resultTest[9].rateTest - 2000) {
        statusTest = StatusTest.buruburu;
      } else if (rateTest >= resultTest[9].rateTest - 1999 &&
          rateTest <= resultTest[9].rateTest + 1999) {
        statusTest = StatusTest.safe;
      } else if (rateTest >= resultTest[9].rateTest + 2000) {
        statusTest = StatusTest.unsafe;
      } else {
        statusTest = StatusTest.notavailable;
      }
    } else {
      rateTest = 0;
      statusTest = StatusTest.notavailable;
    }
    notifyListeners();
  }

  void initState() {
    stopWatchTimer.fetchStopped
        .listen((value) => debugPrint('stopped from stream'));
    stopWatchTimer.fetchEnded
        .listen((value) => debugPrint('ended from stream'));

    countdown.fetchStopped
        .listen((value) => debugPrint('countdown stopped from stream'));
    countdown.fetchEnded
        .listen((value) => debugPrint('countdown ended from stream'));
  }

  Future<void> getCsv() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    List<List<dynamic>> rows = [];
    List<dynamic> row = [];

    row.add("id_test");
    row.add("name");
    row.add("nik_user");
    row.add("test_number");
    row.add("sleep_date");
    row.add("wakeup_date");
    row.add("result_test");
    row.add("rate_test");
    row.add("status_test");
    row.add("date_created");
    rows.add(row);

    for (var i = 0; i < resultTest.length; i++) {
      List<dynamic> row = [];
      var userr = listUser
          .singleWhere((element) => element!.nik == resultTest[i].nikDriver);

      row.add(resultTest[i].idTest);
      row.add(userr!.name);
      row.add(userr.nik);
      row.add(resultTest[i].testNumber);
      row.add(resultTest[i].sleepDate);
      row.add(resultTest[i].wakeupDate);
      row.add(resultTest[i].result);
      row.add(resultTest[i].rateTest);
      row.add(resultTest[i].statusTest);
      row.add(resultTest[i].dateCreated);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    String dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    debugPrint(dir);

    String pathDoc = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);
    debugPrint(pathDoc);
    String file = "$dir";
    File f = File(file + "/resulttest_${DateTime.now()}.csv");

    f.writeAsString(csv);
  }

  Future<void> initData() async {
    await getData();
    await getUserData();
    notifyListeners();
  }

  Future<void> setLoading(bool loading) async {
    loading ? _loadingDialog.show(_context) : _loadingDialog.hide();
  }

  set context(BuildContext context) => _context = context;
  set lastResultTestt(List<ResultTest> r) => lastResultTest = r[r.length - 1];

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
  }

  Future<void> clearData() async {
    selectedDateSleep = null;
    selectedTimeSleep = null;
    selectedDateWakeUp = null;
    selectedTimeWakeUp = null;
    selectedDateFilterStart = null;
    selectedDateFilterEnd = null;
    _selectedStatusTest = null;
    driverNameFilter = null;
    equal = false;
  }

  void onReorder(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    if (eq(comparingItems, shuffleItems) == true) {
      equal = true;
      debugPrint('$equal');
    }
    notifyListeners();
  }

  Future<void> setItems() async {
    shuffleItems.shuffle();
    notifyListeners();
  }

  Future<void> startTest() async {
    countdown.onStartTimer();
    await countdown.fetchEnded.listen((event) {
      if (event) {
        isReady = true;
        setItems();
        stopWatchTimer.onStartTimer();
        notifyListeners();
      }
    });
  }

  Future<void> sendResult() async {
    stopWatchTimer.onStopTimer();
    await sendData(
      nik: user!.nik,
      sleepDate: selectedDateSleep!,
      sleepTime: selectedTimeSleep!,
      wakeUpDate: selectedDateWakeUp!,
      wakeUpTime: selectedTimeWakeUp!,
      swt: stopWatchTimer.rawTime.value,
    );
    await getData();
    stopWatchTimer.onResetTimer();
    clearData();
    notifyListeners();
  }

  void resetTime() {
    stopWatchTimer.onStopTimer();
    stopWatchTimer.onResetTimer();
    play = false;
    notifyListeners();
  }

  Future<void> sendData({
    required int swt,
    required DateTime sleepDate,
    required TimeOfDay sleepTime,
    required DateTime wakeUpDate,
    required TimeOfDay wakeUpTime,
    required String nik,
  }) async {
    try {
      setLoading(true);
      var dtSleep = DateTime(sleepDate.year, sleepDate.month, sleepDate.day,
          sleepTime.hour, sleepTime.minute);
      var dtWakeUp = DateTime(wakeUpDate.year, wakeUpDate.month, wakeUpDate.day,
          wakeUpTime.hour, wakeUpTime.minute);
      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedSleep = formatter.format(dtSleep);
      String formattedWakeUp = formatter.format(dtWakeUp);
      getRateAndStatusTest();
      final Database db = await database;
      await db.insert('test', {
        'sleep_date': formattedSleep,
        'wakeup_date': formattedWakeUp,
        'date_created': formatter.format(
          DateTime.now(),
        ),
        'nik_user': nik,
        'result_test': swt,
        'test_number': resultTest.length + 1,
        'rate_test': rateTest,
        'status_test': statusTest.name,
      });
      setLoading(false);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getData() async {
    try {
      final Database db = await database;
      if (user!.unit == "Head Office") {
        final List<Map<String, dynamic>> maps = await db.query('test');
        var result = List<ResultTest>.generate(
                maps.length, (i) => ResultTest.fromMap(maps[i]))
            .where((element) => element.testNumber > 10)
            .toList();
        resultTest = result;
        notifyListeners();
      } else if (user!.unit == "Operasional") {
        final List<Map<String, dynamic>> maps = await db
            .query('test', where: "nik_user = ?", whereArgs: [user!.nik]);
        var result = List<ResultTest>.generate(
            maps.length, (i) => ResultTest.fromMap(maps[i]));
        resultTest = result;
        if (result.isNotEmpty) {
          lastResultTest = result[result.length - 1];
        }
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUserData() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('user', where: 'unit=?', whereArgs: ['Operasional']);
      var result =
          List<User>.generate(maps.length, (i) => User.fromMap(maps[i]));
      listUser = result;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteData(String nik, int testNumber) async {
    try {
      final Database db = await database;
      await db.rawDelete('DELETE FROM test WHERE nik_user=? and test_number=?',
          [nik, testNumber]);
      getData();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteAll(String nik) async {
    try {
      final Database db = await database;
      await db.rawDelete('DELETE FROM test WHERE nik_user=?', [nik]);
      getData();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> selectDateSleep(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null) {
      selectedDateSleep = picked;
      notifyListeners();
    }
  }

  Future selectTimeSleep(BuildContext context) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      selectedTimeSleep = pickedTime;
      notifyListeners();
    }
  }

  Future<void> selectDateWakeUp(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: selectedDateSleep!,
        lastDate: DateTime.now());
    if (picked != null) {
      selectedDateWakeUp = picked;
      notifyListeners();
    }
  }

  Future selectTimeWakeUp(BuildContext context) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      selectedTimeWakeUp = pickedTime;
      notifyListeners();
    }
  }

  Future<void> selectDateFilter(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null) {
      selectedDateFilterStart = picked.start;
      selectedDateFilterEnd = picked.end;
    }
  }

  Future<void> getModal(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return BottomSheet(
            onClosing: () {},
            builder: (_) {
              var dateStart;
              var dateEnd;
              var status;
              return StatefulBuilder(
                builder: (_, setState) =>
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Reset',
                              style: TextStyles.text14,
                            )),
                        Text(
                          'Filter',
                          style: TextStyles.text16Bold,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, size: 20.h)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Insets.med),
                            child: InkWell(
                              onTap: () async {
                                await selectDateFilter(context);
                                setState(
                                  () {
                                    dateStart = selectedDateFilterStart;
                                    dateEnd = selectedDateFilterEnd;
                                  },
                                );
                              },
                              child: Container(
                                decoration: FTStyle.coloredBorder()
                                    .copyWith(color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Insets.xs,
                                      vertical: Insets.med),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Insets.xs,
                                        ),
                                        child: Text(
                                          selectedDateFilterStart == null &&
                                                  selectedDateFilterEnd == null
                                              ? 'Tanggal Pengujian'
                                              : '${DateFormat('dd/MM/yyyy').format(selectedDateFilterStart as DateTime)} - ${DateFormat('dd/MM/yyyy').format(selectedDateFilterEnd as DateTime)} ',
                                          style: TextStyles.text12.copyWith(
                                              color: selectedDateFilterStart ==
                                                          null &&
                                                      selectedDateFilterEnd ==
                                                          null
                                                  ? Colors.grey
                                                  : Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: Insets.xs),
                                        child:
                                            Icon(FatigueTest.calendarOutline),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: Insets.med),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: driverNameFilter,
                                    keyboardType: TextInputType.text,
                                    cursorColor: FTColor.red,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: 'Nama Driver',
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: FTColor.greyColorBorder),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: FTColor.greyColorBorder,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: FTColor.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: Insets.med),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BottomSheet(
                                            onClosing: () {},
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setStatu) =>
                                                    Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons.chevron_left),
                                                        Text('Status Driver'),
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Insets.xl),
                                                      child: Column(
                                                        children: [
                                                          StatusTestFilterItem(
                                                              selected: _selectedStatusTest ==
                                                                      StatusTest
                                                                          .all
                                                                  ? true
                                                                  : false,
                                                              function:
                                                                  () async {
                                                                await setStatus(
                                                                    StatusTest
                                                                        .all);
                                                                setState(
                                                                  () {
                                                                    status =
                                                                        'All';
                                                                  },
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: 'All'),
                                                          StatusTestFilterItem(
                                                              selected: _selectedStatusTest ==
                                                                      StatusTest
                                                                          .safe
                                                                  ? true
                                                                  : false,
                                                              function:
                                                                  () async {
                                                                await setStatus(
                                                                    StatusTest
                                                                        .safe);
                                                                setState(
                                                                  () {
                                                                    status =
                                                                        'Safe';
                                                                  },
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: 'Safe'),
                                                          StatusTestFilterItem(
                                                              selected: _selectedStatusTest ==
                                                                      StatusTest
                                                                          .unsafe
                                                                  ? true
                                                                  : false,
                                                              function:
                                                                  () async {
                                                                await setStatus(
                                                                    StatusTest
                                                                        .unsafe);
                                                                setState(
                                                                  () {
                                                                    status =
                                                                        'Unsafe';
                                                                  },
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title: 'Unsafe'),
                                                          StatusTestFilterItem(
                                                              selected: _selectedStatusTest ==
                                                                      StatusTest
                                                                          .buruburu
                                                                  ? true
                                                                  : false,
                                                              function:
                                                                  () async {
                                                                await setStatus(
                                                                    StatusTest
                                                                        .buruburu);
                                                                setState(
                                                                  () {
                                                                    status =
                                                                        'Buru-Buru';
                                                                  },
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              title:
                                                                  'Buru-Buru'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: FTStyle.coloredBorder()
                                        .copyWith(color: Colors.white),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Insets.xs,
                                          vertical: Insets.med),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: Insets.xs,
                                            ),
                                            child: Text(
                                              status == null
                                                  ? 'Status Driver'
                                                  : status,
                                              style: TextStyles.text12.copyWith(
                                                  color: status == null
                                                      ? Colors.grey
                                                      : Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: Insets.xs),
                                            child: Icon(Icons.chevron_right),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: Insets.xl,
                                        ),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                        color: Colors.red)),
                                                backgroundColor: FTColor.red),
                                            onPressed: () async {
                                              await resultTestFiltered(
                                                  driverNameFilter!.text,
                                                  _selectedStatusTest == StatusTest.all ? null : getStatusTest,
                                                  selectedDateFilterStart,
                                                  selectedDateFilterEnd);
                                              await clearData();
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Insets.med),
                                              child: Text(
                                                'Terapkan',
                                                style: TextStyles.text14Bold,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                            ],
                          )
                        ],
                      ))
                ]),
              );
            },
          );
        });
  }
}
