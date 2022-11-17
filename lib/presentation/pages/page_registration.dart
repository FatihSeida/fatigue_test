import 'package:fatigue_tester/presentation/providers/provider_register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/common/constant/assets.dart';
import '../../data/common/constant/color.dart';
import '../../data/common/constant/styles.dart';

import '../widgets/input/text_form_field_text.dart';

class RegistrationPage extends StatelessWidget {
  static const routeName = '/registration';
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<RegistrationProvider>().context = context;
    final provider = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          context.read<RegistrationProvider>().context = context;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: SvgPicture.asset(Assets.logoSvg, height: 40.h),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.xl),
                      child: Text(
                        'Silahkan daftarkan Nama dan NIK anda',
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
                      padding: EdgeInsets.only(top: Insets.lg),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Unit',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Sen",
                                fontWeight: FontWeight.bold)),
                      ])),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.med),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration:
                                  FTStyle.coloredBorder(color: FTColor.grey),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Insets.med, vertical: Insets.med),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text(provider.remarkValue ??
                                        'Masukan Unit Anda Disini'),
                                    isDense: true,
                                    icon: const Icon(Icons.expand_more),
                                    items: provider.unit.map((item) {
                                      return DropdownMenuItem<String>(
                                        child: Text(item,
                                            style: TextStyles.text12
                                                .copyWith(color: FTColor.darkGrey)),
                                        value: item,
                                      );
                                    }).toList(),
                                    onChanged: (String? value) =>
                                        provider.changeTerminalRemarkValue(value!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Insets.lg),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Sudah punya akun?', style: TextStyles.text12),
                        TextSpan(
                          text: ' Masuk disini',
                          style: TextStyles.text12Bold.copyWith(color: FTColor.red),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              provider.clearData();
                              Navigator.of(context).pop();
                            },
                        ),
                      ], style: const TextStyle(color: Colors.black))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
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
                                    context.read<RegistrationProvider>().register(
                                          provider.usernameController.text,
                                          provider.nikController.text,
                                          provider.unitController.text,
                                        );
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: Insets.med),
                                    child: Text(
                                      'Register',
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
          );
        }
      ),
    );
  }
}
