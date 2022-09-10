import 'dart:typed_data';
import 'dart:ui';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:http/http.dart' as http;
import 'package:face26_mobile/widgets/percentIndicatorWidget.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

class DownloadBox extends StatefulWidget {
  String link;
  String name;
  DownloadBox({Key? key, required this.link, required this.name})
      : super(key: key);

  @override
  State<DownloadBox> createState() => _DownloadBoxState();
}

class _DownloadBoxState extends State<DownloadBox> {
  double percent = 0;
  int percentage = 0;
  int _total = 0, _received = 0;
  late http.StreamedResponse _response;
  final List<int> _bytes = [];
  String? link;
  String? name;

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
          .saveFile(name!, imgByte, 'png', mimeType: MimeType.PNG);
      // final file = File(
      //     '${(await getApplicationDocumentsDirectory()).path}/$imgName.png');
      // print(file);
      // await file.writeAsBytes(_bytes);
      //saver = false;
      percent = 0;
      percentage = 0;
      // Toast.show("Downloaded", duration: 2, gravity: Toast.bottom);
      // setState(() {
      // _image = file;
      // });
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                      contentPadding: EdgeInsets.all(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r)),
                      content: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: 500.w,
                                height: 500.h,
                                child: Image.network(link!)),
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
                                      child: Text(link!,
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
                                        Toast.show("Copied to clilpboard",
                                            duration: 2, gravity: Toast.bottom);
                                      },
                                      child: Image.asset(
                                          "assets/icons/copyIcon.png"),
                                    )
                                  ]),
                            )
                          ]));
                }));
          });
    });
  }

  @override
  void initState() {
    super.initState();
    link = widget.link;
    name = widget.name;
    _downloadImage(link!, name!);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40.r))),
        child: Padding(
          padding: EdgeInsets.only(
              top: 57.h, bottom: 84.h, left: 120.w, right: 120.w),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(translation(context).saving,
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Color(0xff453c53),
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 36.h),
                CirclePercentIndicator(
                    percent: percent, percentage: percentage),
                SizedBox(height: 37.h),
                SizedBox(
                    width: 289.w,
                    height: 58.h,
                    child: Image.asset("assets/icons/cancel.png")),
                //SizedBox(height: 25.h)
              ]),
        ),
      ),
    );
  }
}
