// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User extends ChangeNotifier {
  User({
    required this.name,
    required this.nik,
    required this.unit,
    this.rateTest,
    this.statusTest,
    // this.resultTest,
  });

  final String name;
  final String nik;
  final String unit;
  final dynamic rateTest;
  final dynamic statusTest;
  // final List<int>? resultTest;

  User copyWith({
    String? name,
    String? nik,
    String? unit,
    dynamic rateTest,
    dynamic statusTest,
    // List<ResultTest>? resultTest,
  }) =>
      User(
        name: name ?? this.name,
        nik: nik ?? this.nik,
        unit: unit ?? this.unit,
        rateTest: rateTest ?? this.rateTest,
        statusTest: statusTest ?? this.statusTest,
        // resultTest: resultTest ?? this.resultTest,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["name"],
        nik: json["nik"],
        unit: json["unit"],
        rateTest: json["rate_test"],
        statusTest: json["status_test"],
        // resultTest: json["result_test"] == null
        //     ? null
        //     : List<ResultTest>.from(
        //         json["result_test"].map((x) => ResultTest.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "nik": nik,
        "unit": unit,
        "rate_test": rateTest,
        "status_test": statusTest,
        // "result_test": resultTest == null
        //     ? null
        //     : List<dynamic>.from(resultTest!.map((x) => x.toMap())),
      };

  @override
  String toString() {
    return 'User(name: $name, nik: $nik, unit: $unit, rateTest: $rateTest, statusTest: $statusTest';
  }
}
