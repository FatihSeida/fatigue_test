import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fatigue_tester/data/model/result_test.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../data/common/enum/enum_status_test.dart';
import '../../data/model/user.dart';
import '../../utils/db_helper.dart';
import '../widgets/dialog/loading_dialog.dart';

class FatigueTestProvider extends ChangeNotifier {
  User? user;

  FatigueTestProvider(this.user) {
    initData();
  }

  final database = DatabaseSqflite().openDB();
  User userDriver = User(name: '', nik: '', unit: '');
  List<User> listUser = [];
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
    if (resultTest.length + 1 > 9) {
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

  void clearData() {
    selectedDateSleep = null;
    selectedTimeSleep = null;
    selectedDateWakeUp = null;
    selectedTimeWakeUp = null;
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
            maps.length, (i) => ResultTest.fromMap(maps[i]));
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

  Future<User> getUserDetailData(String nik) async {
    try {
      for (int i = 0; i < listUser.length; i++) {
        if (listUser.elementAt(i).nik == nik) {
          userDriver = listUser[i];
          return userDriver;
        }
      }
      return userDriver;
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
}
