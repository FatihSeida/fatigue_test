import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';

class FTStyle {
  static BoxDecoration coloredBorder({Color? color, double? width}) {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: width ?? 1,
          color: color ?? FTColor.greyColorBorder,
        ));
  }

  static BoxDecoration coloredContainer({required Color color}) {
    return BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  static AppBar FTAppBar({required String title, List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style:
            const TextStyle(color: FTColor.grey, fontWeight: FontWeight.bold),
      ),
      actions: actions,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 3,
      iconTheme: const IconThemeData(color: FTColor.grey),
    );
  }
}

Widget verticalSpace(double v) {
  return SizedBox(height: v);
}

Widget horizontalSpace(double v) {
  return SizedBox(width: v);
}

/// Used for all animations in the  app

class Sizes {
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get med => 20.w;
  static double get lg => 32.w;
  static double get xl => 48.w;
  static double get xxl => 80.w;
}

class IconSizes {
  static double get sm => 16.w;
  static double get med => 24.w;
  static double get lg => 32.w;
  static double get xl => 48.w;
  static double get xxl => 60.w;
}

class Insets {
  static double offsetScale = 1;
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get med => 12.w;
  static double get lg => 15.w;
  static double get xl => 20.w;
  static double get xxl => 30.w;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 40 * offsetScale;
}

class Corners {
  static double sm = 3.w;
  static BorderRadius smBorder = BorderRadius.all(smRadius);
  static Radius smRadius = Radius.circular(sm);

  static double med = 5.w;
  static BorderRadius medBorder = BorderRadius.all(medRadius);
  static Radius medRadius = Radius.circular(med);

  static double lg = 8.w;
  static BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static Radius lgRadius = Radius.circular(lg);

  static double xl = 16.w;
  static BorderRadius xlBorder = BorderRadius.all(xlRadius);
  static Radius xlRadius = Radius.circular(xl);

  static double xxl = 24.w;
  static BorderRadius xxlBorder = BorderRadius.all(xxlRadius);
  static Radius xxlRadius = Radius.circular(xxl);
}

class Strokes {
  static const double xthin = 0.7;
  static const double thin = 1;
  static const double med = 2;
  static const double thick = 4;
}

class Shadows {
  static List<BoxShadow> get universal => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.13),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 5)),
      ];
  static List<BoxShadow> get small => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1)),
      ];
  static List<BoxShadow> get none => [
        const BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0)),
      ];

  static List<BoxShadow> get shadowsUp => [
        BoxShadow(
            color: const Color(0xff333333).withOpacity(.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(-1, 0)),
      ];
}

/// Font Sizes
/// You can use these directly if you need, but usually there should be a predefined style in TextStyles.
class FontSizes {
  /// Provides the ability to nudge the app-wide font scale in either direction
  static double get s9 => 9.w;
  static double get s10 => 10.w;
  static double get s11 => 11.w;
  static double get s12 => 12.w;
  static double get s14 => 14.w;
  static double get s16 => 16.w;
  static double get s18 => 18.w;
  static double get s20 => 20.w;
  static double get s24 => 24.w;
  static double get s26 => 26.w;
  static double get s32 => 32.w;
  static double get s36 => 36.w;
  static double get s40 => 40.w;
  static double get s48 => 48.w;
  static double get s56 => 56.w;
}

/// Fonts - A list of Font Families, this is uses by the TextStyles class to create concrete styles.

/// TextStyles - All the core text styles for the app should be declared here.
/// Don't try and create every variant in existence here, just the high level ones.
/// More specific variants can be created on the fly using `style.copyWith()`
/// `newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: FTColor.red)`
class TextStyles {
  /// Declare a base style for each Family
  static const TextStyle sen =
      TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Sen');

  static TextStyle get text10 => sen.copyWith(fontSize: FontSizes.s10);
  static TextStyle get text12 => sen.copyWith(fontSize: FontSizes.s12);
  static TextStyle get text12Bold =>
      text12.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get text14 => sen.copyWith(fontSize: FontSizes.s14);
  static TextStyle get text14Bold =>
      text14.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get text16 => sen.copyWith(fontSize: FontSizes.s16);
  static TextStyle get text16Bold =>
      text16.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get text20 => sen.copyWith(fontSize: FontSizes.s20);
  static TextStyle get text20Bold =>
      text20.copyWith(fontWeight: FontWeight.w700, height: 1.4);
  static TextStyle get textXl => sen.copyWith(fontSize: FontSizes.s24);
  static TextStyle get textXlBold =>
      textXl.copyWith(fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get text2xl => sen.copyWith(fontSize: FontSizes.s32);
  static TextStyle get text2xlBold =>
      text2xl.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get text3xl => sen.copyWith(fontSize: FontSizes.s40);
  static TextStyle get text3xlBold =>
      text3xl.copyWith(fontWeight: FontWeight.w700);
}

class Borders {
  static const BorderSide universalBorder = BorderSide(
    color: Colors.grey,
    width: 1,
  );

  static const BorderSide smallBorder = BorderSide(
    color: Colors.grey,
    width: 0.5,
  );

  static BoxDecoration borderPin({
    Color? borderColor,
    double? strokeWidth,
  }) {
    return BoxDecoration(
        color: Colors.grey,
        borderRadius: Corners.lgBorder,
        border: Border.all(
          width: strokeWidth ?? Strokes.xthin,
          color: borderColor ?? Colors.grey,
        ));
  }
}
