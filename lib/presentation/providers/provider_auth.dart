import 'dart:convert';
import 'dart:developer';

import 'package:fatigue_tester/presentation/pages/page_landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:fatigue_tester/data/common/constant/session.dart';

import '../../data/common/constant/authentication.dart';
import '../../data/model/user.dart';
import '../../utils/db_helper.dart';
import '../widgets/dialog/loading_dialog.dart';

class AuthProvider extends ChangeNotifier {
  final database = DatabaseSqflite().openDB();
  bool loading = false;
  User? _user;
  static const table = 'user';
  Authentication get status => _status;
  Authentication _status = Authentication.uninitialized;
  late BuildContext _context;
  // BuildContext context;
  final _loadingDialog = LoadingDialog();
  bool isObscure = true;
  String? _message;
  String? username;
  String? password;

  // AuthProvider({
  //   required this.context,
  // });

  User? get user => _user;

  TextEditingController usernameController = TextEditingController();
  TextEditingController nikController = TextEditingController();

  void clearData() {
    usernameController.text = '';
    nikController.text = '';
  }

  Future<void> setStatus(Authentication auth) async {
    _status = auth;
    notifyListeners();
  }

  Future<void> setObscure() async {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future<void> setLoading(bool loading) async {
    loading ? _loadingDialog.show(_context) : _loadingDialog.hide();
  }

  /// Init
  set context(BuildContext context) => _context = context;

  Future<void> showMessage(bool success, String message) async {
    showTopSnackBar(
      _context,
      success
          ? CustomSnackBar.success(
              message: message,
            )
          : CustomSnackBar.error(
              message: message,
            ),
    );
  }

  Future<bool> getUser(String name, String nik) async {
    try {
      setLoading(true);
      Database db = await database;
      final res = await db.rawQuery(
          "SELECT * FROM $table WHERE name = '$name' AND nik = '$nik'");
      if (res.isNotEmpty) {
        User user = User.fromMap(res[0]);
        SpUtil.putString(USER_ID, user.nik);
        setLoading(false);
        setStatus(Authentication.authenticated);
        _user = user;
        return true;
      } else {
        setLoading(false);
        showMessage(false, 'User tidak ditemukan');
        return false;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
