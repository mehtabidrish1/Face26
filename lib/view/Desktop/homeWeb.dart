import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:face26_mobile/backend/apis/getTokenApi.dart';
import 'package:face26_mobile/backend/apis/trackerApi.dart';
import 'package:face26_mobile/backend/apis/uploadApi.dart';
import 'package:face26_mobile/backend/models/uploadModel.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:face26_mobile/widgets/sliderScreenIntro.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({Key? key}) : super(key: key);

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  GetTokenService getTokenService = GetTokenService();
  TrackerService trackerService = TrackerService();
  UploadService uploadService = UploadService();
  late UploadModel uploadModel;

  Image? blurBefore, blurAfter, bwBefore, bwAfter, beautyBefore, beautyAfter;
  String track = '';
  bool dragging = false;
  bool a = true;
  bool b = false;
  bool c = false;
  String email = '';
  Uint8List? byte;
  String? oId;

  Widget circle = SizedBox(
      width: 17.w,
      height: 17.h,
      child: Image.asset("assets/icons/circlewhite.png"));
  Widget ellipse = SizedBox(
      width: 56.w,
      height: 17.h,
      child: Image.asset("assets/icons/ellipsewhite.png"));

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    track = prefs.getString('auth') ?? '';
    print("pref ka token $track");
    if (track == '') {
      await getTokenService.getToken(context).then((value) async {
        track = value.accessToken;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth', track);
      });
    } else {
      Navigator.pushNamed(context, '/editor?oId=$oId');
    }
    getData();
  }

  getData() async {
    await trackerService
        .tracker(
            track.substring(track.length - 8), email, "photo_upload", context)
        .then((value) async {
      print("tracker chl gya ${value}");
      (byte != null) ? uploadImage(byte!) : print("byte null h");
    });
  }

  uploadImage(Uint8List byte) async {
    await uploadService.uploadImageWeb(track, byte).then((value) async {
      //uploadModel = value;
      oId = value.photoId.oid;
      Navigator.pushNamed(context, 'editor?oId=$oId');
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => EditorWeb(oId: oId)));
      //optimizeImage(token, uploadModel.photoId.oid);
    });
    //syncData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blurBefore =
        Image.asset("assets/images/blurry_back.png", fit: BoxFit.contain);
    blurAfter =
        Image.asset("assets/images/splash_back.png", fit: BoxFit.contain);
    bwBefore = Image.asset("assets/images/bw_before.png", fit: BoxFit.contain);
    bwAfter = Image.asset("assets/images/bw_after.png", fit: BoxFit.contain);
    beautyBefore =
        Image.asset("assets/images/beauty_before.png", fit: BoxFit.contain);
    beautyAfter =
        Image.asset("assets/images/beauty_after.png", fit: BoxFit.contain);
    checkToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(blurBefore!.image, context);
    precacheImage(blurAfter!.image, context);
    precacheImage(bwBefore!.image, context);
    precacheImage(bwAfter!.image, context);
    precacheImage(beautyBefore!.image, context);
    precacheImage(beautyAfter!.image, context);
  }

  late DropzoneViewController controller1;

  String message1 = 'Drop something here';
  String message2 = 'Drop something here';
  bool highlighted1 = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Widget buildZone1(BuildContext context) => Builder(
          builder: (context) => DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (ctrl) => controller1 = ctrl,
            onLoaded: () => print('Zone 1 loaded'),
            onError: (ev) => print('Zone 1 error: $ev'),
            onHover: () {
              setState(() => highlighted1 = true);
              print('Zone 1 hovered');
            },
            onLeave: () {
              setState(() => highlighted1 = false);
              print('Zone 1 left');
            },
            onDrop: (ev) async {
              print('Zone 1 drop: ${ev.name}');
              setState(() {
                message1 = '${ev.name} dropped';
                highlighted1 = false;
              });
              byte = await controller1.getFileData(ev);
              final name = await controller1.getFilename(ev);
              final url = await controller1.createFileUrl(ev);

              bool isImage = name.endsWith('png') ||
                  name.endsWith('jpg') ||
                  name.endsWith('jpeg');
              if (isImage) {
                try {
                  getData();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => EditorWeb(
                  //           image: byte,
                  //         )));
                } catch (e) {
                  Toast.show("Error occured $e",
                      duration: 2, gravity: Toast.bottom);
                }
              } else {
                Toast.show("Please Provide a Valid Image format ",
                    duration: 2, gravity: Toast.bottom);
              }
            },
            onDropMultiple: (ev) async {
              print('Zone 1 drop multiple: $ev');
            },
          ),
        );

    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 1087.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 209.h),
              SizedBox(
                height: 110.h,
                width: 110.w,
                child: Image.asset("assets/icons/icon.png"),
              ),
              SizedBox(height: 28.h),
              Text(translation(context).homeTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 38.sp,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700)),
              // Text("One Click",
              //     style: TextStyle(
              //         fontSize: 38.sp,
              //         color: Color(0xff333333),
              //         fontWeight: FontWeight.w700)),
              SizedBox(height: 20.h),
              SizedBox(
                width: 425.w,
                child: Text(translation(context).homeText,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xff757575),
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 29.h),
              DottedBorder(
                  radius: Radius.circular(5.15.r),
                  color: Color(0xff384eb7).withOpacity(0.30),
                  strokeWidth: 1.29,
                  dashPattern: [7, 4],
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            highlighted1 ? Colors.blueGrey : Color(0xfff8f8ff)),
                    width: 572.w,
                    height: 260.h,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          buildZone1(context),
                          InkWell(
                            onTap: () async {
                              await FilePicker.platform
                                  .pickFiles(type: FileType.image)
                                  .then((value) async {
                                if (value != null) {
                                  byte = value.files.first.bytes;
                                  getData();
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         EditorWeb(oId: oId)));
                                } else
                                  Toast.show("No Image selected",
                                      duration: 2, gravity: Toast.bottom);
                              });
                              // await ImagePickerWeb.getImageAsBytes()
                              //     .then((value) async {
                              //   if (value != null) {
                              //     SharedPreferences prefs =
                              //         await SharedPreferences.getInstance();
                              //     prefs.setString('auth', track);
                              //     Navigator.of(context).push(MaterialPageRoute(
                              //         builder: (context) => EditorWeb(
                              //               token: track,
                              //               image: value,
                              //             )));
                              //   } else
                              //     Toast.show("No Image selected",
                              //         duration: 2, gravity: Toast.bottom);
                              // });
                            },
                            child: Container(
                              color: Colors.white,
                              width: 572.w,
                              height: 260.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 38.h),
                                  SizedBox(
                                      width: 88.w,
                                      height: 76.h,
                                      child: Image.asset(
                                          "assets/icons/uploadcloud.png")),
                                  SizedBox(height: 32.h),
                                  RichText(
                                    text: TextSpan(
                                        text: 'Drag & drop files or ',
                                        style: TextStyle(
                                            color: Color(0xff0f0f0f),
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Browse',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Color(0xff483ea8),
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700),
                                            // recognizer: TapGestureRecognizer()
                                            //   ..onTap = () async {
                                            //     await FilePicker.platform
                                            //         .pickFiles(
                                            //             type: FileType.image)
                                            //         .then((value) async {
                                            //       if (value != null) {
                                            //         SharedPreferences prefs =
                                            //             await SharedPreferences
                                            //                 .getInstance();
                                            //         prefs.setString(
                                            //             'auth', track);
                                            //         var image = value
                                            //             .files.first.bytes;
                                            //         Navigator.of(context).push(
                                            //             MaterialPageRoute(
                                            //                 builder: (context) =>
                                            //                     EditorWeb(
                                            //                         image:
                                            //                             image)));
                                            //       } else
                                            //         Toast.show(
                                            //             "No Image selected",
                                            //             duration: 2,
                                            //             gravity:
                                            //                 Toast.bottom);
                                            //     });
                                            //   }
                                          )
                                        ]),
                                  ),
                                  SizedBox(height: 13.h),
                                  Text("Supported formates: JPEG, PNG       ",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Color(0xff676767),
                                          fontWeight: FontWeight.w400))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Container(
          width: 833.w,
          color: Color(0xff5118aa),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 90.h),
                SizedBox(
                  height: 503.25,
                  width: 242,
                  child: Stack(children: [
                    Container(
                      width: 242,
                      height: 503.25,
                      child: a
                          ? blurBefore
                          : b
                              ? bwBefore
                              : beautyBefore,
                    ),
                    VerticalSplitViewIntro(
                        left: Container(),
                        right: a
                            ? blurAfter!
                            : b
                                ? bwAfter!
                                : beautyAfter!),
                  ]),
                ),
                SizedBox(height: 50.h),
                SizedBox(
                  width: 121.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              a = true;
                              b = false;
                              c = false;
                            });
                          },
                          child: a ? ellipse : circle),
                      InkWell(
                          onTap: () {
                            setState(() {
                              a = false;
                              b = true;
                              c = false;
                            });
                          },
                          child: b ? ellipse : circle),
                      InkWell(
                          onTap: () {
                            setState(() {
                              a = false;
                              b = false;
                              c = true;
                            });
                          },
                          child: c ? ellipse : circle)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
