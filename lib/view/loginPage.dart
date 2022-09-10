import 'dart:ui';
import 'package:face26_mobile/backend/apis/checkCodeApi.dart';
import 'package:face26_mobile/backend/apis/getTokenApi.dart';
import 'package:face26_mobile/backend/apis/googleAuthApi.dart';
import 'package:face26_mobile/backend/apis/loginEmailApi.dart';
import 'package:face26_mobile/backend/apis/registerEmailApi.dart';
import 'package:face26_mobile/backend/apis/trackerApi.dart';
import 'package:face26_mobile/backend/models/checkCodeModel.dart';
import 'package:face26_mobile/backend/models/googleAuthModel.dart';
import 'package:face26_mobile/main.dart';
import 'package:face26_mobile/utils/authentication/googleAuth.dart';
import 'package:face26_mobile/view/Mobile%20Web/imageEditorWeb.dart';
import 'package:face26_mobile/view/homePage.dart';
import 'package:face26_mobile/widgets/language.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  String? oId;
  LoginPage({Key? key, this.oId}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GetTokenService getTokenService = GetTokenService();
  TrackerService trackerService = TrackerService();
  RegisterEmailService registerEmailService = RegisterEmailService();
  CheckCodeService checkCodeService = CheckCodeService();
  CheckCodeModel checkCodeModel = CheckCodeModel();
  LoginEmailService loginEmailService = LoginEmailService();
  GoogleAuthService googleAuthService = GoogleAuthService();
  late GoogleAuthModel googleAuthModel;

  TextEditingController loginEmailController = TextEditingController();
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyLcode = GlobalKey<FormState>();
  final formKeySign = GlobalKey<FormState>();
  final formKeyScode = GlobalKey<FormState>();
  bool signUp = true;
  bool hidePass = true;
  String token = '';
  bool mainHover = false;
  String? oId;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth') ?? '';
    if (token == '') {
      await getTokenService.getToken(context).then((value) async {
        token = value.accessToken;
      });
    }
  }

  loginEmail(String email) async {
    await loginEmailService
        .loginEmail(loginEmailController.text, context)
        .then((value) {
      print("Login email chla gya $value");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController codeController = TextEditingController();

            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  CheckCode() async {
                    await checkCodeService
                        .checkCode(int.parse(codeController.text),
                            loginEmailController.text, context)
                        .then((value) async {
                      token = value.accessToken!;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('auth', token);
                      print("permanent token${token}");
                    });
                    Navigator.pushNamed(context, 'editor?oId=');
                  }

                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r)),
                      content: Form(
                        key: formKeyLcode,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 29.h),
                              Text(translation(context).verifyCode,
                                  style: TextStyle(
                                      fontSize: 33.sp,
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 25.h),
                              Text(translation(context).verifyInfo1,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w400)),
                              Text(loginEmailController.text,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w400)),
                              Text(translation(context).verifyInfo2,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 30.h),
                              Container(
                                  width: 520.w,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Code",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Color(0xff333333),
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 7.h),
                                        TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: codeController,
                                            decoration: InputDecoration(
                                                fillColor: Color(0xffF8f8f8),
                                                filled: true,
                                                hintText: translation(context)
                                                    .enterCode,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffd8d8d8),
                                                        width: 1.5))),
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value == '') {
                                                return 'Code is required*';
                                              }
                                              return null;
                                            }),
                                        SizedBox(height: 30.h),
                                        ElevatedButton(
                                          onHover: (value) {
                                            mainHover = value;
                                            setState(() {});
                                          },
                                          onPressed: (() {
                                            if (formKeyLcode.currentState!
                                                .validate()) {
                                              CheckCode();
                                            }
                                          }),
                                          child: Text(
                                              translation(context).checknLogin),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.r),
                                                      side: BorderSide(
                                                          color:
                                                              Color(0xff0056d7),
                                                          width: 1.5))),
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 150.w,
                                                      vertical: 28.h)),
                                              textStyle: MaterialStateProperty.all(
                                                  TextStyle(
                                                      fontSize: 24.sp,
                                                      fontWeight: FontWeight.w700)),
                                              backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)),
                                              foregroundColor: MaterialStateProperty.all(Colors.white)),
                                        )
                                      ])),
                              SizedBox(height: 50.h)
                            ]),
                      ));
                }));
          });
    });
  }

  @override
  void initState() {
    super.initState();
    oId = widget.oId;
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width > 600;
    return size
        ? Scaffold(
            body: Row(
              children: [
                Container(
                  width: 697.w,
                  color: Color(0xff5118aa),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 20.h,
                          left: 20.w,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  Text("Back",
                                      style: TextStyle(
                                          fontSize: 21.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700))
                                ],
                              ))),
                      Center(
                          child: SizedBox(
                        width: 549.w,
                        height: 527.h,
                        child: Image.asset("assets/web/splash_center.png"),
                      )),
                    ],
                  ),
                ),
                Container(
                    width: 1222.w,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 102.h,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 40.w),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      signUp = false;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(translation(context).login,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              color: signUp
                                                  ? Color(0xff757575)
                                                  : Color(0xff5118aa),
                                              fontWeight: signUp
                                                  ? FontWeight.w400
                                                  : FontWeight.w700)),
                                      SizedBox(height: 5.h),
                                      SizedBox(
                                        width: 90.w,
                                        child: Divider(
                                          color: signUp
                                              ? Colors.white
                                              : Color(0xff5118aa),
                                          thickness: 3,
                                        ),
                                      ),
                                      SizedBox(height: 10.h)
                                    ],
                                  ),
                                ),
                                SizedBox(width: 50.w),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      signUp = true;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(translation(context).signup,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              color: signUp
                                                  ? Color(0xff5118aa)
                                                  : Color(0xff757575),
                                              fontWeight: signUp
                                                  ? FontWeight.w700
                                                  : FontWeight.w400)),
                                      SizedBox(height: 5.h),
                                      SizedBox(
                                        width: 90.w,
                                        child: Divider(
                                          color: signUp
                                              ? Color(0xff5118aa)
                                              : Colors.white,
                                          thickness: 3,
                                        ),
                                      ),
                                      SizedBox(height: 10.h)
                                    ],
                                  ),
                                ),
                                Spacer(),
                                DropdownButton<Language>(
                                  icon:
                                      Icon(Icons.keyboard_arrow_down_outlined),
                                  onChanged: (Language? language) async {
                                    if (language != null) {
                                      Locale _locale = await setLocale(
                                          language.languageCode);
                                      MyApp.setLocale(context, _locale);
                                    }
                                  },
                                  items: Language.languageList()
                                      .map<DropdownMenuItem<Language>>(
                                        (e) => DropdownMenuItem<Language>(
                                          value: e,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(e.languageCode,
                                                  style: TextStyle(
                                                      fontSize: 21.sp,
                                                      color: Color(0xff757575),
                                                      fontWeight:
                                                          FontWeight.w700))
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                SizedBox(width: 44.w)
                              ]),
                        ),
                        Divider(
                            color: Color(0xffc2c2c2), thickness: 1, indent: 8),
                        Container(
                            child: signUp
                                ? Column(
                                    children: [
                                      SizedBox(height: 50.h),
                                      SizedBox(
                                          height: 82.h,
                                          width: 82.w,
                                          child: Image.asset(
                                              "assets/icons/icon.png")),
                                      SizedBox(height: 37.h),
                                      Text(translation(context).joinUs,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              color: Color(0xff757575),
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 18.h),
                                      Text(translation(context).createAccount,
                                          style: TextStyle(
                                              fontSize: 33.sp,
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 20.h),
                                      DottedBorder(
                                          dashPattern: [8, 4],
                                          borderType: BorderType.RRect,
                                          color: Color(0xff7b61ff),
                                          radius: Radius.circular(5.r),
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        final LoginResult
                                                            result =
                                                            await FacebookAuth
                                                                .instance
                                                                .login(
                                                                    loginBehavior:
                                                                        LoginBehavior
                                                                            .dialogOnly);
                                                        // by default we request the email and the public profile
                                                        if (result.status ==
                                                            LoginStatus
                                                                .success) {
                                                          print(
                                                              "fb ka token ${result.accessToken!.userId}");
                                                          // you are logged
                                                          final AccessToken
                                                              accessToken =
                                                              result
                                                                  .accessToken!;
                                                        } else {
                                                          print(result.status);
                                                          print(result.message);
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                              height: 28.h,
                                                              width: 28.w,
                                                              child: Image.asset(
                                                                  "assets/icons/smallfb.png")),
                                                          SizedBox(width: 10.w),
                                                          Text(
                                                              translation(
                                                                      context)
                                                                  .continueFB,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff333333)))
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                          elevation: MaterialStateProperty.all(
                                                              0),
                                                          side: MaterialStateProperty
                                                              .all(
                                                            const BorderSide(
                                                              color: Color(
                                                                  0xff333333),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          shape: MaterialStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(
                                                                      40.r))),
                                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                              horizontal: 134.w,
                                                              vertical: 30.h)),
                                                          textStyle: MaterialStateProperty.all(TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                          backgroundColor:
                                                              MaterialStateProperty.all(Colors.white))),
                                                  SizedBox(height: 16.h),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        await googleSignIn
                                                            .signIn()
                                                            .then(
                                                                (value) async {
                                                          var abc = await value!
                                                              .authentication;
                                                          String gToken =
                                                              abc.idToken!;
                                                          String clientID =
                                                              googleSignIn
                                                                  .clientId!;
                                                          await googleAuthService
                                                              .googleAuth(
                                                                  clientID,
                                                                  gToken)
                                                              .then(
                                                                  (value) async {
                                                            print(
                                                                value.authType);
                                                            print(value.email);
                                                            token = value
                                                                .accessToken;
                                                            SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            prefs.setString(
                                                                'auth', token);
                                                            Navigator.pushNamed(
                                                                context,
                                                                'editor?oId=');
                                                          });
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                              height: 28.h,
                                                              width: 28.w,
                                                              child: Image.asset(
                                                                  "assets/icons/smallgoogle.png")),
                                                          SizedBox(width: 10.w),
                                                          Text(
                                                              translation(
                                                                      context)
                                                                  .continueGoogle,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff333333)))
                                                        ],
                                                      ),
                                                      style: ButtonStyle(
                                                          elevation: MaterialStateProperty.all(
                                                              0),
                                                          side: MaterialStateProperty
                                                              .all(
                                                            const BorderSide(
                                                              color: Color(
                                                                  0xff333333),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          shape: MaterialStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(
                                                                      40.r))),
                                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                              horizontal: 146.w,
                                                              vertical: 30.h)),
                                                          textStyle: MaterialStateProperty.all(TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                          backgroundColor:
                                                              MaterialStateProperty.all(Colors.white)))
                                                ],
                                              ),
                                            ),
                                          )),
                                      SizedBox(height: 26.h),
                                      SizedBox(
                                        width: 351.w,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                                child: Divider(
                                                    color: Color(0xff666666)
                                                        .withOpacity(0.25),
                                                    thickness: 1.5)),
                                            SizedBox(width: 15.w),
                                            Text("OR",
                                                style: TextStyle(
                                                    fontSize: 24.sp,
                                                    color: Color(0xff666666),
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                                child: Divider(
                                                    color: Color(0xff666666)
                                                        .withOpacity(0.25),
                                                    thickness: 1.5))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      ElevatedButton(
                                        onHover: (value) {
                                          mainHover = value;
                                          setState(() {});
                                        },
                                        onPressed: (() {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                TextEditingController
                                                    emailController =
                                                    TextEditingController();
                                                TextEditingController
                                                    codeController =
                                                    TextEditingController();
                                                bool next = false;

                                                return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 4, sigmaY: 4),
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      SendCode() async {
                                                        await trackerService
                                                            .tracker(
                                                                token.substring(
                                                                    token.length -
                                                                        8),
                                                                emailController
                                                                    .text,
                                                                "registration",
                                                                context)
                                                            .then((value) {
                                                          print(
                                                              "token aa gya ${value}");
                                                        });
                                                        await registerEmailService
                                                            .registerEmail(
                                                                token,
                                                                emailController
                                                                    .text,
                                                                context)
                                                            .then((value) {
                                                          print(
                                                              "email chla gya ${value}");
                                                          setState(() {
                                                            next = true;
                                                          });
                                                        });
                                                      }

                                                      CheckCode() async {
                                                        await checkCodeService
                                                            .checkCode(
                                                                int.parse(
                                                                    codeController
                                                                        .text),
                                                                emailController
                                                                    .text,
                                                                context)
                                                            .then(
                                                                (value) async {
                                                          token = value
                                                              .accessToken!;
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          prefs.setString(
                                                              'auth', token);
                                                          print(
                                                              "permanent token${token}");
                                                        });
                                                        Navigator.pushNamed(
                                                            context,
                                                            'editor?oId=');
                                                      }

                                                      return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.r)),
                                                          content: next
                                                              ? Form(
                                                                  key:
                                                                      formKeyScode,
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                29.h),
                                                                        Text(
                                                                            "Verify Code",
                                                                            style: TextStyle(
                                                                                fontSize: 33.sp,
                                                                                color: Color(0xff333333),
                                                                                fontWeight: FontWeight.w700)),
                                                                        SizedBox(
                                                                            height:
                                                                                25.h),
                                                                        Text(
                                                                            "A login code has been successfully sent to",
                                                                            style: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                color: Color(0xff757575),
                                                                                fontWeight: FontWeight.w400)),
                                                                        Text(
                                                                            emailController
                                                                                .text,
                                                                            style: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                color: Color(0xff757575),
                                                                                fontWeight: FontWeight.w400)),
                                                                        Text(
                                                                            "Check your mailbox and copy the code in this window.",
                                                                            style: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                color: Color(0xff757575),
                                                                                fontWeight: FontWeight.w400)),
                                                                        SizedBox(
                                                                            height:
                                                                                30.h),
                                                                        Container(
                                                                            width:
                                                                                520.w,
                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text("Code", style: TextStyle(fontSize: 18.sp, color: Color(0xff333333), fontWeight: FontWeight.w600)),
                                                                              SizedBox(height: 7.h),
                                                                              TextFormField(
                                                                                controller: codeController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value == '') {
                                                                                    return 'Code is required*';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                decoration: InputDecoration(fillColor: Color(0xffF8f8f8), filled: true, hintText: "Enter code", border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
                                                                              ),
                                                                              SizedBox(height: 30.h),
                                                                              ElevatedButton(
                                                                                onPressed: (() {
                                                                                  if (formKeyScode.currentState!.validate()) {
                                                                                    CheckCode();
                                                                                  }
                                                                                }),
                                                                                child: Text("Check & Login"),
                                                                                style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r), side: BorderSide(color: Color(0xff0056d7), width: 1.5))), padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 150.w, vertical: 28.h)), textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)), backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)), foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                                              )
                                                                            ])),
                                                                        SizedBox(
                                                                            height:
                                                                                50.h)
                                                                      ]),
                                                                )
                                                              : Form(
                                                                  key:
                                                                      formKeySign,
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                82.h,
                                                                            width: 82.w,
                                                                            child: Image.asset("assets/icons/icon.png")),
                                                                        SizedBox(
                                                                            height:
                                                                                29.h),
                                                                        Text(
                                                                            "Join us today",
                                                                            style: TextStyle(
                                                                                fontSize: 21.sp,
                                                                                color: Color(0xff757575),
                                                                                fontWeight: FontWeight.w400)),
                                                                        SizedBox(
                                                                            height:
                                                                                25.h),
                                                                        Text(
                                                                            "Create your account",
                                                                            style: TextStyle(
                                                                                fontSize: 33.sp,
                                                                                color: Color(0xff333333),
                                                                                fontWeight: FontWeight.w700)),
                                                                        SizedBox(
                                                                            height:
                                                                                30.h),
                                                                        Container(
                                                                            width:
                                                                                520.w,
                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                              Text("Email", style: TextStyle(fontSize: 18.sp, color: Color(0xff333333), fontWeight: FontWeight.w600)),
                                                                              SizedBox(height: 7.h),
                                                                              TextFormField(
                                                                                controller: emailController,
                                                                                validator: (String? value) {
                                                                                  if (value == null || value == '') {
                                                                                    return 'Email is required*';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                decoration: InputDecoration(fillColor: Color(0xffF8f8f8), filled: true, hintText: translation(context).emailHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
                                                                              ),
                                                                              SizedBox(height: 30.h),
                                                                              ElevatedButton(
                                                                                onPressed: (() {
                                                                                  if (formKeySign.currentState!.validate()) {
                                                                                    SendCode();
                                                                                  }
                                                                                }),
                                                                                child: Text("Next"),
                                                                                style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r), side: BorderSide(color: Color(0xff0056d7), width: 1.5))), padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 150.w, vertical: 28.h)), textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)), backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)), foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                                              )
                                                                            ])),
                                                                        SizedBox(
                                                                            height:
                                                                                50.h)
                                                                      ]),
                                                                ));
                                                    }));
                                              });
                                        }),
                                        child: Text(
                                            translation(context).signupEmail,
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.r))),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: 202.w,
                                                  vertical: 31.h)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w400)),
                                          backgroundColor: MaterialStateProperty
                                              .all(mainHover
                                                  ? Color(0xff5118aa)
                                                  : const Color(0XFF111111)),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      RichText(
                                        text: TextSpan(
                                            text: 'By signing up,',
                                            style: TextStyle(
                                                color: Color(0xff333333),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: ' you agree to the ',
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              TextSpan(
                                                  text: 'Terms of Service',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Color(0xff111111),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // navigate to desired screen
                                                        }),
                                              TextSpan(
                                                  text: ' and',
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400))
                                            ]),
                                      ),
                                      SizedBox(
                                        height: 07,
                                      ),
                                      RichText(
                                        text: TextSpan(text: ' ', children: <
                                            TextSpan>[
                                          TextSpan(
                                              text: 'Privacy Policy,',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color(0xff111111),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  // navigate to desired screen
                                                }),
                                          TextSpan(
                                              text: ' including ',
                                              style: TextStyle(
                                                  color: Color(0xff333333),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400)),
                                          TextSpan(
                                              text: 'cookie use.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color(0xff111111),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  // navigate to desired screen
                                                })
                                        ]),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(height: 55.h),
                                      SizedBox(
                                          height: 82.h,
                                          width: 82.w,
                                          child: Image.asset(
                                              "assets/icons/icon.png")),
                                      SizedBox(height: 29.h),
                                      Text(translation(context).welcome,
                                          style: TextStyle(
                                              fontSize: 21.sp,
                                              color: Color(0xff757575),
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 25.h),
                                      Text(translation(context).loginToAccount,
                                          style: TextStyle(
                                              fontSize: 33.sp,
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 30.h),
                                      Container(
                                        width: 520.w,
                                        child: Form(
                                          key: formKeyLogin,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Email",
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        color:
                                                            Color(0xff333333),
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                SizedBox(height: 7.h),
                                                TextFormField(
                                                    controller:
                                                        loginEmailController,
                                                    decoration: InputDecoration(
                                                        fillColor:
                                                            Color(0xffF8f8f8),
                                                        filled: true,
                                                        hintText:
                                                            translation(context)
                                                                .emailHint,
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xffd8d8d8),
                                                                width: 1.5))),
                                                    validator: (String? value) {
                                                      if (value == null ||
                                                          value == '') {
                                                        return 'Email is required*';
                                                      }
                                                      return null;
                                                    }),
                                                // SizedBox(height: 8.h),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.end,
                                                //   children: [
                                                //     InkWell(
                                                //       onTap: () {
                                                //         setState(() {
                                                //           hidePass = !hidePass;
                                                //         });
                                                //       },
                                                //       child: hidePass
                                                //           ? Transform.scale(
                                                //               scale: 0.7,
                                                //               child: Icon(
                                                //                   Icons.visibility_off))
                                                //           : Transform.scale(
                                                //               scale: 0.7,
                                                //               child: Icon(
                                                //                   Icons.visibility)),
                                                //     )
                                                //   ],
                                                // ),
                                                // Text(translation(context).password,
                                                //     style: TextStyle(
                                                //         fontSize: 18.sp,
                                                //         color: Color(0xff333333),
                                                //         fontWeight: FontWeight.w600)),
                                                // SizedBox(height: 7.h),
                                                // TextField(
                                                //   obscureText: hidePass,
                                                //   decoration: InputDecoration(
                                                //       fillColor: Color(0xffF8f8f8),
                                                //       filled: true,
                                                //       hintText: translation(context)
                                                //           .passwordHint,
                                                //       border: OutlineInputBorder(
                                                //           borderRadius:
                                                //               BorderRadius.circular(6),
                                                //           borderSide: BorderSide(
                                                //               color: Color(0xffd8d8d8),
                                                //               width: 1.5))),
                                                // ),
                                                SizedBox(height: 30.h),
                                                ElevatedButton(
                                                  onHover: (value) {
                                                    mainHover = value;
                                                    setState(() {});
                                                  },
                                                  onPressed: (() {
                                                    if (formKeyLogin
                                                        .currentState!
                                                        .validate()) {
                                                      loginEmail(
                                                          loginEmailController
                                                              .text);
                                                    }
                                                  }),
                                                  child: Row(
                                                    children: [
                                                      Spacer(),
                                                      Text(translation(context)
                                                          .logIn),
                                                      Spacer()
                                                    ],
                                                  ),
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      100.r),
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xff0056d7),
                                                                  width: 1.5))),
                                                      padding: MaterialStateProperty.all(
                                                          EdgeInsets.symmetric(
                                                              // horizontal: 200.w,
                                                              vertical: 28.h)),
                                                      textStyle: MaterialStateProperty.all(TextStyle(
                                                          fontSize: 24.sp,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(mainHover
                                                              ? Colors.black
                                                              : const Color(0XFF5118AA)),
                                                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                ),
                                                SizedBox(height: 28.h),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      translation(context)
                                                          .forgetpass,
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 18.sp,
                                                          color:
                                                              Color(0xff5118aa),
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                                SizedBox(height: 33.h),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ))
                      ],
                    ))
              ],
            ),
          )
        : mobileLogin();
  }

  Widget mobileLogin() {
    return SafeArea(
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          SizedBox(
            height: 44,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(width: 20.w),
              InkWell(
                onTap: () {
                  setState(() {
                    signUp = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 5.h),
                    Text(translation(context).login,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color:
                                signUp ? Color(0xff757575) : Color(0xff5118aa),
                            fontWeight:
                                signUp ? FontWeight.w300 : FontWeight.w600)),

                    SizedBox(
                      width: 65.w,
                      child: Divider(
                        color: signUp ? Colors.white : Color(0xff5118aa),
                        thickness: 3,
                      ),
                    ),
                    //SizedBox(height: 05.h)
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              InkWell(
                onTap: () {
                  setState(() {
                    signUp = true;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 5.h),
                    Text(translation(context).signup,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color:
                                signUp ? Color(0xff5118aa) : Color(0xff757575),
                            fontWeight:
                                signUp ? FontWeight.w600 : FontWeight.w300)),
                    SizedBox(
                      width: 70.w,
                      child: Divider(
                        color: signUp ? Color(0xff5118aa) : Colors.white,
                        thickness: 3,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              DropdownButton<Language>(
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (Language? language) async {
                  if (language != null) {
                    Locale _locale = await setLocale(language.languageCode);
                    MyApp.setLocale(context, _locale);
                  }
                },
                // value: Language.languageList()
                //     .firstWhere((element) => element.languageCode == 'de'),
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(e.languageCode,
                                style: TextStyle(
                                    fontSize: 21.sp,
                                    color: Color(0xff757575),
                                    fontWeight: FontWeight.w700))
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(width: 20.w)
            ]),
          ),
          Divider(color: Color(0xffc2c2c2), thickness: 1, indent: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
                child: signUp
                    ? Column(
                        children: [
                          SizedBox(height: 25.h),
                          SizedBox(
                              height: 56.h,
                              width: 56.w,
                              child: Image.asset("assets/icons/icon.png")),
                          SizedBox(height: 10.h),
                          Text(translation(context).joinUs,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff757575),
                                  fontWeight: FontWeight.w300)),
                          SizedBox(height: 05.h),
                          Text(translation(context).createAccount,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 16.h),
                          DottedBorder(
                              dashPattern: [8, 4],
                              borderType: BorderType.RRect,
                              color: Color(0xff7b61ff),
                              radius: Radius.circular(5.r),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          final LoginResult result =
                                              await FacebookAuth.instance.login(
                                                  loginBehavior:
                                                      LoginBehavior.dialogOnly);
                                          // by default we request the email and the public profile
                                          if (result.status ==
                                              LoginStatus.success) {
                                            print(
                                                "fb ka token ${result.accessToken!.userId}");
                                            // you are logged
                                            final AccessToken accessToken =
                                                result.accessToken!;
                                          } else {
                                            print(result.status);
                                            print(result.message);
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Spacer(),
                                            SizedBox(
                                                height: 28.h,
                                                width: 28.w,
                                                child: Image.asset(
                                                    "assets/icons/smallfb.png")),
                                            SizedBox(width: 10.w),
                                            Text(
                                                translation(context).continueFB,
                                                style: TextStyle(
                                                    color: Color(0xff333333))),
                                            Spacer()
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            side: MaterialStateProperty.all(
                                              const BorderSide(
                                                color: Color(0xff333333),
                                                width: 1,
                                              ),
                                            ),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(30.r))),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    //horizontal: 134.w,
                                                    vertical: 25.h)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white))),
                                    SizedBox(height: 16.h),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await googleSignIn
                                              .signIn()
                                              .then((value) async {
                                            var abc =
                                                await value!.authentication;
                                            String gToken = abc.idToken!;
                                            String clientID =
                                                googleSignIn.clientId!;
                                            await googleAuthService
                                                .googleAuth(clientID, gToken)
                                                .then((value) async {
                                              print(value.authType);
                                              print(value.email);
                                              token = value.accessToken;
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString('auth', token);
                                              if (kIsWeb) {
                                                Navigator.pushNamed(
                                                    context, 'editor?oId=');
                                              } else {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage()));
                                              }
                                            });
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Spacer(),
                                            SizedBox(
                                                height: 28.h,
                                                width: 28.w,
                                                child: Image.asset(
                                                    "assets/icons/smallgoogle.png")),
                                            SizedBox(width: 10.w),
                                            Text(
                                                translation(context)
                                                    .continueGoogle,
                                                style: TextStyle(
                                                    color: Color(0xff333333))),
                                            Spacer()
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            side: MaterialStateProperty.all(
                                              const BorderSide(
                                                color: Color(0xff333333),
                                                width: 1,
                                              ),
                                            ),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(30.r))),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    //horizontal: 146.w,
                                                    vertical: 25.h)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white)))
                                  ],
                                ),
                              )),
                          SizedBox(height: 22.h),
                          SizedBox(
                            width: 351.w,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: Divider(
                                        color:
                                            Color(0xff666666).withOpacity(0.25),
                                        thickness: 1.5)),
                                SizedBox(width: 15.w),
                                Text("OR",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400)),
                                SizedBox(width: 15.w),
                                Expanded(
                                    child: Divider(
                                        color:
                                            Color(0xff666666).withOpacity(0.25),
                                        thickness: 1.5))
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: (() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController emailController =
                                        TextEditingController();
                                    TextEditingController codeController =
                                        TextEditingController();
                                    bool next = false;

                                    return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 4, sigmaY: 4),
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          SendCode() async {
                                            await trackerService
                                                .tracker(
                                                    token.substring(
                                                        token.length - 8),
                                                    emailController.text,
                                                    "registration",
                                                    context)
                                                .then((value) {
                                              print("token aa gya ${value}");
                                            });
                                            await registerEmailService
                                                .registerEmail(
                                                    token,
                                                    emailController.text,
                                                    context)
                                                .then((value) {
                                              print("email chla gya ${value}");
                                              setState(() {
                                                next = true;
                                              });
                                            });
                                          }

                                          CheckCode() async {
                                            await checkCodeService
                                                .checkCode(
                                                    int.parse(
                                                        codeController.text),
                                                    emailController.text,
                                                    context)
                                                .then((value) async {
                                              token = value.accessToken!;
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString('auth', token);
                                              print("permanent token${token}");
                                            });
                                            if (kIsWeb) {
                                              Navigator.pushNamed(
                                                  context, '/editor?oId=$oId');
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ImageEditorWeb(
                                                              oId: oId!)));
                                            }
                                          }

                                          return AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 30.h,
                                                      horizontal: 12.w),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.r)),
                                              content: next
                                                  ? Form(
                                                      key: formKeyScode,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                                height: 10.h),
                                                            Text(
                                                                translation(
                                                                        context)
                                                                    .verifyCode,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        23.sp,
                                                                    color: Color(
                                                                        0xff333333),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            SizedBox(
                                                                height: 20.h),
                                                            Text(
                                                                translation(
                                                                        context)
                                                                    .verifyInfo1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Color(
                                                                        0xff757575),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                emailController
                                                                    .text,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18.sp,
                                                                    color: Color(
                                                                        0xff757575),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                translation(
                                                                        context)
                                                                    .verifyInfo2,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Color(
                                                                        0xff757575),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            SizedBox(
                                                                height: 30.h),
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text("Code",
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff333333),
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  SizedBox(
                                                                      height:
                                                                          7.h),
                                                                  TextFormField(
                                                                      controller:
                                                                          codeController,
                                                                      decoration: InputDecoration(
                                                                          fillColor: Color(
                                                                              0xffF8f8f8),
                                                                          filled:
                                                                              true,
                                                                          hintText: translation(context)
                                                                              .enterCode,
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              borderSide: BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
                                                                      validator: (String? value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value ==
                                                                                '') {
                                                                          return 'Code is required*';
                                                                        }
                                                                        return null;
                                                                      }),
                                                                  SizedBox(
                                                                      height:
                                                                          25.h),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        (() {
                                                                      if (formKeyScode
                                                                          .currentState!
                                                                          .validate()) {
                                                                        CheckCode();
                                                                      }
                                                                    }),
                                                                    child: Row(
                                                                      children: [
                                                                        Spacer(),
                                                                        Text(translation(context)
                                                                            .checknLogin),
                                                                        Spacer()
                                                                      ],
                                                                    ),
                                                                    style: ButtonStyle(
                                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r), side: BorderSide(color: Color(0xff0056d7), width: 1.5))),
                                                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                            // horizontal: 150
                                                                            //     .w,
                                                                            vertical: 24.h)),
                                                                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
                                                                        backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)),
                                                                        foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                                  )
                                                                ]),
                                                            SizedBox(
                                                                height: 30.h)
                                                          ]),
                                                    )
                                                  : Form(
                                                      key: formKeySign,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                                height: 56.h,
                                                                width: 56.w,
                                                                child: Image.asset(
                                                                    "assets/icons/icon.png")),
                                                            SizedBox(
                                                                height: 22.h),
                                                            Text(
                                                                translation(
                                                                        context)
                                                                    .joinUs,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Color(
                                                                        0xff757575),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            SizedBox(
                                                                height: 20.h),
                                                            Text(
                                                                translation(
                                                                        context)
                                                                    .createAccount,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22.sp,
                                                                    color: Color(
                                                                        0xff333333),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            SizedBox(
                                                                height: 20.h),
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text("Email",
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff333333),
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  SizedBox(
                                                                      height:
                                                                          7.h),
                                                                  TextFormField(
                                                                      controller:
                                                                          emailController,
                                                                      decoration: InputDecoration(
                                                                          fillColor: Color(
                                                                              0xffF8f8f8),
                                                                          filled:
                                                                              true,
                                                                          hintText: translation(context)
                                                                              .emailHint,
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(6),
                                                                              borderSide: BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
                                                                      validator: (String? value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value ==
                                                                                '') {
                                                                          return 'Email is required*';
                                                                        }
                                                                        return null;
                                                                      }),
                                                                  SizedBox(
                                                                      height:
                                                                          25.h),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        (() {
                                                                      SendCode();
                                                                    }),
                                                                    child: Row(
                                                                      children: [
                                                                        Spacer(),
                                                                        Text(
                                                                            "Next"),
                                                                        Spacer()
                                                                      ],
                                                                    ),
                                                                    style: ButtonStyle(
                                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r), side: BorderSide(color: Color(0xff0056d7), width: 1.5))),
                                                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                            // horizontal: 150
                                                                            //     .w,
                                                                            vertical: 24.h)),
                                                                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
                                                                        backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)),
                                                                        foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                                  )
                                                                ]),
                                                            SizedBox(
                                                                height: 10.h)
                                                          ]),
                                                    ));
                                        }));
                                  });
                            }),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(translation(context).signupEmail,
                                    style: TextStyle(color: Colors.white)),
                                Spacer()
                              ],
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.r))),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 25.h)),
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400)),
                              backgroundColor: MaterialStateProperty.all(
                                  mainHover
                                      ? Color(0xff5118aa)
                                      : const Color(0XFF111111)),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          RichText(
                            text: TextSpan(
                                text: 'By signing up,',
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' you agree to the ',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff111111),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // navigate to desired screen
                                        }),
                                  TextSpan(
                                      text: ' and',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400))
                                ]),
                          ),
                          SizedBox(
                            height: 07,
                          ),
                          RichText(
                            text: TextSpan(text: ' ', children: <TextSpan>[
                              TextSpan(
                                  text: 'Privacy Policy,',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff111111),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // navigate to desired screen
                                    }),
                              TextSpan(
                                  text: ' including ',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400)),
                              TextSpan(
                                  text: 'cookie use.',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff111111),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // navigate to desired screen
                                    })
                            ]),
                          )
                        ],
                      )
                    : Form(
                        key: formKeyLogin,
                        child: Column(
                          children: [
                            SizedBox(height: 25.h),
                            SizedBox(
                                height: 56.h,
                                width: 56.w,
                                child: Image.asset("assets/icons/icon.png")),
                            SizedBox(height: 15.h),
                            Text(translation(context).welcome,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Color(0xff757575),
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 20.h),
                            Text(translation(context).loginToAccount,
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 20.h),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email",
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Color(0xff333333),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 7.h),
                                  TextFormField(
                                      controller: loginEmailController,
                                      decoration: InputDecoration(
                                          fillColor: Color(0xffF8f8f8),
                                          filled: true,
                                          hintText:
                                              translation(context).emailHint,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              borderSide: BorderSide(
                                                  color: Color(0xffd8d8d8),
                                                  width: 1.5))),
                                      validator: (String? value) {
                                        if (value == null || value == '') {
                                          return 'Email is required*';
                                        }
                                        return null;
                                      }),
                                  SizedBox(height: 30.h),
                                  ElevatedButton(
                                    onPressed: (() async {
                                      if (formKeyLogin.currentState!
                                          .validate()) {
                                        await loginEmailService
                                            .loginEmail(
                                                loginEmailController.text,
                                                context)
                                            .then((value) {
                                          print("Login email chla gya $value");
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                TextEditingController
                                                    codeController =
                                                    TextEditingController();

                                                return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 4, sigmaY: 4),
                                                    child: StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      CheckCode() async {
                                                        await checkCodeService
                                                            .checkCode(
                                                                int.parse(
                                                                    codeController
                                                                        .text),
                                                                loginEmailController
                                                                    .text,
                                                                context)
                                                            .then(
                                                                (value) async {
                                                          token = value
                                                              .accessToken!;
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          prefs.setString(
                                                              'auth', token);
                                                          print(
                                                              "permanent token${token}");
                                                        });
                                                        if (kIsWeb) {
                                                          Navigator.pushNamed(
                                                              context, '/home');
                                                        } else {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          HomePage()));
                                                        }
                                                      }

                                                      return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.r)),
                                                          content: Form(
                                                            key: formKeyLcode,
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          10.h),
                                                                  Text(
                                                                      translation(
                                                                              context)
                                                                          .verifyCode,
                                                                      style: TextStyle(
                                                                          fontSize: 22
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff333333),
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  SizedBox(
                                                                      height:
                                                                          20.h),
                                                                  Text(
                                                                      translation(
                                                                              context)
                                                                          .verifyInfo1,
                                                                      style: TextStyle(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff757575),
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                  Text(
                                                                      loginEmailController
                                                                          .text,
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff757575),
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                  Text(
                                                                      translation(
                                                                              context)
                                                                          .verifyInfo2,
                                                                      style: TextStyle(
                                                                          fontSize: 16
                                                                              .sp,
                                                                          color: Color(
                                                                              0xff757575),
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                  SizedBox(
                                                                      height:
                                                                          30.h),
                                                                  Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Code",
                                                                            style: TextStyle(
                                                                                fontSize: 18.sp,
                                                                                color: Color(0xff333333),
                                                                                fontWeight: FontWeight.w600)),
                                                                        SizedBox(
                                                                            height:
                                                                                7.h),
                                                                        TextFormField(
                                                                            controller:
                                                                                codeController,
                                                                            decoration: InputDecoration(
                                                                                fillColor: Color(0xffF8f8f8),
                                                                                filled: true,
                                                                                hintText: translation(context).enterCode,
                                                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
                                                                            validator: (String? value) {
                                                                              if (value == null || value == '') {
                                                                                return 'Code is required*';
                                                                              }
                                                                              return null;
                                                                            }),
                                                                        SizedBox(
                                                                            height:
                                                                                30.h),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              (() {
                                                                            if (formKeyLcode.currentState!.validate()) {
                                                                              CheckCode();
                                                                            }
                                                                          }),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Spacer(),
                                                                              Text(translation(context).checknLogin),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                          style: ButtonStyle(
                                                                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r), side: BorderSide(color: Color(0xff0056d7), width: 1.5))),
                                                                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                                                  //horizontal: 150.w,
                                                                                  vertical: 24.h)),
                                                                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600)),
                                                                              backgroundColor: MaterialStateProperty.all(mainHover ? Colors.black : const Color(0XFF5118AA)),
                                                                              foregroundColor: MaterialStateProperty.all(Colors.white)),
                                                                        )
                                                                      ]),
                                                                  SizedBox(
                                                                      height:
                                                                          30.h)
                                                                ]),
                                                          ));
                                                    }));
                                              });
                                        });
                                      }
                                    }),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Text(translation(context).logIn),
                                        Spacer()
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.r),
                                                side: BorderSide(
                                                    color: Color(0xff0056d7),
                                                    width: 1.5))),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                // horizontal: 200.w,
                                                vertical: 25.h)),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500)),
                                        backgroundColor:
                                            MaterialStateProperty.all(mainHover
                                                ? Colors.black
                                                : const Color(0XFF5118AA)),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                  SizedBox(height: 28.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(translation(context).forgetpass,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 18.sp,
                                            color: Color(0xff5118aa),
                                            fontWeight: FontWeight.w400)),
                                  )
                                ])
                          ],
                        ),
                      )),
          )
        ],
      )),
    );
  }
}
