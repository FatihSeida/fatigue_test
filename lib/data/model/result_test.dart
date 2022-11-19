import 'package:fatigue_tester/data/common/enum/enum_status_test.dart';
import 'package:flutter/material.dart';

class ResultTest extends ChangeNotifier {
  ResultTest({
    required this.rateTest,
    required this.statusTest,
    required this.result,
    required this.idTest,
    required this.testNumber,
    required this.sleepDate,
    required this.wakeupDate,
    required this.dateCreated,
    required this.nikDriver,
  });

  final int idTest;
  final int testNumber;
  final int result;
  final DateTime sleepDate;
  final DateTime wakeupDate;
  final DateTime dateCreated;
  final int rateTest;
  final StatusTest statusTest;
  final String nikDriver;

  ResultTest copyWith({
    int? idTest,
    int? testNumber,
    int? result,
    DateTime? sleepDate,
    DateTime? wakeupDate,
    DateTime? dateCreated,
    StatusTest? statusTest,
    int? rateTest,
    String? nikDriver,
  }) =>
      ResultTest(
        idTest: idTest ?? this.idTest,
        testNumber: testNumber ?? this.testNumber,
        sleepDate: sleepDate ?? this.sleepDate,
        wakeupDate: wakeupDate ?? this.wakeupDate,
        dateCreated: dateCreated ?? this.dateCreated,
        result: result ?? this.result,
        statusTest: this.statusTest,
        rateTest: this.rateTest,
        nikDriver: this.nikDriver,
      );

  factory ResultTest.fromMap(Map<String, dynamic> json) => ResultTest(
        idTest: json["id_test"],
        testNumber: json["test_number"],
        sleepDate: DateTime.tryParse(json["sleep_date"])!,
        wakeupDate: DateTime.tryParse(json["wakeup_date"])!,
        dateCreated: DateTime.tryParse(json["date_created"])!,
        result: json["result_test"],
        statusTest: json["status_test"] == 'notavailable'
            ? StatusTest.notavailable
            : json["status_test"] == 'unsafe'
                ? StatusTest.unsafe
                : json["status_test"] == 'safe'
                    ? StatusTest.safe
                    : StatusTest.buruburu,
        rateTest: json["rate_test"],
        nikDriver: json['nik_user'],
      );

  Map<String, dynamic> toMap() => {
        "id_test": idTest,
        "test_number": testNumber,
        "result_test": result,
        "sleep_date": sleepDate.toIso8601String(),
        "wakeup_time": wakeupDate.toIso8601String(),
        "date_created": dateCreated.toIso8601String(),
        "status_test": statusTest,
        "rate_test": rateTest,
        "nik_user": nikDriver,
      };
}
