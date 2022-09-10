import 'package:face26_mobile/view/homePage.dart';
import 'package:face26_mobile/view/imageEditor.dart';
import 'package:face26_mobile/widgets/sliderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class IntroductionStep3 extends StatelessWidget {
  const IntroductionStep3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Image.asset(
        "assets/images/beauty_before.png",
        fit: BoxFit.fill,
      ),
      VerticalSplitView(
          left: Container(),
          right:
              Image.asset("assets/images/beauty_after.png", fit: BoxFit.fill)),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.70),
          Padding(
            padding: EdgeInsets.only(bottom: 33.h, left: 20.w, right: 20.w),
            child: Container(
              decoration: BoxDecoration(
                  // backgroundBlendMode: BlendMode.modulate,
                  color: Color(0x336a6a6a),
                  borderRadius: BorderRadius.circular(40.r)),
              // height: 155,
              // width: 358,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 33.h),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Facial Details",
                            style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        Text("De-scratch",
                            style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(width: 41.w),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: HomePage()));
                      },
                      child: SizedBox(
                        height: 88.h,
                        width: 62.w,
                        child: Image.asset("assets/icons/nextbutton3.png"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    ]));
  }
}
