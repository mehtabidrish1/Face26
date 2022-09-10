// import 'dart:io';
// import 'package:face26_mobile/backend/apis/colorizeApi.dart';
// import 'package:face26_mobile/widgets/percentIndicatorWidget.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:face26_mobile/backend/apis/optimizeApi.dart';
// import 'package:face26_mobile/backend/apis/photoInfoApi.dart';
// import 'package:face26_mobile/backend/apis/syncApi.dart';
// import 'package:face26_mobile/backend/apis/trackerApi.dart';
// import 'package:face26_mobile/backend/apis/uploadApi.dart';
// import 'package:face26_mobile/backend/models/photoInfoModel.dart';
// import 'package:face26_mobile/backend/models/syncModel.dart';
// import 'package:face26_mobile/backend/models/uploadModel.dart';
// import 'package:face26_mobile/widgets/sliderScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart';
// import 'package:toast/toast.dart';

// class ImageEditor extends StatefulWidget {
//   File imageFile;
//   String token;
//   ImageEditor({Key? key, required this.imageFile, required this.token})
//       : super(key: key);

//   @override
//   State<ImageEditor> createState() => _ImageEditorState();
// }

// class _ImageEditorState extends State<ImageEditor> {
//   TrackerService trackerService = TrackerService();
//   UploadService uploadService = UploadService();
//   late UploadModel uploadModel;
//   OptimizeService optimizeService = OptimizeService();
//   SyncService syncService = SyncService();
//   late SyncModel syncModel;
//   PhotoInfoService photoInfoService = PhotoInfoService();
//   late PhotoInfoModel photoInfoModel;
//   ColorizeService colorizeService = ColorizeService();

//   bool color = false;
//   bool colors = false;
//   bool upload = false;
//   bool hd = false;
//   bool scratch = false;
//   Image? mainImage;
//   bool tracker = false;
//   bool optimized = false;
//   bool dragBar = false;
//   bool saver = false;
//   bool red = false;
//   bool blue = false;
//   bool green = false;
//   String token = '';
//   String name = '';
//   String email = '';
//   Image? img;
//   List<Photo> photos = [];
//   String link = '';
//   double percent = 0.0;
//   int percentage = 0;
//   String oId = '';
//   int purchased = 0;
//   User? user;
//   int? credits = null;
//   bool colorized = false;
//   final viewerController = TransformationController();

//   getData(String token) async {
//     await trackerService
//         .tracker(
//             token.substring(token.length - 8), email, "photo_upload", context)
//         .then((value) async {
//       String imgPath = widget.imageFile.path;
//       print("token aa gya ${value}");

//       uploadImage(imgPath);
//     });
//   }

//   uploadImage(String path) async {
//     await uploadService.uploadImage(token, path).then((value) async {
//       uploadModel = value;
//       oId = uploadModel.photoId.oid;
//     });
//     syncData();
//   }

//   syncData() async {
//     photos.clear();
//     purchased = 0;
//     await syncService.sync(token, context).then((value) async {
//       setState(() {
//         percent = 0.76;
//         percentage = 76;
//       });
//       syncModel = value;
//       print("model ki value ${syncModel.photos!.first.id!.oid}");
//       if (syncModel.user != null) {
//         user = syncModel.user;
//         credits = syncModel.user!.credits;
//       }
//       syncModel.photos!.forEach((element) {
//         photos.add(element);
//       });
//     });
//   }

//   optimizeImage(String token, String oid) async {
//     setState(() {
//       percent = 0.24;
//       percentage = 24;
//     });
//     await optimizeService.optimize(token, oid).then((Response value) async {
//       setState(() {
//         percent = 0.49;
//         percentage = 49;
//         optimized = true;
//         syncData();
//         photoInfo(token, oid);
//       });
//       print("optimize ho gya ${value.body}");
//     });
//   }

//   colorizeImage(String token, String oid) async {
//     setState(() {
//       percent = 0.24;
//       percentage = 24;
//     });
//     await colorizeService.colorize(token, oid).then((Response value) async {
//       setState(() {
//         percent = 0.49;
//         percentage = 49;
//         colorized = true;
//         syncData();
//         photoInfo(token, oid);
//       });
//       print("colorize ho gya ${value.body}");
//     });
//   }

//   photoInfo(String token, String oid) async {
//     String tag = hd
//         ? '_optimized'
//         : color
//             ? '_optimized_colorized'
//             : '';
//     await photoInfoService.photoInfo(token, oid).then((value) {
//       setState(() {
//         //img = mainImage;
//         percent = 0.94;
//         percentage = 94;
//       });
//       photoInfoModel = value;
//       print(photoInfoModel.id!.oid);
//       link =
//           'https://api.face26.com/user/photo?photo_id=${photoInfoModel.id!.oid}&tag=$tag';
//       name =
//           photoInfoModel.id!.oid!.substring(photoInfoModel.id!.oid!.length - 8);
//       img = Image.network(link);
//       setState(() {
//         percent = 0;
//         percentage = 0;

//         upload = false;
//         // if (color) {
//         //   //colors = true;
//         // } else {
//         dragBar = true;
//         // }
//       });
//     });
//   }

//   int _total = 0, _received = 0;
//   late http.StreamedResponse _response;
//   File? _image;
//   final List<int> _bytes = [];

//   Future<void> _downloadImage(String imgLink, String imgName) async {
//     _response =
//         await http.Client().send(http.Request('GET', Uri.parse(imgLink)));
//     _total = _response.contentLength ?? 0;

//     _response.stream.listen((value) {
//       setState(() {
//         _bytes.addAll(value);
//         _received += value.length;
//         percent = double.parse((_received / _total).toStringAsFixed(2));
//         percentage = int.parse(((_received / _total) * 100).toStringAsFixed(0));
//       });
//     }).onDone(() async {
//       final file = File(
//           '${(await getApplicationDocumentsDirectory()).path}/$imgName.png');
//       print(file);
//       await file.writeAsBytes(_bytes);
//       saver = false;
//       percent = 0;
//       percentage = 0;
//       Toast.show("Downloaded", duration: 2, gravity: Toast.bottom);
//       setState(() {
//         _image = file;
//       });
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     token = widget.token;
//     mainImage = Image.file(widget.imageFile, fit: BoxFit.contain);
//     getData(token);
//     syncData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ToastContext().init(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 10.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SizedBox(width: 18.w),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Row(
//                     children: [
//                       Icon(Icons.arrow_back_ios_new_outlined,
//                           color: Color(0xff453c53)),
//                       SizedBox(width: 4.w),
//                       Text("Back",
//                           style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Color(0xff453c53),
//                               fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 88.w),
//                 Text("Editor",
//                     style: TextStyle(
//                         fontSize: 18.sp,
//                         color: Color(0xff453c53),
//                         fontWeight: FontWeight.w600)),
//                 SizedBox(width: 37.w),
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(30.r),
//                                 topRight: Radius.circular(30.r))),
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Container(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(height: 30.h),
//                                 Text("Social Media Sharing",
//                                     style: TextStyle(
//                                         fontSize: 18.sp,
//                                         color: Color(0xff453c53),
//                                         fontWeight: FontWeight.w600)),
//                                 SizedBox(height: 28.h),
//                                 SizedBox(
//                                   width: 236.w,
//                                   height: 44.h,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Image.asset("assets/icons/linkedin.png"),
//                                       Image.asset("assets/icons/twitter.png"),
//                                       Image.asset("assets/icons/facebook.png"),
//                                       Image.asset("assets/icons/instagram.png"),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 22.h),
//                                 SizedBox(
//                                   width: 358.w,
//                                   height: 54.h,
//                                   child: Stack(
//                                       alignment: Alignment.centerRight,
//                                       children: [
//                                         Container(
//                                           height: 52.h,
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 20.w, vertical: 15.h),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(100.r),
//                                               border: Border.all(
//                                                   color: Color(0xffcecece),
//                                                   width: 1.0,
//                                                   style: BorderStyle.solid)),
//                                           child: Text(link,
//                                               maxLines: 1,
//                                               style: TextStyle(
//                                                   fontSize: 18.sp,
//                                                   color: Color(0xff453c53),
//                                                   fontWeight: FontWeight.w400)),
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             Clipboard.setData(
//                                                 ClipboardData(text: link));
//                                             Toast.show("Copied",
//                                                 duration: 2,
//                                                 gravity: Toast.bottom);
//                                             //     .then((value) {
//                                             //   Fluttertoast.showToast(
//                                             //       msg: 'Copied to clipboard',
//                                             //       gravity: ToastGravity.CENTER);
//                                             // });
//                                           },
//                                           child: Image.asset(
//                                               "assets/icons/copyIcon.png"),
//                                         )
//                                       ]),
//                                 )
//                               ],
//                             ),
//                             height: 236.h,
//                           );
//                         });
//                   },
//                   child: SizedBox(
//                       height: 26.h,
//                       width: 26.w,
//                       child: Image.asset("assets/icons/upload.png")),
//                 ),
//                 SizedBox(width: 20.w),
//                 InkWell(
//                   onTap: () async {
//                     percent = 0;
//                     percentage = 0;
//                     if (link == '') {
//                     } else {
//                       await _downloadImage(link, name);
//                     }
//                     saver = !saver;
//                     setState(() {});
//                   },
//                   child: SizedBox(
//                       height: 44.h,
//                       width: 71.w,
//                       child: Image.asset("assets/icons/savebutton.png")),
//                 ),
//                 SizedBox(width: 16.w),
//               ],
//             ),
//             SizedBox(height: 30.h),
//             Expanded(
//                 child: Container(
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               decoration: BoxDecoration(color: Colors.transparent),
//               child: InteractiveViewer(
//                 transformationController: viewerController,
//                 minScale: 1.0,
//                 maxScale: 2.0,
//                 child: Stack(alignment: Alignment.center, children: [
//                   Center(
//                     child: mainImage,
//                   ),
//                   // colors
//                   //     ? Align(
//                   //         alignment: Alignment.bottomCenter,
//                   //         child: SizedBox(
//                   //           child: Padding(
//                   //             padding: EdgeInsets.symmetric(
//                   //                 horizontal: 35.w, vertical: 12.h),
//                   //             child: Row(
//                   //               mainAxisAlignment:
//                   //                   MainAxisAlignment.spaceBetween,
//                   //               children: [
//                   //                 Column(
//                   //                   mainAxisAlignment: MainAxisAlignment.end,
//                   //                   children: [
//                   //                     InkWell(
//                   //                       onTap: () {
//                   //                         setState(() {
//                   //                           red = true;
//                   //                           blue = false;
//                   //                           green = false;
//                   //                           dragBar = true;
//                   //                         });
//                   //                       },
//                   //                       child: ClipRRect(
//                   //                         borderRadius:
//                   //                             BorderRadius.circular(20.r),
//                   //                         child: SizedBox(
//                   //                             height: 90.h,
//                   //                             width: 90.w,
//                   //                             child: ColorFiltered(
//                   //                                 child: Image.file(
//                   //                                   widget.imageFile,
//                   //                                   fit: BoxFit.cover,
//                   //                                 ),
//                   //                                 colorFilter:
//                   //                                     const ColorFilter.mode(
//                   //                                         Color(0x99aa1844),
//                   //                                         BlendMode.color))),
//                   //                       ),
//                   //                     ),
//                   //                     const SizedBox(height: 10),
//                   //                     Text("Name",
//                   //                         style: TextStyle(
//                   //                             fontSize: 14.sp,
//                   //                             color: Color(0xffffffff),
//                   //                             fontWeight: FontWeight.w500))
//                   //                   ],
//                   //                 ),
//                   //                 Column(
//                   //                   mainAxisAlignment: MainAxisAlignment.end,
//                   //                   children: [
//                   //                     InkWell(
//                   //                       onTap: () {
//                   //                         setState(() {
//                   //                           red = false;
//                   //                           blue = true;
//                   //                           green = false;
//                   //                           dragBar = true;
//                   //                         });
//                   //                       },
//                   //                       child: ClipRRect(
//                   //                         borderRadius:
//                   //                             BorderRadius.circular(20.r),
//                   //                         child: SizedBox(
//                   //                             height: 90.h,
//                   //                             width: 90.w,
//                   //                             child: ColorFiltered(
//                   //                                 child: Image.file(
//                   //                                     widget.imageFile,
//                   //                                     fit: BoxFit.cover),
//                   //                                 colorFilter:
//                   //                                     const ColorFilter.mode(
//                   //                                         Color(0x995118aa),
//                   //                                         BlendMode.color))),
//                   //                       ),
//                   //                     ),
//                   //                     const SizedBox(height: 10),
//                   //                     Text("Name",
//                   //                         style: TextStyle(
//                   //                             fontSize: 14.sp,
//                   //                             color: Color(0xffffffff),
//                   //                             fontWeight: FontWeight.w500))
//                   //                   ],
//                   //                 ),
//                   //                 Column(
//                   //                   mainAxisAlignment: MainAxisAlignment.end,
//                   //                   children: [
//                   //                     InkWell(
//                   //                       onTap: () {
//                   //                         setState(() {
//                   //                           red = false;
//                   //                           blue = false;
//                   //                           green = true;
//                   //                           dragBar = true;
//                   //                         });
//                   //                       },
//                   //                       child: ClipRRect(
//                   //                         borderRadius:
//                   //                             BorderRadius.circular(20.r),
//                   //                         child: SizedBox(
//                   //                             height: 90.h,
//                   //                             width: 90.w,
//                   //                             child: ColorFiltered(
//                   //                                 child: Image.file(
//                   //                                     widget.imageFile,
//                   //                                     fit: BoxFit.cover),
//                   //                                 colorFilter:
//                   //                                     const ColorFilter.mode(
//                   //                                         Color(0x996eba0d),
//                   //                                         BlendMode.color))),
//                   //                       ),
//                   //                     ),
//                   //                     const SizedBox(height: 10),
//                   //                     Text("Name",
//                   //                         style: TextStyle(
//                   //                             fontSize: 14.sp,
//                   //                             color: Color(0xffffffff),
//                   //                             fontWeight: FontWeight.w500))
//                   //                   ],
//                   //                 )
//                   //               ],
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       )
//                   //     : SizedBox(),
//                   // dragBar
//                   //     ? Center(
//                   //         child: Image.file(
//                   //           widget.imageFile,
//                   //           fit: BoxFit.contain,
//                   //         ),
//                   //       )
//                   //     : SizedBox(),
//                   dragBar
//                       ? VerticalSplitView(
//                           left: Container(),
//                           right: Center(
//                               child:
//                                   // (red || blue || green)
//                                   //     ? ColorFiltered(
//                                   //         child: img,
//                                   //         colorFilter: ColorFilter.mode(
//                                   //             Color(red
//                                   //                 ? 0x99aa1844
//                                   //                 : blue
//                                   //                     ? 0x995118aa
//                                   //                     : green
//                                   //                         ? 0x996eba0d
//                                   //                         : 0x00FFFFFF),
//                                   //             BlendMode.color))
//                                   img))
//                       : SizedBox(),
//                   upload
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text("Optimizing Image",
//                                   style: TextStyle(
//                                       fontSize: 18.sp,
//                                       color: Color(0xffffffff),
//                                       fontWeight: FontWeight.w600)),
//                               const SizedBox(height: 20),
//                               CirclePercentIndicator(
//                                   percent: percent, percentage: percentage)
//                             ],
//                           ),
//                         )
//                       : SizedBox(),
//                   saver
//                       ? Center(
//                           child: Container(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SizedBox(height: 20.h),
//                                   Text("Saving Photo",
//                                       style: TextStyle(
//                                           fontSize: 18.sp,
//                                           color: Color(0xff453c53),
//                                           fontWeight: FontWeight.w600)),
//                                   SizedBox(height: 20.h),
//                                   CirclePercentIndicator(
//                                       percent: percent, percentage: percentage),
//                                   SizedBox(height: 20.h),
//                                   SizedBox(
//                                       width: 89.w,
//                                       height: 44.h,
//                                       child: Image.asset(
//                                           "assets/icons/cancel.png")),
//                                   SizedBox(height: 25.h)
//                                 ],
//                               ),
//                               height: 236.h,
//                               width: 300.w,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30.r),
//                                 color: Colors.white,
//                               )),
//                         )
//                       : SizedBox(),
//                 ]),
//               ),
//             )),
//             SizedBox(
//                 height: 150.h,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               viewerController.value = Matrix4.identity();
//                               hd = !hd;
//                               color = false;
//                               // colors = false;
//                               // red = false;
//                               // green = false;
//                               dragBar = false;
//                               // blue = false;
//                               // tracker = !tracker;
//                               if (hd) {
//                                 if (optimized) {
//                                   photoInfo(token, oId);
//                                   dragBar = true;
//                                 } else {
//                                   optimizeImage(token, oId);
//                                   upload = true;
//                                 }
//                               } else if (!hd) {
//                                 upload = false;
//                               }
//                             });
//                           },
//                           child: SizedBox(
//                               width: 35.w,
//                               height: 35.h,
//                               child: Image.asset("assets/icons/HDbutton.png",
//                                   color: hd ? const Color(0xff5118aa) : null)),
//                         ),
//                         SizedBox(height: 17.5.h),
//                         Text("Super",
//                             style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Color(0xff453c53),
//                                 fontWeight: FontWeight.w500)),
//                         Text("Resolution",
//                             style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Color(0xff453c53),
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               viewerController.value = Matrix4.identity();
//                               color = !color;
//                               // red = false;
//                               // blue = false;
//                               // green = false;
//                               // colors = false;
//                               dragBar = false;
//                               hd = false;
//                               //scratch = false;
//                               if (color) {
//                                 if (colorized) {
//                                   photoInfo(token, oId);
//                                   dragBar = true;
//                                 } else {
//                                   colorizeImage(token, oId);
//                                   upload = true;
//                                 }
//                               } else if (!color) {
//                                 upload = false;
//                               }
//                             });
//                           },
//                           child: SizedBox(
//                               width: 35.w,
//                               height: 35.h,
//                               child: Image.asset(
//                                 "assets/icons/addcolorbutton.png",
//                                 color: color ? const Color(0xff5118aa) : null,
//                               )),
//                         ),
//                         SizedBox(height: 17.5.h),
//                         Text("Add",
//                             style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Color(0xff453c53),
//                                 fontWeight: FontWeight.w500)),
//                         Text("Colorization",
//                             style: TextStyle(
//                                 fontSize: 14.sp,
//                                 color: Color(0xff453c53),
//                                 fontWeight: FontWeight.w500)),
//                       ],
//                     ),
//                     // Column(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [
//                     //     InkWell(
//                     //       onTap: () {
//                     //         setState(() {
//                     //           scratch = !scratch;
//                     //           hd = false;
//                     //           color = false;
//                     //           colors = false;
//                     //           red = false;
//                     //           blue = false;
//                     //           green = false;
//                     //         });
//                     //       },
//                     //       child: SizedBox(
//                     //           width: 35.w,
//                     //           height: 35.h,
//                     //           child: scratch
//                     //               ? Image.asset(
//                     //                   "assets/icons/cancelledbutton.png")
//                     //               : Image.asset(
//                     //                   "assets/icons/cancelbutton.png")),
//                     //     ),
//                     //     SizedBox(height: 17.5.h),
//                     //     Text("Remove",
//                     //         style: TextStyle(
//                     //             fontSize: 14.sp,
//                     //             color: Color(0xff453c53),
//                     //             fontWeight: FontWeight.w500)),
//                     //     Text("Scratches",
//                     //         style: TextStyle(
//                     //             fontSize: 14.sp,
//                     //             color: Color(0xff453c53),
//                     //             fontWeight: FontWeight.w500)),
//                     //   ],
//                     // )
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
