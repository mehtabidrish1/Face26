import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:face26_mobile/backend/apis/getTokenApi.dart';
import 'package:face26_mobile/backend/apis/syncApi.dart';
import 'package:face26_mobile/backend/apis/trackerApi.dart';
import 'package:face26_mobile/backend/apis/uploadApi.dart';
import 'package:face26_mobile/backend/models/syncModel.dart';
import 'package:face26_mobile/backend/models/uploadModel.dart';
import 'package:face26_mobile/utils/authentication/googleAuth.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:face26_mobile/widgets/pro_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  GetTokenService getTokenService = GetTokenService();
  TrackerService trackerService = TrackerService();
  UploadService uploadService = UploadService();
  late UploadModel uploadModel;
  SyncService syncService = SyncService();
  late SyncModel syncModel;

  bool access = false;
  String token = '';
  bool apiData = false;
  double? cost = 2.0;
  String title = "3x Photos Package";
  //late File image;
  //bool importer = false;
  List<Photo> photos = [];
  int credits = 0;
  int purchased = 0;
  User? user;
  Uint8List? byte;
  String email = '';
  late String oId;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth') ?? '';
    print("pref ka token $token");
    if (token == '') {
      await getTokenService.getToken(context).then((value) async {
        token = value.accessToken;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth', token);
        syncData();
      });
    } else
      syncData();
  }

  syncData() async {
    photos.clear();
    purchased = 0;
    await syncService.sync(token, context).then((value) async {
      syncModel = value;
      if (syncModel.user != null) {
        user = syncModel.user;
        credits = syncModel.user!.credits!;
      }
      if (syncModel.photos!.isNotEmpty) {
        photos = syncModel.photos!;
        print("List is not empty");
        if (photos.isNotEmpty) {
          access = true;
          photos.forEach((element) {
            if (element.purchased! == true) {
              purchased++;
            }
          });
        }
      } else {
        print("List is empty");
      }
      apiData = true;
      setState(() {});
    });
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
      uploadModel = value;
      oId = uploadModel.photoId.oid;
    });
    syncData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  List<String> images = [
    "assets/grid/picture1.png",
    "assets/grid/picture2.png",
    "assets/grid/picture3.png",
    "assets/grid/picture4.png",
    "assets/grid/picture5.png",
    "assets/grid/picture6.png",
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
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 56.h,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, '/settings?purchased=$purchased&credits=$credits');
              },
              child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  height: 22.h,
                  width: 22.w,
                  child: Image.asset("assets/icons/settings.png")),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Center(
                  child: SizedBox(
                      height: 56.h,
                      width: 56.w,
                      child: Image.asset("assets/icons/icon.png"))),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.w, left: 15.w),
                child: InkWell(
                  onTap: () {
                    showDialogs(context);
                  },
                  child: SizedBox(
                      height: 44.h,
                      width: 81.w,
                      child: Image.asset("assets/icons/probutton.png")),
                ),
              )
            ]),
        body: Stack(alignment: Alignment.topCenter, children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 26.h),
                        Text(translation(context).myUploads,
                            style: TextStyle(
                                fontSize: 24.sp,
                                color: Color(0xff453c53),
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 10.h),
                        apiData
                            ? access
                                ? SizedBox(
                                    height: 231.h,
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: photos.length,
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 9.w,
                                                crossAxisSpacing: 10.w),
                                        itemBuilder: (context, index) {
                                          // bool decor = false;
                                          return InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/editor?oId=${photos[index].id!.oid!}');
                                            },
                                            child: SizedBox(
                                              height: 115.h,
                                              width: 115.w,
                                              child: Image.network(
                                                "https://api.face26.com/user/photo?photo_id=${photos[index].id!.oid}&tag=",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: DottedBorder(
                                        radius: Radius.circular(5.15.r),
                                        color:
                                            Color(0xff384eb7).withOpacity(0.30),
                                        strokeWidth: 1.29,
                                        dashPattern: [7, 4],
                                        child: InkWell(
                                          onTap: () async {
                                            await FilePicker.platform
                                                .pickFiles(type: FileType.image)
                                                .then((value) async {
                                              if (value != null) {
                                                byte = value.files.first.bytes;
                                                getData();
                                                apiData = false;
                                                setState(() {});
                                              } else {
                                                Toast.show("No Image selected",
                                                    duration: 2,
                                                    gravity: Toast.bottom);
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xfff8f8ff)),
                                            //width: 572.w,
                                            height: 231.h,
                                            child: Center(
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                            text:
                                                                'No image uploaded yet, ',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff0f0f0f),
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: 'Upload',
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    color: Color(
                                                                        0xff483ea8),
                                                                    fontSize:
                                                                        20.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              )
                                                            ]),
                                                      ),
                                                      SizedBox(height: 13.h),
                                                      Text(
                                                          "Supported formates: JPEG, PNG",
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              color: Color(
                                                                  0xff676767),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  )
                            : SizedBox(
                                height: 231.h,
                                child:
                                    Center(child: CircularProgressIndicator()))
                      ],
                    ),
                  ),
                  SizedBox(height: access ? 23.h : 47.h),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("${translation(context).getInspired} 🔥",
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff453c53),
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 353.h,
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: images.length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await rootBundle
                                  .load(images[index])
                                  .then((value) {
                                byte = value.buffer.asUint8List();
                              });
                              getData();
                              apiData = false;
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 9.h, right: 9.w),
                              child: SizedBox(
                                height: 111.h,
                                width: 111.w,
                                child: Image.asset(images[index],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 45.h)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30.h,
            // top: 762,
            child: ElevatedButton(
                onPressed: () async {
                  await FilePicker.platform
                      .pickFiles(type: FileType.image)
                      .then((value) async {
                    if (value != null) {
                      byte = value.files.first.bytes;
                      getData();
                      apiData = false;
                      setState(() {});
                    } else {
                      Toast.show("No Image selected",
                          duration: 2, gravity: Toast.bottom);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 15.w),
                    Text(translation(context).import),
                  ],
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 88.w, vertical: 22.h)),
                    textStyle: MaterialStateProperty.all(TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF5118AA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white))),
          ),
        ]));
  }
}
