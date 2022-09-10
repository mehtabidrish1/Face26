import 'dart:io';
import 'dart:typed_data';
import 'package:face26_mobile/backend/apis/buyPhotoApi.dart';
import 'package:face26_mobile/backend/apis/colorizeApi.dart';
import 'package:face26_mobile/view/homePage.dart';
import 'package:face26_mobile/view/loginPage.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:face26_mobile/widgets/percentIndicatorWidget.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:face26_mobile/backend/apis/optimizeApi.dart';
import 'package:face26_mobile/backend/apis/photoInfoApi.dart';
import 'package:face26_mobile/backend/apis/syncApi.dart';
import 'package:face26_mobile/backend/models/photoInfoModel.dart';
import 'package:face26_mobile/backend/models/syncModel.dart';
import 'package:face26_mobile/widgets/sliderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ImageEditorWeb extends StatefulWidget {
  String oId;
  ImageEditorWeb({Key? key, required this.oId}) : super(key: key);

  @override
  State<ImageEditorWeb> createState() => _ImageEditorWebState();
}

class _ImageEditorWebState extends State<ImageEditorWeb> {
  OptimizeService optimizeService = OptimizeService();
  SyncService syncService = SyncService();
  late SyncModel syncModel;
  PhotoInfoService photoInfoService = PhotoInfoService();
  late PhotoInfoModel photoInfoModel;
  ColorizeService colorizeService = ColorizeService();
  BuyPhotoService buyPhotoService = BuyPhotoService();

  bool color = false;
  bool upload = false;
  bool hd = false;
  bool apiData = false;
  Image? mainImage;
  bool optimized = false;
  bool dragBar = false;
  bool saver = false;
  List<Photo> photos = [];
  String token = '';
  String oId = '';
  String name = '';
  String email = '';
  Image? img;
  String link = '';
  double percent = 0.0;
  int percentage = 0;
  bool purchased = false;
  User? user;
  int? credits = null;
  bool colorized = false;
  final viewerController = TransformationController();

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth') ?? '';
    if (oId != '') {
      getData(oId);
      syncData();
    }
  }

  optimizeImage(String token, String oid) async {
    setState(() {
      percent = 0.24;
      percentage = 24;
    });
    await optimizeService.optimize(token, oid).then((Response value) async {
      setState(() {
        percent = 0.49;
        percentage = 49;
        optimized = true;
        //syncData();
        photoInfo(token, oid);
      });
      print("optimize ho gya ${value.body}");
    });
  }

  colorizeImage(String token, String oid) async {
    setState(() {
      percent = 0.24;
      percentage = 24;
    });
    await colorizeService.colorize(token, oid).then((Response value) async {
      setState(() {
        percent = 0.49;
        percentage = 49;
        colorized = true;
        //syncData();
        photoInfo(token, oid);
      });
      print("colorize ho gya ${value.body}");
    });
  }

  photoInfo(String token, String oid) async {
    String tag = hd
        ? '_optimized'
        : color
            ? '_optimized_colorized'
            : '';
    setState(() {
      percent = 0.76;
      percentage = 76;
    });
    await photoInfoService.photoInfo(token, oid).then((value) {
      photoInfoModel = value;
      print(photoInfoModel.id!.oid);
      link =
          'https://api.face26.com/user/photo?photo_id=${photoInfoModel.id!.oid}&tag=$tag';
      name =
          photoInfoModel.id!.oid!.substring(photoInfoModel.id!.oid!.length - 8);
      img = Image.network(link, fit: BoxFit.contain);
      setState(() {
        percent = 0;
        percentage = 0;

        upload = false;
        // if (color) {
        //   //colors = true;
        // } else {
        dragBar = true;
        // }
      });
    });
  }

  syncData() async {
    photos.clear();
    //purchased = 0;
    await syncService.sync(token, context).then((value) async {
      syncModel = value;
      if (syncModel.user != null) {
        user = syncModel.user;
        credits = syncModel.user!.credits;
      }
      if (syncModel.photos!.isNotEmpty) {
        photos = syncModel.photos!;
        for (Photo e in photos) {
          if (e.id!.oid == oId) {
            if (e.purchased == true) {
              purchased = true;
            }
          }
        }
        setState(() {});
      }
    });
  }

  getData(String oId) {
    mainImage = Image.network(
        'https://api.face26.com/user/photo?photo_id=$oId&tag=',
        fit: BoxFit.contain);
    apiData = true;
    setState(() {});
  }

  int _total = 0, _received = 0;
  late http.StreamedResponse _response;
  File? _image;
  final List<int> _bytes = [];

  Future<void> _downloadImage(String imgLink, String imgName) async {
    _response =
        await http.Client().send(http.Request('GET', Uri.parse(imgLink)));
    _total = _response.contentLength ?? 0;

    _response.stream.listen((value) {
      setState(() {
        _bytes.addAll(value);
        _received += value.length;
        percent = double.parse((_received / _total).toStringAsFixed(2));
        percentage = int.parse(((_received / _total) * 100).toStringAsFixed(0));
      });
    }).onDone(() async {
      var imgByte = Uint8List.fromList(_bytes);
      await FileSaver.instance
          .saveFile(name, imgByte, 'png', mimeType: MimeType.PNG);
      saver = false;
      percent = 0;
      percentage = 0;
      Toast.show("Downloaded", duration: 2, gravity: Toast.bottom);
      setState(() {
        //_image = file;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
    oId = widget.oId;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 18.w),
                InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      Navigator.pushNamed(context, '/home');
                    } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios_new_outlined,
                          color: Color(0xff453c53)),
                      SizedBox(width: 4.w),
                      Text("Back",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xff453c53),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                SizedBox(width: 88.w),
                Text("Editor",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xff453c53),
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 37.w),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.r),
                                topRight: Radius.circular(30.r))),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30.h),
                                Text(translation(context).sharingText,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Color(0xff453c53),
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 28.h),
                                SizedBox(
                                  width: 236.w,
                                  height: 44.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset("assets/icons/linkedin.png"),
                                      Image.asset("assets/icons/twitter.png"),
                                      Image.asset("assets/icons/facebook.png"),
                                      Image.asset("assets/icons/instagram.png"),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 22.h),
                                SizedBox(
                                  width: 358.w,
                                  height: 54.h,
                                  child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          height: 52.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 15.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                              border: Border.all(
                                                  color: Color(0xffcecece),
                                                  width: 1.0,
                                                  style: BorderStyle.solid)),
                                          child: Text(link,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Color(0xff453c53),
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(
                                                ClipboardData(text: link));
                                            Toast.show("Copied",
                                                duration: 2,
                                                gravity: Toast.bottom);
                                          },
                                          child: Image.asset(
                                              "assets/icons/copyIcon.png"),
                                        )
                                      ]),
                                )
                              ],
                            ),
                            height: 236.h,
                          );
                        });
                  },
                  child: SizedBox(
                      height: 26.h,
                      width: 26.w,
                      child: Image.asset("assets/icons/upload.png")),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () async {
                    percent = 0;
                    percentage = 0;
                    if (credits == null) {
                      if (kIsWeb) {
                        Navigator.pushNamed(context, '/login?oId=$oId');
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  oId: oId,
                                )));
                      }
                    } else if (purchased) {
                      if (link == '') {
                      } else {
                        await _downloadImage(link, name);
                        saver = true;
                        setState(() {});
                      }
                    } else if (credits! > 0) {
                      await buyPhotoService
                          .buyPhoto(token, oId)
                          .then((value) async {
                        if (link == '') {
                        } else {
                          await _downloadImage(link, name);
                          saver = true;
                          setState(() {});
                        }
                      });
                    } else
                      Toast.show("Not enough credits",
                          duration: 2, gravity: Toast.bottom);
                  },
                  child: SizedBox(
                      height: 44.h,
                      width: 71.w,
                      child: Image.asset("assets/icons/savebutton.png")),
                ),
                SizedBox(width: 16.w),
              ],
            ),
            SizedBox(height: 30.h),
            Expanded(
                child: apiData
                    ? Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: InteractiveViewer(
                          transformationController: viewerController,
                          minScale: 1.0,
                          maxScale: 2.0,
                          child: Stack(alignment: Alignment.center, children: [
                            Center(
                              child: mainImage,
                            ),
                            dragBar
                                ? VerticalSplitView(
                                    left: Container(),
                                    right: Center(child: img))
                                : SizedBox(),
                            upload
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(translation(context).optimizing,
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 20),
                                        CirclePercentIndicator(
                                            percent: percent,
                                            percentage: percentage)
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            saver
                                ? Center(
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 20.h),
                                            Text(translation(context).saving,
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Color(0xff453c53),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            SizedBox(height: 20.h),
                                            CirclePercentIndicator(
                                                percent: percent,
                                                percentage: percentage),
                                            SizedBox(height: 20.h),
                                            SizedBox(
                                                width: 89.w,
                                                height: 44.h,
                                                child: Image.asset(
                                                    "assets/icons/cancel.png")),
                                            SizedBox(height: 25.h)
                                          ],
                                        ),
                                        height: 236.h,
                                        width: 300.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          color: Colors.white,
                                        )),
                                  )
                                : SizedBox(),
                          ]),
                        ),
                      )
                    : Center(child: CircularProgressIndicator())),
            SizedBox(
                height: 150.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              viewerController.value = Matrix4.identity();
                              hd = !hd;
                              color = false;
                              dragBar = false;
                              if (hd) {
                                if (optimized) {
                                  photoInfo(token, oId);
                                  dragBar = true;
                                } else {
                                  optimizeImage(token, oId);
                                  upload = true;
                                }
                              } else if (!hd) {
                                upload = false;
                              }
                            });
                          },
                          child: SizedBox(
                              width: 35.w,
                              height: 35.h,
                              child: Image.asset("assets/icons/HDbutton.png",
                                  color: hd ? const Color(0xff5118aa) : null)),
                        ),
                        SizedBox(height: 17.5.h),
                        Text(translation(context).superResolution,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xff453c53),
                                fontWeight: FontWeight.w500)),
                        // Text("Resolution",
                        //     style: TextStyle(
                        //         fontSize: 14.sp,
                        //         color: Color(0xff453c53),
                        //         fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              viewerController.value = Matrix4.identity();
                              color = !color;
                              dragBar = false;
                              hd = false;
                              if (color) {
                                if (colorized) {
                                  photoInfo(token, oId);
                                  dragBar = true;
                                } else {
                                  colorizeImage(token, oId);
                                  upload = true;
                                }
                              } else if (!color) {
                                upload = false;
                              }
                            });
                          },
                          child: SizedBox(
                              width: 35.w,
                              height: 35.h,
                              child: Image.asset(
                                "assets/icons/addcolorbutton.png",
                                color: color ? const Color(0xff5118aa) : null,
                              )),
                        ),
                        SizedBox(height: 17.5.h),
                        Text(translation(context).addColorization,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Color(0xff453c53),
                                fontWeight: FontWeight.w500)),
                        // Text("Colorization",
                        //     style: TextStyle(
                        //         fontSize: 14.sp,
                        //         color: Color(0xff453c53),
                        //         fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
