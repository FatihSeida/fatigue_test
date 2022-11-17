import 'package:fatigue_tester/data/common/constant/assets.dart';
import 'package:fatigue_tester/presentation/pages/page_registration.dart';
import 'package:fatigue_tester/presentation/providers/provider_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';

import '../widgets/input/text_form_field_text.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>().context = context;
    return Scaffold(
      body: Builder(builder: (context) {
        context.read<AuthProvider>().context = context;
        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                image: DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              child: Consumer<AuthProvider>(
                builder: (_, provider, __) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Image.asset(
                        Assets.logo,
                        height: 60.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.xl),
                      child: Text(
                        'Silahkan masukkan nama lengkap Anda dan Nomor Induk Pegawai',
                        style: TextStyles.text14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: TextFormFieldText(
                        title: "Nama Lengkap",
                        hint: "Masukan Nama Anda Disini",
                        textController: provider.usernameController,
                        mandatory: false,
                        enabled: true,
                        onChanged: (value) {
                          // context.read<AuthProvider>().username = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.lg),
                      child: TextFormFieldText(
                        title: "NIK",
                        hint: "Masukan NIK Anda Disini",
                        textController: provider.nikController,
                        mandatory: false,
                        enabled: true,
                        onChanged: (value) {
                          // context.read<AuthProvider>().username = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.xl),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Belum punya akun?',
                            style: TextStyles.text12),
                        TextSpan(
                          text: ' Daftar disini',
                          style: TextStyles.text12Bold
                              .copyWith(color: FTColor.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              provider.clearData();
                              Navigator.of(context)
                                  .pushNamed(RegistrationPage.routeName);
                            },
                        ),
                      ], style: const TextStyle(color: Colors.black))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 110.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Insets.xl,
                                  right: Insets.xxl,
                                  left: Insets.xxl),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: FTColor.red),
                                  onPressed: () {
                                    context.read<AuthProvider>().getUser(
                                                provider
                                                    .usernameController.text,
                                                provider.nikController.text) ==
                                            true
                                        ? Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                "/", (route) => false)
                                        : false;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Insets.med),
                                    child: Text(
                                      'Login',
                                      style: TextStyles.text14Bold,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
