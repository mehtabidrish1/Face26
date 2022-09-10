import 'dart:typed_data';
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:face26_mobile/backend/apis/buyPhotoApi.dart';
import 'package:face26_mobile/backend/apis/colorizeApi.dart';
import 'package:face26_mobile/backend/apis/deleteImageApi.dart';
import 'package:face26_mobile/backend/apis/getTokenApi.dart';
import 'package:face26_mobile/utils/authentication/googleAuth.dart';
import 'package:face26_mobile/widgets/checkout_page.dart';
import 'package:face26_mobile/widgets/downloader.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:face26_mobile/backend/apis/optimizeApi.dart';
import 'package:face26_mobile/backend/apis/photoInfoApi.dart';
import 'package:face26_mobile/backend/apis/syncApi.dart';
import 'package:face26_mobile/backend/apis/trackerApi.dart';
import 'package:face26_mobile/backend/apis/uploadApi.dart';
import 'package:face26_mobile/backend/models/photoInfoModel.dart';
import 'package:face26_mobile/backend/models/syncModel.dart';
import 'package:face26_mobile/backend/models/uploadModel.dart';
import 'package:face26_mobile/widgets/percentIndicatorWidget.dart';
import 'package:face26_mobile/widgets/sliderScreenWeb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class EditorWeb extends StatefulWidget {
  String? oId;
  EditorWeb({Key? key, this.oId}) : super(key: key);

  @override
  State<EditorWeb> createState() => _EditorWebState();
}

class _EditorWebState extends State<EditorWeb> {
  GetTokenService getTokenService = GetTokenService();
  TrackerService trackerService = TrackerService();
  UploadService uploadService = UploadService();
  late UploadModel uploadModel;
  OptimizeService optimizeService = OptimizeService();
  SyncService syncService = SyncService();
  late SyncModel syncModel;
  PhotoInfoService photoInfoService = PhotoInfoService();
  late PhotoInfoModel photoInfoModel;
  DeleteImageService deleteImageService = DeleteImageService();
  ColorizeService colorizeService = ColorizeService();
  BuyPhotoService buyPhotoService = BuyPhotoService();

  bool color = false;
  bool upload = false;
  bool hd = false;
  bool colorized = false;
  bool tracker = false;
  bool optimized = false;
  bool dragBar = false;
  bool saver = false;
  String token = '';
  String name = '';
  Image? mainImage;
  Image? img;
  List<Photo> photos = [];
  String link = '';
  double percent = 0;
  int percentage = 0;
  double minValue = 1.27;
  Uint8List? byte;
  bool myUpload = true;
  String email = '';
  bool uploadHover = false;
  bool downHover = false;
  String? oId;
  bool apiData = false;
  int credits = 0;
  int purchased = 0;
  User? user;
  TapDownDetails? tapDownDetails;
  bool picLoaded = false;

  bool uploadHover1 = false;
  bool uploadHover2 = false;
  bool uploadHover3 = false;

  final viewerController = TransformationController();

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth') ?? '';
    print("pref ka token $token");
    if (token == '') {
      await getTokenService.getToken(context).then((value) async {
        token = value.accessToken;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth', token);
      });
    }
    syncData();
  }

  getData() async {
    await trackerService
        .tracker(
            token.substring(token.length - 8), email, "photo_upload", context)
        .then((value) async {
      print("tracker chl gya ${value}");
      (byte != null) ? uploadImage(byte!) : print("byte null h");
    });
  }

  uploadImage(Uint8List byte) async {
    await uploadService.uploadImageWeb(token, byte).then((value) async {
      //uploadModel = value;
      oId = value.photoId.oid;
      //optimizeImage(token, uploadModel.photoId.oid);
      mainImage = Image.network(
          'https://api.face26.com/user/photo?photo_id=$oId&tag=',
          fit: BoxFit.contain);
      setState(() {});
    });
    syncData();
  }

  syncData() async {
    photos.clear();
    purchased = 0;
    await syncService.sync(token, context).then((value) async {
      setState(() {
        percent = 0.86;
        percentage = 86;
      });
      syncModel = value;
      // print("model ki value ${syncModel.photos!.first.id!.oid}");
      if (syncModel.user != null) {
        user = syncModel.user;
        credits = syncModel.user!.credits!;
      }
      if (syncModel.photos != null) {
        // syncModel.photos!.forEach((element) {
        //   if (element.purchased! == true) {
        //     purchased++;
        //   }
        //   photos.add(element);
        // });
        for (Photo element in syncModel.photos!) {
          if (element.purchased! == true) {
            purchased++;
          }
          photos.add(element);
        }
      }
      picLoaded = true;
      //apiData = true;
      setState(() {});
    });
  }

  optimizeImage(String token, String oid) async {
    setState(() {
      percent = 0.42;
      percentage = 42;
    });
    await optimizeService.optimize(token, oid).then((Response value) async {
      setState(() {
        percent = 0.70;
        percentage = 70;
        optimized = true;
      });
      print("optimize ho gya ${value.body}");
      syncData();
      photoInfo(token, oid);
    });
  }

  colorizeImage(String token, String oid) async {
    setState(() {
      percent = 0.42;
      percentage = 42;
    });
    await colorizeService.colorize(token, oid).then((Response value) async {
      setState(() {
        percent = 0.70;
        percentage = 70;
        colorized = true;
      });
      print("colorize ho gya ${value.body}");
      syncData();
      photoInfo(token, oid);
    });
  }

  photoInfo(String token, String oid) async {
    String tag = hd
        ? '_optimized'
        : color
            ? '_optimized_colorized'
            : '';
    await photoInfoService.photoInfo(token, oid).then((value) {
      setState(() {
        //img = mainImage;
        percent = 0.94;
        percentage = 94;
      });
      photoInfoModel = value;
      print(photoInfoModel.id!.oid);
      link =
          'https://api.face26.com/user/photo?photo_id=${photoInfoModel.id!.oid}&tag=$tag';
      name =
          photoInfoModel.id!.oid!.substring(photoInfoModel.id!.oid!.length - 8);
      img = Image.network(
        link,
        fit: BoxFit.contain,
      );
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

  deleteImage(String token, String oid) async {
    await deleteImageService
        .deleteImage(token, oid)
        .then((Response value) async {
      print("delete ho gya ${value.body}");
      syncData();
    });
  }

  List<String> images = [
    "assets/grid/picture1.png",
    "assets/grid/picture2.png",
    "assets/grid/picture3.png",
    "assets/grid/picture4.png",
    "assets/grid/picture5.png",
    "assets/grid/picture6.png",
    // "assets/grid/Rectangle447.png",
    // "assets/grid/Rectangle448.png",
    // "assets/grid/Rectangle449.png",
    // "assets/grid/Rectangle450.png",
    // "assets/grid/Rectangle451.png",
    // "assets/grid/Rectangle452.png",
    // "assets/grid/Rectangle441.png",
    // "assets/grid/Rectangle442.png",
    // "assets/grid/Rectangle443.png",
    // "assets/grid/Rectangle444.png",
    // "assets/grid/Rectangle445.png",
    // "assets/grid/Rectangle446.png",
    // "assets/grid/Rectangle447.png",
    // "assets/grid/Rectangle448.png",
    // "assets/grid/Rectangle449.png",
    // "assets/grid/Rectangle450.png",
    // "assets/grid/Rectangle451.png",
    // "assets/grid/Rectangle452.png"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
    (oId != null)
        ? mainImage = Image.network(
            'https://api.face26.com/user/photo?photo_id=$oId&tag=',
            fit: BoxFit.contain)
        : mainImage = null;
    viewerController.value = Matrix4.identity()
      ..translate(-260 * (minValue - 1), -211 * (minValue - 1))
      ..scale(minValue);
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

              print('drag drop fileName $name'); // output ->  group36.png
              print(
                  'drag drop url $url'); //output -> blob:http://localhost:53542/2d030a6b-d38f-430b-b0d2-4f975922b7c4
              bool isImage = name.endsWith('png') ||
                  name.endsWith('jpg') ||
                  name.endsWith('jpeg');
              if (isImage) {
                try {
                  setState(() {
                    img = null;
                    dragBar = false;
                    color = false;
                    picLoaded = false;
                    //colors = false;
                    optimized = false;
                    colorized = false;
                    mainImage = Image.memory(byte!);
                    getData();
                  });
                } catch (e) {
                  Toast.show("Error occured $e",
                      duration: 2, gravity: Toast.bottom);
                }
              } else {
                print('isImage is false');
                Toast.show("Please Provide a Valid Image format ",
                    duration: 2, gravity: Toast.bottom);
              }

              print(byte!.sublist(0, 20));
            },
            onDropMultiple: (ev) async {
              print('Zone 1 drop multiple: $ev');
            },
          ),
        );

    return Scaffold(
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
                  if (credits == 0) {
                    Navigator.pushNamed(context, '/login?oId=');
                  } else if (credits > 0) {
                    await buyPhotoService.buyPhoto(token, oId!).then(
                      (value) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: DownloadBox(link: link, name: name));
                            });
                      },
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xff5118aa),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0.h, vertical: 0.h),
                            content: Checkout(
                              token: token,
                            ),
                          );
                        });
                  }
                  // Toast.show("Not enough credits",
                  //     duration: 2, gravity: Toast.bottom);
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
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.r))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 23.h)),
                    textStyle: MaterialStateProperty.all(TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w400)),
                    backgroundColor: MaterialStateProperty.all(
                        downHover ? Colors.black : const Color(0XFF5118AA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
              ),
              SizedBox(width: 15.w),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      '/settings?purchased=$purchased&credits=$credits');
                },
                child: SizedBox(
                    width: 53.w,
                    height: 53.h,
                    child:
                        CircleAvatar(radius: 50.r, child: Icon(Icons.person))),
              ),
              SizedBox(width: 28.w)
            ],
          )
        ],
      ),
      body: Row(
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
                    if (myUpload == false) {
                      setState(() {
                        myUpload = true;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.all(5),
                    width: 80,

                    decoration: BoxDecoration(
                      color:
                          uploadHover ? Colors.black : const Color(0xff350b77),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 19.h,
                            width: 23.w,
                            child: Image.asset("assets/icons/cloudwhite.png")),
                        SizedBox(height: 9.h),
                        Text(translation(context).myUploads,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 74.h),
                InkWell(
                  onTap: () {
                    if (myUpload == true) {
                      setState(() {
                        myUpload = false;
                      });
                    }
                  },
                  onHover: (value) {
                    setState(() {
                      uploadHover1 = value;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.all(5),
                    width: 80,
                    decoration: BoxDecoration(
                      color:
                          uploadHover1 ? Colors.black : const Color(0xff350b77),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 25.h,
                            width: 24.w,
                            child: Image.asset("assets/icons/beautywhite.png")),
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
                  onTap: () {
                    Navigator.pushNamed(context,
                        '/settings?purchased=$purchased&credits=$credits');
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => SettingsWeb(
                    //           purchased: purchased,
                    //           user: user,
                    //         )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.all(5),
                    width: 80,

                    decoration: BoxDecoration(
                      color:
                          uploadHover2 ? Colors.black : const Color(0xff350b77),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // margin: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 24.h,
                            width: 23.w,
                            child:
                                Image.asset("assets/icons/settingswhite.png")),
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
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => HomeWeb()));
                    await FacebookAuth.instance.logOut();
                    await googleSignIn.signOut();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.all(5),
                    width: 80,

                    decoration: BoxDecoration(
                      color:
                          uploadHover3 ? Colors.black : const Color(0xff350b77),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // margin: EdgeInsets.all(5),

                    child: Column(
                      children: [
                        SizedBox(
                            height: 29.h,
                            width: 28.w,
                            child: Image.asset("assets/icons/logoutwhite.png")),
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
                SizedBox(height: 74.h),
                Spacer(),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xff5118aa),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0.h, vertical: 0.h),
                            //content: Checkout(token: token),
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
          Container(
            width: 400.w,
            decoration: BoxDecoration(
                color: Color(0xfff9fafb),
                border: Border.all(color: Color(0xffe5e5e5), width: 1.33)),
            child: Stack(children: [
              Column(
                // mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  // colors
                  //     ? SizedBox(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(left: 35.w),
                  //               child: Text("Lorem Ipsum",
                  //                   style: TextStyle(
                  //                       fontSize: 22.sp,
                  //                       color: Color(0xff453c53),
                  //                       fontWeight: FontWeight.w600)),
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 35.w, vertical: 13.h),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       InkWell(
                  //                         onTap: () {
                  //                           setState(() {
                  //                             red = true;
                  //                             blue = false;
                  //                             green = false;
                  //                             dragBar = true;
                  //                           });
                  //                         },
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                               BorderRadius.circular(20.r),
                  //                           child: SizedBox(
                  //                               height: 90.h,
                  //                               width: 90.w,
                  //                               child: ColorFiltered(
                  //                                   child: mainImage,
                  //                                   colorFilter:
                  //                                       const ColorFilter.mode(
                  //                                           Color(0x99aa1844),
                  //                                           BlendMode.color))),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 10),
                  //                       Text("Name",
                  //                           style: TextStyle(
                  //                               fontSize: 16.5.sp,
                  //                               color: Color(0xff1b0f0f),
                  //                               fontWeight: FontWeight.w500))
                  //                     ],
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       InkWell(
                  //                         onTap: () {
                  //                           setState(() {
                  //                             red = false;
                  //                             blue = true;
                  //                             green = false;
                  //                             dragBar = true;
                  //                           });
                  //                         },
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                               BorderRadius.circular(20.r),
                  //                           child: SizedBox(
                  //                               height: 90.h,
                  //                               width: 90.w,
                  //                               child: ColorFiltered(
                  //                                   child: mainImage,
                  //                                   colorFilter:
                  //                                       const ColorFilter.mode(
                  //                                           Color(0x995118aa),
                  //                                           BlendMode.color))),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 10),
                  //                       Text("Name",
                  //                           style: TextStyle(
                  //                               fontSize: 16.5.sp,
                  //                               color: Color(0xff1b0f0f),
                  //                               fontWeight: FontWeight.w500))
                  //                     ],
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.end,
                  //                     children: [
                  //                       InkWell(
                  //                         onTap: () {
                  //                           setState(() {
                  //                             red = false;
                  //                             blue = false;
                  //                             green = true;
                  //                             dragBar = true;
                  //                           });
                  //                         },
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                               BorderRadius.circular(20.r),
                  //                           child: SizedBox(
                  //                               height: 90.h,
                  //                               width: 90.w,
                  //                               child: ColorFiltered(
                  //                                   child: mainImage,
                  //                                   colorFilter:
                  //                                       const ColorFilter.mode(
                  //                                           Color(0x996eba0d),
                  //                                           BlendMode.color))),
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 10),
                  //                       Text("Name",
                  //                           style: TextStyle(
                  //                               fontSize: 16.5.sp,
                  //                               color: Color(0xff1b0f0f),
                  //                               fontWeight: FontWeight.w500))
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     :
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w),
                        child: myUpload
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(translation(context).myUploads,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Color(0xff453c53),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 20.h),
                                  Expanded(
                                    child: picLoaded
                                        ? photos.isEmpty
                                            ? Center(
                                                child: Text(
                                                'No Image Uploaded yet!',
                                                style: TextStyle(
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))
                                            : GridView.builder(
                                                physics: ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: photos.length,
                                                scrollDirection: Axis.vertical,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        mainAxisSpacing: 9.w,
                                                        crossAxisSpacing: 10.w),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () async {
                                                      http.Response response =
                                                          await http.Client()
                                                              .get(Uri.https(
                                                                  'api.face26.com',
                                                                  'user/photo',
                                                                  {
                                                            'photo_id':
                                                                photos[index]
                                                                    .id!
                                                                    .oid,
                                                            'tag': '_optimized'
                                                          }));
                                                      if (response.statusCode ==
                                                          500) {
                                                        hd = false;
                                                        dragBar = false;
                                                        optimized = false;
                                                      } else if (response
                                                              .statusCode ==
                                                          200) {
                                                        hd = true;
                                                        dragBar = true;
                                                        optimized = true;
                                                        img = Image.network(
                                                          "https://api.face26.com/user/photo?photo_id=${photos[index].id!.oid}&tag=_optimized",
                                                          fit: BoxFit.contain,
                                                        );
                                                      }
                                                      color = false;
                                                      colorized = false;
                                                      upload = false;
                                                      mainImage = Image.network(
                                                          "https://api.face26.com/user/photo?photo_id=${photos[index].id!.oid}&tag=");
                                                      oId = photos[index]
                                                          .id!
                                                          .oid!;
                                                      setState(() {});
                                                      // img = null;
                                                    },
                                                    child: SizedBox(
                                                      height: 98.h,
                                                      width: 115.w,
                                                      child: Image.network(
                                                        "https://api.face26.com/user/photo?photo_id=${photos[index].id!.oid}&tag=",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                })
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${translation(context).getInspired} 🔥",
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Color(0xff453c53),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 20.h),
                                  Expanded(
                                    child: GridView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: images.length,
                                        scrollDirection: Axis.vertical,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 9.w,
                                                crossAxisSpacing: 10.w),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              await rootBundle
                                                  .load(images[index])
                                                  .then((value) {
                                                byte =
                                                    value.buffer.asUint8List();
                                              });
                                              setState(() {
                                                img = null;
                                                dragBar = false;
                                                color = false;
                                                //colors = false;
                                                optimized = false;
                                                colorized = false;
                                                mainImage = Image.memory(
                                                  byte!,
                                                  fit: BoxFit.contain,
                                                );
                                                getData();
                                              });
                                              // byte=Image.asset(images[index]);
                                            },
                                            child: SizedBox(
                                              height: 98.h,
                                              width: 115.w,
                                              child: Image.asset(images[index],
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              )),
                  ),
                  // colors
                  //     ? SizedBox()
                  //     :
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DottedBorder(
                        radius: Radius.circular(5.15.r),
                        color: Color(0xff384eb7).withOpacity(0.30),
                        strokeWidth: 1.29,
                        dashPattern: [7, 4],
                        child: Container(
                          decoration: BoxDecoration(
                              color: highlighted1
                                  ? Colors.blueGrey
                                  : Color(0xfff8f8ff)),
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
                                        // await ImagePickerWeb.getImageAsBytes()
                                        .then((value) async {
                                      setState(() {
                                        if (value != null) {
                                          dragBar = false;
                                          colorized = false;
                                          picLoaded = false;
                                          optimized = false;
                                          byte = value.files.first.bytes;
                                          mainImage = Image.memory(byte!);
                                          getData();
                                        } else {
                                          Toast.show("No Image selected",
                                              duration: 2,
                                              gravity: Toast.bottom);
                                        }
                                      });
                                    });
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(0xff483ea8),
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                // recognizer:
                                                //     TapGestureRecognizer()
                                                //       ..onTap = () async {
                                                //         await FilePicker
                                                //             .platform
                                                //             .pickFiles(
                                                //                 type: FileType
                                                //                     .image)
                                                //             // await ImagePickerWeb
                                                //             //         .getImageAsBytes()
                                                //             .then(
                                                //                 (value) async {
                                                //           //print(value);
                                                //           setState(() {
                                                //             if (value !=
                                                //                 null) {
                                                //               byte = value
                                                //                   .files
                                                //                   .first
                                                //                   .bytes;
                                                //               mainImage =
                                                //                   Image.memory(
                                                //                       byte!);
                                                //               getData();
                                                //             } else
                                                //               print(
                                                //                   "picker me null h");
                                                //           });
                                                //         });
                                                //       }
                                              )
                                            ]),
                                      ),
                                      SizedBox(height: 13.h),
                                      Text("Supported formates: JPEG, PNG",
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Color(0xff676767),
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  )
                ],
              ),
              // Positioned(
              //   bottom: 24.h,
              //   child: myUpload
              //       ? SizedBox()
              //       : Container(
              //           height: 60.h,
              //           width: 399.w,
              //           color: Colors.white.withOpacity(0.70),
              //           child: Row(
              //             children: [
              //               InkWell(
              //                 onTap: () async {
              //                   await ImagePickerWeb.getImageAsBytes()
              //                       .then((value) async {
              //                     if (value != null) {
              //                       byte = value;
              //                       //mainImage = Image.memory(byte!);
              //                     }
              //                   });
              //                   setState(() {});
              //                 },
              //                 child: SizedBox(
              //                   width: 199.w,
              //                   height: 49.h,
              //                   child: Image.asset(
              //                       "assets/icons/importphotos.png"),
              //                 ),
              //               ),
              //               SizedBox(width: 13.w),
              //               SizedBox(
              //                 width: 158.w,
              //                 height: 49.h,
              //                 child: Image.asset("assets/icons/fromurl.png"),
              //               )
              //             ],
              //           ),
              //         ),
              // )
            ]),
          ),
          SizedBox(
            width: 1387.w,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 253.w), //Left blank space
                    SizedBox(
                      //Centre space
                      width: 712.w,
                      child: Column(
                        children: [
                          SizedBox(height: 22.h),
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            width: 712.w,
                            height: 710.h,
                            child: InteractiveViewer(
                              transformationController: viewerController,
                              onInteractionUpdate: ((details) {
                                minValue = double.parse(viewerController.value
                                    .getMaxScaleOnAxis()
                                    .toStringAsFixed(2));
                                setState(() {});
                              }),
                              minScale: 1.0,
                              maxScale: 2.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Center(
                                    child: mainImage,
                                  ),
                                  dragBar
                                      ? VerticalSplitViewWeb(
                                          left: Container(),
                                          right: Center(
                                              child:
                                                  // (red || blue || green)
                                                  //     ? ColorFiltered(
                                                  //         child: img,
                                                  //         colorFilter: ColorFilter.mode(
                                                  //             Color(red
                                                  //                 ? 0x99aa1844
                                                  //                 : blue
                                                  //                     ? 0x995118aa
                                                  //                     : green
                                                  //                         ? 0x996eba0d
                                                  //                         : 0x00FFFFFF),
                                                  //             BlendMode.color))
                                                  //     :
                                                  img))
                                      : SizedBox(),
                                  upload
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  translation(context)
                                                      .optimizing,
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const SizedBox(height: 15),
                                              CirclePercentIndicator(
                                                  percent: percent,
                                                  percentage: percentage)
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 35.w,
                                child: Text(
                                    "${((minValue == 2.0) ? 100 : ((minValue - minValue.toInt()) * 100).toInt()) * 2}%",
                                    style: TextStyle(
                                        color: Color(0xff453c53),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700)),
                              ),
                              SizedBox(width: 08.w),
                              InkWell(
                                  onTap: () {
                                    if (minValue - 0.1 >= 1.0) {
                                      minValue = minValue - 0.1;
                                      viewerController.value =
                                          Matrix4.identity()
                                            ..translate(-260 * (minValue - 1),
                                                -211 * (minValue - 1))
                                            ..scale(minValue);
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(Icons.remove)),
                              Slider(
                                  min: 1.0,
                                  max: 2.0,
                                  //divisions: 10,
                                  activeColor: Colors.black,
                                  inactiveColor: Colors.grey,
                                  thumbColor: Colors.white,
                                  value: minValue,
                                  onChanged: (value) {
                                    setState(() {
                                      minValue = double.parse(
                                          value.toStringAsFixed(2));
                                      viewerController.value =
                                          Matrix4.identity()
                                            ..translate(-260 * (minValue - 1),
                                                -211 * (minValue - 1))
                                            ..scale(minValue);
                                    });
                                  }),
                              InkWell(
                                  onTap: () {
                                    if (minValue + 0.1 <= 2.0)
                                      minValue = minValue + 0.1;
                                    viewerController.value = Matrix4.identity()
                                      ..translate(-260 * (minValue - 1),
                                          -211 * (minValue - 1))
                                      ..scale(minValue);
                                    setState(() {});
                                  },
                                  child: Icon(Icons.add)),
                              SizedBox(width: 16.w),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    minValue = 1.0;
                                  });
                                  viewerController.value = Matrix4.identity();
                                },
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: Image.asset("assets/icons/zoom.png"),
                                ),
                              ),
                              SizedBox(width: 10.w)
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      //Right blank space
                      alignment: Alignment.topCenter,
                      width: 419.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 22.h, right: 97.w),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 4, sigmaY: 4),
                                          child: AlertDialog(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 75.w,
                                                      vertical: 55.h),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.r)),
                                              content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        translation(context)
                                                            .deleteConfirm,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 35.sp,
                                                            color: Color(
                                                                0xff453c53),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    SizedBox(height: 49.h),
                                                    SizedBox(
                                                      width: 368.w,
                                                      height: 59.h,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  translation(
                                                                          context)
                                                                      .cancel,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff5118aa))),
                                                              style:
                                                                  ButtonStyle(
                                                                      elevation:
                                                                          MaterialStateProperty.all(
                                                                              0),
                                                                      side: MaterialStateProperty
                                                                          .all(
                                                                        const BorderSide(
                                                                          color:
                                                                              Color(0xff5118aa),
                                                                          width:
                                                                              1.3,
                                                                        ),
                                                                      ),
                                                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(10
                                                                              .r))),
                                                                      padding:
                                                                          MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 48.w, vertical: 22.h)),
                                                                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w700)),
                                                                      backgroundColor: MaterialStateProperty.all(Colors.white))),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                deleteImage(
                                                                    token,
                                                                    oId!);
                                                                setState(() {
                                                                  Navigator.pop(
                                                                      context);
                                                                  mainImage =
                                                                      null;
                                                                  img = null;
                                                                  hd = false;
                                                                  dragBar =
                                                                      false;
                                                                  color = false;
                                                                });
                                                              },
                                                              child: Text(
                                                                  translation(
                                                                          context)
                                                                      .yes,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xffffffff))),
                                                              style: ButtonStyle(
                                                                  elevation:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                              0),
                                                                  shape: MaterialStateProperty.all(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.r))),
                                                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 67.w, vertical: 22.h)),
                                                                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 21.sp, fontWeight: FontWeight.w700)),
                                                                  backgroundColor: MaterialStateProperty.all(Color(0xff5118aa))))
                                                        ],
                                                      ),
                                                    )
                                                  ])));
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: Color(0xffe5e5e5), width: 1)),
                                width: 55.w,
                                height: 55.h,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.5.w, vertical: 14.5.h),
                                  child:
                                      Image.asset("assets/icons/dustbin.png"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(color: Color(0xffe5e5e5), thickness: 1.33),
                SizedBox(height: 22.h),
                Row(
                  children: [
                    SizedBox(width: 253.w),
                    SizedBox(
                      width: 712.w,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                hd = !hd;
                                color = false;
                                //colors = false;
                                // red = false;
                                // green = false;
                                dragBar = false;
                                // blue = false;
                                if (hd) {
                                  if (optimized) {
                                    photoInfo(token, oId!);
                                    dragBar = true;
                                  } else {
                                    optimizeImage(token, oId!);
                                    upload = true;
                                  }
                                } else if (!hd) {
                                  upload = false;
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 35.w,
                                    height: 35.h,
                                    child: Image.asset(
                                        "assets/icons/HDbutton.png",
                                        color: hd
                                            ? const Color(0xff5118aa)
                                            : null)),
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
                          ),
                          SizedBox(width: 79.w),
                          InkWell(
                            onTap: () {
                              setState(() {
                                color = !color;
                                // red = false;
                                // blue = false;
                                // green = false;
                                //colors = false;
                                dragBar = false;
                                hd = false;
                                // scratch = false;
                                if (color) {
                                  if (colorized) {
                                    photoInfo(token, oId!);
                                    dragBar = true;
                                  } else {
                                    colorizeImage(token, oId!);
                                    upload = true;
                                  }
                                } else if (!color) {
                                  upload = false;
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 35.w,
                                    height: 35.h,
                                    child: Image.asset(
                                      "assets/icons/addcolorbutton.png",
                                      color: color
                                          ? const Color(0xff5118aa)
                                          : null,
                                    )),
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
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                    SizedBox(width: 419.w)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
