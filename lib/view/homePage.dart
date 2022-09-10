import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:face26_mobile/backend/apis/getTokenApi.dart';
import 'package:face26_mobile/backend/apis/syncApi.dart';
import 'package:face26_mobile/backend/apis/trackerApi.dart';
import 'package:face26_mobile/backend/apis/uploadApi.dart';
import 'package:face26_mobile/backend/models/syncModel.dart';
import 'package:face26_mobile/backend/models/uploadModel.dart';
import 'package:face26_mobile/view/Desktop/settingsWeb.dart';
import 'package:face26_mobile/view/Mobile%20Web/imageEditorWeb.dart';
import 'package:face26_mobile/widgets/pro_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GetTokenService getTokenService = GetTokenService();
  TrackerService trackerService = TrackerService();
  UploadService uploadService = UploadService();
  late UploadModel uploadModel;
  SyncService syncService = SyncService();
  late SyncModel syncModel;

  late bool access;
  String token = '';
  String selected = "Recents";
  bool apiData = false;
  bool myUploads = false;
  Uint8List? byte;
  List<Photo> photos = [];
  int credits = 0;
  int purchased = 0;
  User? user;
  bool image = false;
  String email = '';
  late String oId;
  bool waiting = false;
  //int decor = -1;
  //late AssetEntity navAsset;
  List<AssetEntity> assets = [];
  List<AssetPathEntity> folderList = [];
  double? cost = 2.0;
  String title = "3x Photos Package";

  ///late File image;
  bool importer = false;

  checkAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('access') ?? false;
    access = boolValue;
    if (boolValue = true) {
      _fetchFolders();
    }
    apiData = true;
    print("Access $boolValue");
    setState(() {});
    // return boolValue;
  }

  _fetchFolders() async {
    final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        // onlyAll: true,
        hasAll: true);
    print("abcd${albums[1]}");
    // final recentAlbum = albums.first;
    folderList = albums;
    selected = folderList.first.name;
    _fetchAssets(albums.first);
  }

  _fetchAssets(AssetPathEntity folder) async {
    final folderAssets = await folder.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    assets = folderAssets;
    setState(() {});
  }

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
          image = true;
          photos.forEach((element) {
            if (element.purchased! == true) {
              purchased++;
            }
          });
        }
      } else {
        print("List is empty");
      }
      waiting = false;
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
    checkAccess();
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
    return apiData
        ? Scaffold(
            appBar: (access)
                ? AppBar(
                    toolbarHeight: 56.h,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: SettingsWeb(
                                  purchased: purchased,
                                  credits: credits,
                                )));
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
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
                          padding: EdgeInsets.only(right: 20.w),
                          child: InkWell(
                            onTap: () {
                              //_showDialog();
                              showDialogs(context);
                            },
                            child: SizedBox(
                                height: 44.h,
                                width: 81.w,
                                child:
                                    Image.asset("assets/icons/probutton.png")),
                          ),
                        )
                      ])
                : AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: SettingsWeb(purchased: 0)));
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                          height: 22.h,
                          width: 22.w,
                          child: Image.asset("assets/icons/settings.png")),
                    ),
                    actions: [
                        Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: InkWell(
                            onTap: () {
                              //_showDialog();
                              showDialogs(context);
                            },
                            child: SizedBox(
                                height: 44,
                                width: 81,
                                child:
                                    Image.asset("assets/icons/probutton.png")),
                          ),
                        )
                      ]),
            body: Stack(alignment: Alignment.topCenter, children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    children: [
                      access
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 34.h),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: InkWell(
                                            onTap: () {
                                              myUploads = true;
                                              selected = '';
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 36.h,
                                              decoration: BoxDecoration(
                                                color: myUploads
                                                    ? const Color(0xff5118aa)
                                                    : const Color(0xffe9e9e9),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        6.93.r),
                                              ),
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 8.h),
                                              child: Text('My Uploads',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: myUploads
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff77737c))),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 32,
                                          child: VerticalDivider(
                                              color: Colors.grey,
                                              thickness: 2,
                                              indent: 1,
                                              endIndent: 1),
                                        ),
                                        SizedBox(width: 08),
                                        SizedBox(
                                            height: 36.h,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: folderList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.w),
                                                    child: InkWell(
                                                      onTap: () {
                                                        myUploads = false;
                                                        selected =
                                                            folderList[index]
                                                                .name;
                                                        _fetchAssets(
                                                            folderList[index]);
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 36.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: folderList[
                                                                          index]
                                                                      .name !=
                                                                  selected
                                                              ? const Color(
                                                                  0xffe9e9e9)
                                                              : const Color(
                                                                  0xff5118AA),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.93.r),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.w,
                                                                vertical: 8.h),
                                                        child: Text(
                                                            folderList[index]
                                                                .name,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: folderList[index]
                                                                            .name !=
                                                                        selected
                                                                    ? const Color(
                                                                        0xff77737c)
                                                                    : Colors
                                                                        .white)),
                                                      ),
                                                    ),
                                                  );
                                                })),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 26.h),
                                  Text(myUploads ? "My Uploads" : "My Gallery",
                                      style: TextStyle(
                                          fontSize: 26.sp,
                                          color: Color(0xff453c53),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 10.h),
                                  SizedBox(
                                    height: 231.h,
                                    child: myUploads
                                        ? !waiting
                                            ? !image
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 16),
                                                    child: DottedBorder(
                                                        radius: Radius.circular(
                                                            5.15.r),
                                                        color: Color(0xff384eb7)
                                                            .withOpacity(0.30),
                                                        strokeWidth: 1.29,
                                                        dashPattern: [7, 4],
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                                    type: FileType
                                                                        .image)
                                                                .then(
                                                                    (value) async {
                                                              if (value !=
                                                                  null) {
                                                                var abc = File(
                                                                    value
                                                                        .files
                                                                        .first
                                                                        .path!);
                                                                abc
                                                                    .readAsBytes()
                                                                    .then((value) =>
                                                                        byte =
                                                                            value);
                                                                print(byte);

                                                                // byte = value
                                                                //     .files
                                                                //     .first
                                                                //     .bytes;
                                                                getData();
                                                                waiting = true;
                                                                setState(() {});
                                                              } else {
                                                                Toast.show(
                                                                    "No Image selected",
                                                                    duration: 2,
                                                                    gravity: Toast
                                                                        .bottom);
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color(
                                                                        0xfff8f8ff)),
                                                            //width: 572.w,
                                                            height: 231.h,
                                                            child: Center(
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              38.h),
                                                                      SizedBox(
                                                                          width: 88
                                                                              .w,
                                                                          height: 76
                                                                              .h,
                                                                          child:
                                                                              Image.asset("assets/icons/uploadcloud.png")),
                                                                      SizedBox(
                                                                          height:
                                                                              32.h),
                                                                      RichText(
                                                                        text: TextSpan(
                                                                            text:
                                                                                'No image uploaded yet, ',
                                                                            style: TextStyle(
                                                                                color: Color(0xff0f0f0f),
                                                                                fontSize: 20.sp,
                                                                                fontWeight: FontWeight.w700),
                                                                            children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: 'Upload',
                                                                                style: TextStyle(decoration: TextDecoration.underline, color: Color(0xff483ea8), fontSize: 20.sp, fontWeight: FontWeight.w700),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              13.h),
                                                                      Text(
                                                                          "Supported formates: JPEG, PNG",
                                                                          style: TextStyle(
                                                                              fontSize: 15.sp,
                                                                              color: Color(0xff676767),
                                                                              fontWeight: FontWeight.w400))
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  )
                                                : GridView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: photos.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing:
                                                                9.w,
                                                            crossAxisSpacing:
                                                                10.w),
                                                    itemBuilder:
                                                        (context, index) {
                                                      // bool decor = false;
                                                      return InkWell(
                                                        onTap: () {
                                                          oId = photos[index]
                                                              .id!
                                                              .oid!;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ImageEditorWeb(
                                                                          oId:
                                                                              oId)));
                                                          // Navigator.pushNamed(
                                                          //     context,
                                                          //     '/editor?oId=${photos[index].id!.oid!}');
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
                                                    })
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                        : GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: assets.length,
                                            scrollDirection: Axis.horizontal,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2),
                                            itemBuilder: (context, index) {
                                              // bool decor = false;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 9.h, right: 9.w),
                                                child: InkWell(
                                                  onTap: (() async {
                                                    byte = await assets[index]
                                                        .thumbnailData;
                                                    getData();
                                                    myUploads = true;
                                                    waiting = true;
                                                    setState(() {});
                                                    // File? file =
                                                    //     await assets[index]
                                                    //         .file;
                                                    // setState(() {
                                                    //   Navigator.push(
                                                    //       context,
                                                    //       PageTransition(
                                                    //           type: PageTransitionType
                                                    //               .rightToLeftWithFade,
                                                    //           child:
                                                    //               ImageEditor(
                                                    //             imageFile:
                                                    //                 file!,
                                                    //             token: token,
                                                    //           )));
                                                    // });
                                                  }),
                                                  child: SizedBox(
                                                    height: 111.h,
                                                    width: 111.w,
                                                    child: FutureBuilder<
                                                        Uint8List?>(
                                                      future: assets[index]
                                                          .thumbnailData,
                                                      builder: (_, snapshot) {
                                                        final bytes =
                                                            snapshot.data;
                                                        // If we have no data, display a spinner
                                                        if (bytes == null)
                                                          return CircularProgressIndicator();
                                                        // If there's data, display it as an image
                                                        return Image.memory(
                                                            bytes,
                                                            fit: BoxFit.cover);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("My Gallery",
                                        style: TextStyle(
                                            fontSize: 26.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 60.h),
                                    Text("to get started, Face26 needs",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    Text("access to Photos",
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    SizedBox(height: 15.h),
                                    ElevatedButton(
                                        onPressed: () async {
                                          final permitted = await PhotoManager
                                              .requestPermissionExtend();
                                          if (permitted ==
                                              PermissionState.denied) {
                                            importer = true;
                                            setState(() {});
                                            print("denied");
                                            await PhotoManager
                                                .requestPermissionExtend();
                                          } else if (permitted ==
                                              PermissionState.restricted) {
                                            importer = true;
                                            setState(() {});
                                            print("restricted");
                                            openAppSettings();
                                          } else if (permitted ==
                                              PermissionState.limited) {
                                            importer = true;
                                            setState(() {});
                                          } else if (permitted.isAuth) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool('access', true);
                                            print("Authorized");

                                            _fetchFolders();
                                            access = true;
                                            setState(() {});
                                          }
                                        },
                                        child: const Text("Give Access"),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        30.r))),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: 81.w,
                                                    vertical: 14.h)),
                                            textStyle: MaterialStateProperty.all(TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700)),
                                            backgroundColor: MaterialStateProperty.all(
                                                const Color(0XFF5118AA)),
                                            foregroundColor:
                                                MaterialStateProperty.all(Colors.white)))
                                  ],
                                ),
                              ),
                            ),
                      SizedBox(height: access ? 23.h : 47.h),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Get Inspired 🔥",
                            style: TextStyle(
                                fontSize: 26.sp,
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
                                  waiting = true;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 9.h, right: 9.w),
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
              // access
              //     ? SizedBox()
              //     :
              Positioned(
                bottom: 30.h,
                // top: 762,
                child: ElevatedButton(
                    onPressed: () async {
                      await FilePicker.platform
                          .pickFiles(type: FileType.image)
                          .then((value) async {
                        if (value != null) {
                          var abc = File(value.files.first.path!);
                          abc.readAsBytes().then((value) => byte = value);
                          print(byte);
                          getData();
                          waiting = true;
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
                        Text("Import Photos"),
                      ],
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r))),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 88.w, vertical: 14.h)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0XFF5118AA)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white))),
              ),
            ]))
        : Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
