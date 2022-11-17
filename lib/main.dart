import 'package:fatigue_tester/presentation/pages/page_detail_result.dart';
import 'package:fatigue_tester/presentation/pages/page_landing.dart';
import 'package:fatigue_tester/presentation/pages/page_login.dart';
import 'package:fatigue_tester/presentation/pages/page_registration.dart';
import 'package:fatigue_tester/presentation/providers/provider_fatigue_test.dart';
import 'package:fatigue_tester/presentation/providers/provider_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'data/common/constant/authentication.dart';
import 'data/common/constant/color.dart';
import 'presentation/pages/page_fatigue_test.dart';
import 'presentation/pages/page_history_test.dart';
import 'presentation/pages/page_result.dart';
import 'presentation/pages/page_splash.dart';
import 'presentation/providers/provider_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, RegistrationProvider>(
        create: (context) => RegistrationProvider(),
        update: (ctx, auth, user) => RegistrationProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, FatigueTestProvider>(
        create: (context) => FatigueTestProvider(null),
        update: (ctx, auth, user) => FatigueTestProvider(auth.user),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder: (BuildContext context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fatigue Test',
        theme: ThemeData(
          fontFamily: 'Sen',
          brightness: Brightness.light,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: FTColor.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)))),
        ),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}

Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => const Route(),
  '/landing': (context) => const LandingPage(),
  '/login': (context) => LoginScreen(),
  '/registration': (context) => const RegistrationPage(),
  '/result': (context) => const ResultPage(),
  '/history-test': (context) => const HistoryTestPage(),
  '/fatigue-test-form': (context) => const FatigueTestPage(),
  '/detail-result': (context) => const DetailResultPage(),
};

class Route extends StatelessWidget {
  const Route({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, AuthProvider auth, _) {
      print("status ${auth.status}");
      // return const HomePage();
      switch (auth.status) {
        case Authentication.authenticated:
          return const LandingPage();
        case Authentication.unauthenticated:
          return LoginScreen();
        default:
          return SplashScreen();
      }
    });
  }
}
