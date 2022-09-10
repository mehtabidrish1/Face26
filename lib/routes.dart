import 'package:face26_mobile/utils/payment/cancel.dart';
import 'package:face26_mobile/utils/payment/success.dart';
import 'package:face26_mobile/view/Desktop/editorWeb.dart';
import 'package:face26_mobile/view/Desktop/homeWeb.dart';
import 'package:face26_mobile/view/Desktop/settingsWeb.dart';
import 'package:face26_mobile/view/Mobile%20Web/checkout.dart';
import 'package:face26_mobile/view/Mobile%20Web/homePageWeb.dart';
import 'package:face26_mobile/view/Mobile%20Web/imageEditorWeb.dart';
import 'package:face26_mobile/view/introPage.dart';
import 'package:face26_mobile/view/loginPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();
  //static Router router = Router();

  static void setupRouter() {
    router.define('/', handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return (MediaQuery.of(context!).size.width > 550)
          ? HomeWeb()
          : IntroScreen();
    }));

    router.define('/home',
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                HomePageWeb()));

    router.define('/login',
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                LoginPage(oId: params['oId'][0])));

    router.define('/editor', handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return (MediaQuery.of(context!).size.width > 550)
          ? EditorWeb(oId: params['oId'][0])
          : ImageEditorWeb(oId: params['oId'][0]);
    }));

    router.define('/settings',
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                SettingsWeb(
                    purchased: params['purchased'][0],
                    credits: params['credits'][0])));

    router.define('/checkout', handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return CheckoutMob();
    }));

    router.define('/success',
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                SuccessPage()));

    router.define('/cancel',
        handler: Handler(
            handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
                CancelPage()));
  }
}
