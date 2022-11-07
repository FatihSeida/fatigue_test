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
  final User? user;

  FatigueTestProvider(this.user);

  final database = DatabaseSqflite().openDB();
  Function eq = const ListEquality().equals;
  final comparingItems = List<int>.generate(20, (index) => index);
  final items = List<int>.generate(20, (index) => index);
  final isHours = true;
  final _loadingDialog = LoadingDialog();
  var play = true;
  late var shuffleItems = items;
  late bool same = false;
  late BuildContext _context;

  DateTime? selectedDate;
  TimeOfDay? selectedTimeSleep;
  DateTime? selectedTimeWakeUp;
  int? testNumber;
  StatusTest statusTest = StatusTest.notavailable;

  List<ResultTest> resultTest = [];

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

  void initState() {
    stopWatchTimer.fetchStopped
        .listen((value) => debugPrint('stopped from stream'));
    stopWatchTimer.fetchEnded
        .listen((value) => debugPrint('ended from stream'));
  }

  Future<void> setLoading(bool loading) async {
    loading ? _loadingDialog.show(_context) : _loadingDialog.hide();
  }

  /// Init
  set context(BuildContext context) => _context = context;

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
  }

  void onReorder(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    notifyListeners();
  }

  Future<void> setItems() async {
    shuffleItems.shuffle();
    notifyListeners();
  }

  Future<bool> startStopWatch() async {
    if (play == true) {
      setItems();
      stopWatchTimer.onStartTimer();
      play = false;
      notifyListeners();
      return play;
    } else {
      stopWatchTimer.onStopTimer();
      if (eq(comparingItems, shuffleItems) == true) {
        sendData(
            nik: user!.nik,
            sleepDate: selectedDate!,
            sleepTime: selectedTimeSleep!,
            swt: stopWatchTimer.rawTime.value,
            wakeUpTime: selectedTimeWakeUp!);
        same = true;
        return play;
      }
      play = true;
      stopWatchTimer.onResetTimer();
      notifyListeners();
      return play;
    }
  }

  Future<void> sendData({
    required int swt,
    required DateTime sleepDate,
    required TimeOfDay sleepTime,
    required DateTime wakeUpTime,
    required String nik,
  }) async {
    try {
      setLoading(true);
      var dt = DateTime(sleepDate.year, sleepDate.month, sleepDate.day,
          sleepTime.hour, sleepTime.minute);
      var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formatted = formatter.format(dt);

      final Database db = await database;
      var res = await db.insert('test', {
        'sleep_date': formatted,
        'wakeup_time': formatter.format(wakeUpTime),
        'date_created': formatter.format(
          DateTime.now(),
        ),
        'nik_user': nik,
        'result_test': swt,
        'test_number': testNumber ?? 0,
        'status_test': statusTest.name,
      });
      if (res != 0) {
        notifyListeners();
        setLoading(false);
      } else {
        setLoading(false);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getData() async {
    try {
      setLoading(true);
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('test', where: "nik_user = ?", whereArgs: [user!.nik]);
      Map<String, dynamic> result = {};
      for (var r in maps) {
        result.addAll(r);
      }
      result;
      notifyListeners();
      setLoading(false);
      // resultTest(List<ResultTest>.generate(
      //     maps.length,
      //     (i) => ResultTest(
      //           result: maps[i]['result_test'],
      //           idTest: maps[i]['result_test'],
      //           testNumber: maps[i]['result_test'],
      //           sleepDate: maps[i]['result_test'],
      //           wakeupTime: maps[i]['result_test'],
      //           dateCreated: maps[i]['result_test'],
      //           statusTest: maps[i]['result_test'],
      //         )));
      // locationAttendance(RxList<Attendance>.generate(
      //     maps.length,
      //     (i) => Attendance(
      //           // id: maps[i]['id'],
      //           name: maps[i]['name'],
      //           longitude: maps[i]['longitude'],
      //           latitude: maps[i]['latitude'],
      //           latitudeLocation: maps[i]['latitudeLocation'],
      //           longitudeLocation: maps[i]['longitudeLocation'],
      //           nameLocation: maps[i]['nameLocation'],
      //         )).toList());
      // distance(RxList<double>.generate(
      //     maps.length,
      //     (i) => GeolocatorPlatform.instance.distanceBetween(
      //           maps[i]['latitude'],
      //           maps[i]['longitude'],
      //           maps[i]['latitudeLocation'],
      //           maps[i]['longitudeLocation'],
      //         )).toList());
      // loading(false);
      // update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future selectTime(BuildContext context) async {
    var pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      selectedTimeSleep = pickedTime;
      notifyListeners();
    }
  }
}
