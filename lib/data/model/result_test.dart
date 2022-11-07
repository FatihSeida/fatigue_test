import 'package:fatigue_tester/data/common/enum/enum_status_test.dart';
import 'package:flutter/material.dart';

class ResultTest extends ChangeNotifier {
  ResultTest({
    required this.statusTest,
    required this.result,
    required this.idTest,
    required this.testNumber,
    required this.sleepDate,
    required this.wakeupTime,
    required this.dateCreated,
  });

  final String idTest;
  final int testNumber;
  final int result;
  final DateTime sleepDate;
  final DateTime wakeupTime;
  final DateTime dateCreated;
  final StatusTest statusTest;

  ResultTest copyWith({
    String? idTest,
    int? testNumber,
    int? result,
    DateTime? sleepDate,
    TimeOfDay? sleepTime,
    DateTime? wakeupTime,
    DateTime? dateCreated,
    StatusTest? statusTest,
  }) =>
      ResultTest(
        idTest: idTest ?? this.idTest,
        testNumber: testNumber ?? this.testNumber,
        sleepDate: sleepDate ?? this.sleepDate,
        wakeupTime: wakeupTime ?? this.wakeupTime,
        dateCreated: dateCreated ?? this.dateCreated,
        result: result ?? this.result,
        statusTest: this.statusTest,
      );

  factory ResultTest.fromMap(Map<String, dynamic> json) => ResultTest(
        idTest: json["id_test"],
        testNumber: json["test_number"],
        sleepDate: json["sleep_date"],
        wakeupTime: json["wakeup_time"],
        dateCreated: json["date_created"],
        result: json["result_test"],
        statusTest: json["status_test"],
      );

  Map<String, dynamic> toMap() => {
        "id_test": idTest,
        "test_number": testNumber,
        "result_test": result,
        "sleep_date": sleepDate.toIso8601String(),
        "wakeup_time": wakeupTime.toIso8601String(),
        "date_created": dateCreated.toIso8601String(),
        "status_test": statusTest
      };
}
