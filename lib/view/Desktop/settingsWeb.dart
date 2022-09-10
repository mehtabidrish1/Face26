import 'package:face26_mobile/backend/apis/buyPhotoApi.dart';
import 'package:face26_mobile/utils/authentication/googleAuth.dart';
import 'package:face26_mobile/view/homePage.dart';
import 'package:face26_mobile/widgets/checkout_page.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsWeb extends StatefulWidget {
  dynamic credits;
  dynamic purchased;
  SettingsWeb({Key? key, required this.purchased, this.credits})
      : super(key: key);

  @override
  State<SettingsWeb> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWeb> {
  BuyPhotoService buyPhotoService = BuyPhotoService();
  TextEditingController emailController = TextEditingController();
  final deleteUrl =
      Uri.parse('http://info@face26.com/?subject=Delete%20my%20account');
  final privacyUrl = Uri.parse('https://face26.com/privacy-policy/');
  final rateUsUrl = Uri.parse('https://www.trustpilot.com/review/face26.com');

  bool subscribe = true;
  String token = '';
  bool mainHover = false;
  bool downHover = false;
  //dynamic user;
  //dynamic credits = 0;
  //dynamic purchased = 0;
  bool uploadHover = false;
  bool uploadHover1 = false;
  bool uploadHover2 = false;
  bool uploadHover3 = false;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth') ?? '';
    print("pref ka token $token");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (credits != 'null') {
    //   credits = widget.credits;
    // }
    // print(widget.user.runtimeType);
    // if (widget.user == 'null') {
    //   print("user k andar");
    // } else {
    //   user = widget.user;
    //   //emailController.text = widget.user!.email!;
    //   credits = user.credits!;
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return (size < 600)
        ? mobileSettings()
        : Scaffold(
            appBar: AppBar(
              elevation: 1,
              leadingWidth: 79.w,
              backgroundColor: Colors.white,
              leading: Row(
                children: [
                  SizedBox(width: 22.w),
                  SizedBox(
                    height: 53.h,
                    width: 53.w,
                    child: Image.asset("assets/icons/icon.png"),
                  ),
                ],
              ),
              toolbarHeight: 76.h,
              actions: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: Colors.black,
                    ),
                    SizedBox(width: 30.w),
                    Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                    ),
                    SizedBox(width: 30.w),
                    ElevatedButton(
                      onHover: (value) {
                        downHover = value;
                        setState(() {});
                      },
                      onPressed: (() async {
                        if (widget.credits == 'null') {
                          Navigator.pushNamed(context, '/login?oId=');
                        } else if (widget.credits > 0) {
                          // await buyPhotoService.buyPhoto(token, oId!).then(
                          //   (value) {
                          //     showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return BackdropFilter(
                          //               filter:
                          //                   ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          //               child: DownloadBox(link: link, name: name));
                          //         });
                          //   },
                          // );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xff5118aa),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.r)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0.h, vertical: 0.h),
                                  content: Checkout(
                                    token: token,
                                  ),
                                );
                              });
                        }
                      }),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset("assets/icons/download.png")),
                          SizedBox(width: 10),
                          Text(
                            translation(context).download,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.r))),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 17.w, vertical: 23.h)),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400)),
                          backgroundColor: MaterialStateProperty.all(downHover
                              ? Colors.black
                              : const Color(0XFF5118AA)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                    SizedBox(width: 15.w),
                    SizedBox(
                        width: 53.w,
                        height: 53.h,
                        child: CircleAvatar(
                            radius: 50.r, child: Icon(Icons.person))),
                    SizedBox(width: 28.w)
                  ],
                )
              ],
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 133.w,
                  decoration: BoxDecoration(
                      color: Color(0xff350b77),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r))),
                  child: Column(
                    children: [
                      SizedBox(height: 73.h),
                      InkWell(
                        onHover: (value) {
                          setState(() {
                            uploadHover = value;
                          });
                        },
                        onTap: () {
                          Navigator.of(context).pop();
                          // if (myUpload == false) {
                          //   setState(() {
                          //     myUpload = true;
                          //   });
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.all(5),
                          width: 80,
                          decoration: BoxDecoration(
                            color: uploadHover
                                ? Colors.black
                                : const Color(0xff350b77),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 19.h,
                                  width: 23.w,
                                  child: Image.asset(
                                      "assets/icons/cloudwhite.png")),
                              SizedBox(height: 9.h),
                              Text(translation(context).myUploads,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 74.h),
                      InkWell(
                        onHover: (value) {
                          setState(() {
                            uploadHover1 = value;
                          });
                        },
                        onTap: () {
                          Navigator.of(context).pop();
                          // if (myUpload == true) {
                          //   setState(() {
                          //     myUpload = false;
                          //   });
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.all(5),
                          width: 80,
                          decoration: BoxDecoration(
                            color: uploadHover1
                                ? Colors.black
                                : const Color(0xff350b77),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 25.h,
                                  width: 24.w,
                                  child: Image.asset(
                                      "assets/icons/beautywhite.png")),
                              SizedBox(height: 9.h),
                              Text(translation(context).getInspired,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 74.h),
                      InkWell(
                        onHover: (value) {
                          setState(() {
                            uploadHover2 = value;
                          });
                        },
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.all(5),
                          width: 80,
                          decoration: BoxDecoration(
                            color: uploadHover2
                                ? Colors.black
                                : const Color(0xff350b77),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 24.h,
                                  width: 23.w,
                                  child: Image.asset(
                                      "assets/icons/settingswhite.png")),
                              SizedBox(height: 9.h),
                              Text(translation(context).settings,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 74.h),
                      InkWell(
                        onHover: (value) {
                          setState(() {
                            uploadHover3 = value;
                          });
                        },
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('auth');
                          Navigator.pushNamed(context, '/');
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => HomeWeb()));
                          await FacebookAuth.instance.logOut();
                          await googleSignIn.signOut();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          margin: EdgeInsets.all(5),
                          width: 80,
                          decoration: BoxDecoration(
                            color: uploadHover3
                                ? Colors.black
                                : const Color(0xff350b77),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 29.h,
                                  width: 28.w,
                                  child: Image.asset(
                                      "assets/icons/logoutwhite.png")),
                              SizedBox(height: 9.h),
                              Text(translation(context).logout,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xff5118aa),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.r)),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0.h, vertical: 0.h),
                                  content: Checkout(
                                    token: token,
                                  ),
                                );
                              });
                        },
                        child: SizedBox(
                          width: 107.w,
                          height: 44.h,
                          child: Image.asset("assets/icons/prowhite.png"),
                        ),
                      ),
                      SizedBox(height: 58.h)
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 52.h),
                        Text(translation(context).settings,
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       subscribe = false;
                            //     });
                            //   },
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       Text("Account",
                            //           style: TextStyle(
                            //               fontSize: 20.sp,
                            //               color: subscribe
                            //                   ? Color(0xff000000)
                            //                   : Color(0xff5118aa),
                            //               fontWeight: subscribe
                            //                   ? FontWeight.w400
                            //                   : FontWeight.w700)),
                            //       SizedBox(height: 5.h),
                            //       SizedBox(
                            //         width: 95.w,
                            //         child: Divider(
                            //           color: subscribe
                            //               ? Colors.transparent
                            //               : Color(0xff5118aa),
                            //           thickness: 3,
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(width: 36.w),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  subscribe = true;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(translation(context).billnsub,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: subscribe
                                              ? Color(0xff5118aa)
                                              : Color(0xff000000),
                                          fontWeight: subscribe
                                              ? FontWeight.w700
                                              : FontWeight.w400)),
                                  SizedBox(height: 5.h),
                                  SizedBox(
                                    width: 226.w,
                                    child: Divider(
                                      color: subscribe
                                          ? Color(0xff5118aa)
                                          : Colors.transparent,
                                      thickness: 3,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        subscribe
                            ? SizedBox(
                                width: 358.w,
                                // height: 570.h,
                                child: Column(children: [
                                  SizedBox(height: 100.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(translation(context).purchasedPhoto,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      Text("0x Photos",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Color(0xFF5118AA),
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(translation(context).usedPhoto,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      Text("${widget.purchased}x Photos",
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Color(0xFF5118AA),
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                      indent: 10,
                                      endIndent: 10),
                                  SizedBox(height: 15.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(translation(context).canEdit,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                      Text("${widget.credits}x Photos",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Color(0xFF5118AA),
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  SizedBox(height: 79.h),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            //await launchUrl(deleteUrl);
                                            final Uri params = Uri(
                                                scheme: 'mailto',
                                                path: 'info@face26.com',
                                                query:
                                                    'subject=Delete my account');

                                            String url = params.toString();
                                            if (await canLaunchUrl(params)) {
                                              await launchUrl(params);
                                              print("launch url chl gya");
                                            } else {
                                              print('Could not launch $url');
                                            }
                                          },
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translation(context)
                                                    .deleteAccount,
                                                style: TextStyle(
                                                    color: Color(0xFF453C53)),
                                              ),
                                              // SizedBox(width: 105.w),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0XFF5118AA),
                                              )
                                            ],
                                          ),
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              side: MaterialStateProperty.all(
                                                const BorderSide(
                                                  color: Color(0xffcecece),
                                                  width: 1,
                                                ),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.r))),
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 32.w,
                                                      vertical: 30.h)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(Colors.white))),
                                      SizedBox(height: 20.h),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await launchUrl(privacyUrl);
                                          },
                                          child: Row(
                                            //mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translation(context).privacy,
                                                style: TextStyle(
                                                    color: Color(0xFF453C53)),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0XFF5118AA),
                                              )
                                            ],
                                          ),
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              side: MaterialStateProperty.all(
                                                const BorderSide(
                                                  color: Color(0xffcecece),
                                                  width: 1,
                                                ),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.r))),
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 32.w,
                                                      vertical: 30.h)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(Colors.white))),
                                      SizedBox(height: 20.h),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await launchUrl(rateUsUrl);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                translation(context).rateUs,
                                                style: TextStyle(
                                                    color: Color(0xFF453C53)),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0XFF5118AA),
                                              )
                                            ],
                                          ),
                                          style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                              side: MaterialStateProperty.all(
                                                const BorderSide(
                                                  color: Color(0xffcecece),
                                                  width: 1,
                                                ),
                                              ),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.r))),
                                              padding: MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      horizontal: 32.w,
                                                      vertical: 30.h)),
                                              textStyle:
                                                  MaterialStateProperty.all(
                                                      TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(Colors.white)))
                                    ],
                                  )
                                ]),
                              )
                            : Expanded(
                                child: Column(children: [
                                  SizedBox(height: 30.h),
                                  Container(
                                    height: 122.h,
                                    width: 122.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xff5118aa),
                                            width: 3.25.r)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: CircleAvatar(
                                          child: Icon(Icons.person),
                                          backgroundColor: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 25.h),
                                  ElevatedButton(
                                    onPressed: (() {}),
                                    child: Text("Upload New Image",
                                        style: TextStyle(color: Colors.black)),
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Color(0xffa5a5a5),
                                              width: 1.3.w)),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 25.h)),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xffffffff)),
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  SizedBox(
                                    width: 752.w,
                                    height: 227.h,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Username",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: Color(0xff333333),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(height: 7.h),
                                              SizedBox(
                                                width: 362.w,
                                                height: 60.h,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      fillColor:
                                                          Color(0xffF8f8f8),
                                                      filled: true,
                                                      hintText:
                                                          "Add your username",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffd8d8d8),
                                                              width: 1.5))),
                                                ),
                                              ),
                                              SizedBox(height: 38.h),
                                              Text("Email",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: Color(0xff333333),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(height: 7.h),
                                              SizedBox(
                                                width: 362.w,
                                                height: 60.h,
                                                child: TextField(
                                                  enabled: false,
                                                  controller: emailController,
                                                  decoration: InputDecoration(
                                                      fillColor:
                                                          Color(0xffF8f8f8),
                                                      filled: true,
                                                      hintText:
                                                          "Enter your email",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffd8d8d8),
                                                              width: 1.5))),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 28.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Full name",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: Color(0xff333333),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(height: 7.h),
                                              SizedBox(
                                                width: 362.w,
                                                height: 60.h,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      fillColor:
                                                          Color(0xffF8f8f8),
                                                      filled: true,
                                                      hintText:
                                                          "Add your Full name",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffd8d8d8),
                                                              width: 1.5))),
                                                ),
                                              ),
                                              SizedBox(height: 38.h),
                                              Text("Password",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: Color(0xff333333),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(height: 7.h),
                                              SizedBox(
                                                width: 362.w,
                                                height: 60.h,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      fillColor:
                                                          Color(0xffF8f8f8),
                                                      filled: true,
                                                      hintText:
                                                          "Create Password",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xffd8d8d8),
                                                              width: 1.5))),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  ElevatedButton(
                                    onHover: (value) {
                                      mainHover = value;
                                      setState(() {});
                                    },
                                    onPressed: (() {}),
                                    child: Text("Save Changes"),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.r),
                                            side: BorderSide(
                                                color: Color(0xff0056d7),
                                                width: 1.5))),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 83.w,
                                                vertical: 35.h)),
                                        textStyle: MaterialStateProperty.all(TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700)),
                                        backgroundColor:
                                            MaterialStateProperty.all(mainHover
                                                ? Colors.black
                                                : const Color(0XFF5118AA)),
                                        foregroundColor: MaterialStateProperty.all(Colors.white)),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: 752.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Delete Your Account",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w700)),
                                        SizedBox(height: 10.h),
                                        Text(
                                            "By deleting your account, all your data, including your edits, collections, and likes will be deleted.",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w400))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 70.h)
                                ]),
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Widget mobileSettings() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 35.h),
                  InkWell(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.black),
                        Text("Back",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                  Text(translation(context).settings,
                      style: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(translation(context).purchasedPhoto,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text("0x Photos",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF5118AA),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(translation(context).usedPhoto,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text("${widget.purchased}x Photos",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF5118AA),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Divider(
                      thickness: 1,
                      color: Colors.grey,
                      indent: 10,
                      endIndent: 10),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(translation(context).canEdit,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      Text("${widget.credits}x Photos",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFF5118AA),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 250.w,
                      child: ElevatedButton(
                        onPressed: (() async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('auth');
                          await googleSignIn.signOut();
                          if (kIsWeb) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          }
                          await FacebookAuth.instance.logOut();
                        }),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(translation(context).logout),
                            Spacer()
                          ],
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r))),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.symmetric(
                                    //horizontal: 150.w,
                                    vertical: 18.h)),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w600)),
                            backgroundColor: MaterialStateProperty.all(mainHover
                                ? Colors.black
                                : const Color(0XFF5118AA)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                        onPressed: () async {
                          await launchUrl(deleteUrl);
                        },
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translation(context).deleteAccount,
                              style: TextStyle(color: Color(0xFF453C53)),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0XFF5118AA),
                            )
                          ],
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Color(0xffcecece),
                                width: 1,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.r))),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 29.w, vertical: 18.h)),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w400)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white))),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                        onPressed: () async {
                          await launchUrl(privacyUrl);
                        },
                        child: Row(
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translation(context).privacy,
                              style: TextStyle(color: Color(0xFF453C53)),
                            ),
                            // SizedBox(width: 145),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0XFF5118AA),
                            )
                          ],
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Color(0xffcecece),
                                width: 1,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.r))),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 29.w, vertical: 18.h)),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w400)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white))),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                        onPressed: () async {
                          await launchUrl(rateUsUrl);
                        },
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translation(context).rateUs,
                              style: TextStyle(color: Color(0xFF453C53)),
                            ),
                            // SizedBox(width: 80),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0XFF5118AA),
                            )
                          ],
                        ),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                color: Color(0xffcecece),
                                width: 1,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 29.w, vertical: 18.h)),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w400)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white))),
                    SizedBox(height: 50.h)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
