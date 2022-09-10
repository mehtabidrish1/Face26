import 'package:face26_mobile/routes.dart';
import 'package:face26_mobile/view/Desktop/homeWeb.dart';
import 'package:face26_mobile/view/introPage.dart';
import 'package:face26_mobile/view/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
      appId: "447558107005629",
      cookie: true,
      xfbml: true,
      version: "v14.0",
    );
  }
  // Stripe.publishableKey =
  //     "pk_test_51LABM4QtNeZwbE9d1nlQAbJhBkT38bFe1H6GA0O31R5IGIIgnbUHUZO7zQyTQA495q8lbp3RxR6hM5IdFrT5vLPJ00T5mkQPO4";
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();

  await Firebase.initializeApp(
      name: 'Face26',
      options: const FirebaseOptions(
          apiKey: "AIzaSyB3r5UKgch5Y1ACgnYoYt-4k2tpl9hd3e8",
          appId: "1:434412560126:web:e47708b1e2a72a01cecfaf",
          messagingSenderId: "434412560126",
          projectId: "face26-f6b0c"));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Flurorouter.setupRouter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locale = Locale(ui.window.locale.languageCode, '');
    //_locale = Locale('de', '');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print('Max Width ${constraints.maxWidth}');
      //_locale = Localizations.localeOf(context);
      bool isWeb = constraints.maxWidth > 600;
      return ScreenUtilInit(
        builder: (context, child) => MaterialApp(
            onGenerateRoute: Flurorouter.router.generator,
            title: 'Face 26',
            theme: (defaultTargetPlatform == TargetPlatform.iOS)
                ? ThemeData(
                    textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme))
                : ThemeData(
                    textTheme: GoogleFonts.robotoTextTheme(
                        Theme.of(context).textTheme)),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _locale,
            home: child),
        child: isWeb
            ? HomeWeb()
            : kIsWeb
                ? IntroScreen()
                : SplashScreen(),
        designSize: isWeb ? Size(1920, 1080) : Size(390, 844),
      );
    });

    /**
     *  return LayoutBuilder(
      builder: (context, constraints) {
        print('Max Width ${constraints.maxWidth}');
        return ScreenUtilInit(
          builder: (context, widget) => MaterialApp(
              title: 'Face 26',
              theme: (defaultTargetPlatform == TargetPlatform.iOS)
                  ? ThemeData(
                      textTheme:
                          GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme))
                  : ThemeData(
                      textTheme:
                          GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,
              home: (defaultTargetPlatform == TargetPlatform.windows ||
                      defaultTargetPlatform == TargetPlatform.macOS ||
                      defaultTargetPlatform == TargetPlatform.linux)
                  ? HomeWeb()
                  : SplashScreen()),
          designSize: (defaultTargetPlatform == TargetPlatform.windows ||
                  defaultTargetPlatform == TargetPlatform.macOS ||
                  defaultTargetPlatform == TargetPlatform.linux)
              ? Size(1920, 1080)
              : Size(390, 844),
        );
      }
    );
     */
  }
}
