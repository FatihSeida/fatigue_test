import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../data/common/constant/assets.dart';
import '../../data/common/constant/authentication.dart';
import '../../data/common/constant/session.dart';
import '../providers/provider_auth.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  String? userId = null;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    userId = provider.user?.nik;
    debugPrint("user id $userId ${userId == null} ${userId == ""}");
    Timer(
        const Duration(seconds: 3),
        () => {
              if (userId == null || userId == "")
                {
                  context
                      .read<AuthProvider>()
                      .setStatus(Authentication.unauthenticated)
                }
              else
                {
                  context
                      .read<AuthProvider>()
                      .setStatus(Authentication.authenticated)
                }
            });
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.splash), fit: BoxFit.cover)),
        child: SizedBox.expand(),
      ),
    ));
  }
}
