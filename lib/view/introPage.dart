import 'package:face26_mobile/view/introductionStep1.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 78.h),
            SizedBox(
                height: 82.h,
                width: 82.w,
                child: Image.asset("assets/icons/icon.png")),
            SizedBox(height: 56.h),
            SizedBox(
                height: 330.h,
                width: 330.w,
                child: Image.asset("assets/images/splash_center.png")),
            SizedBox(height: 21.h),
            Text(
              translation(context).enhancePhoto,
              style: TextStyle(
                  fontSize: 26.sp,
                  color: Color(0XFF5118AA),
                  fontWeight: FontWeight.w700),
            ),
            // Text(
            //   "photos in one tap",
            //   style: TextStyle(
            //       fontSize: 26.sp,
            //       color: Color(0XFF5118AA),
            //       fontWeight: FontWeight.w700),
            // ),
            SizedBox(height: 25.h),
            ElevatedButton(
                onPressed: () {
                  if (kIsWeb) {
                    Navigator.pushNamed(context, '/home');
                  } else {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: IntroductionStep1()));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(translation(context).getStarted),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 89.w, vertical: 24.h)),
                    textStyle: MaterialStateProperty.all(TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0XFF5118AA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white))),
            // SizedBox(
            //   height: 90.h,
            // )
          ],
        ),
      ),
    );
  }
}
