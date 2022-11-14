import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/model/user.dart';
import '../../utils/db_helper.dart';
import '../widgets/dialog/loading_dialog.dart';

class RegistrationProvider extends ChangeNotifier {
  final database = DatabaseSqflite().openDB();

  User? _user;
  static const table = 'user';
  bool loading = false;

  late BuildContext _context;
  final _loadingDialog = LoadingDialog();

  TextEditingController usernameController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  User? get user => _user;

  void clearData() {
    usernameController.text = '';
    nikController.text = '';
    unitController.text = '';
  }

  Future<void> setLoading(bool loading) async {
    loading ? _loadingDialog.show(_context) : _loadingDialog.hide();
  }

  // /// Init
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

  Future<void> register(String name, String nik, String unit) async {
    try {
      await setLoading(true);
      final Database db = await database;
      var res =
          await db.insert('user', {'name': name, 'nik': nik, 'unit': unit});
      if (res != 0) {
        notifyListeners();
        showMessage(true, 'Akun telah terdaftar');
        await setLoading(false);
      }
    } catch (e) {
      log(e.toString());
      showMessage(false, 'Pendaftaran gagal, Akun sudah tersedia');
      await setLoading(false);
      rethrow;
    }
  }
}
