import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CirclePercentIndicator extends StatefulWidget {
  double percent;
  int percentage;
  CirclePercentIndicator(
      {Key? key, required this.percent, required this.percentage})
      : super(key: key);

  @override
  State<CirclePercentIndicator> createState() => _CirclePercentIndicatorState();
}

class _CirclePercentIndicatorState extends State<CirclePercentIndicator> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      linearGradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [
            0.2,
            0.5,
            0.7,
            0.9,
            //  0.9,
            //  1.0
          ],
          colors: [
            Color(0xff3E008E),
            Color(0xff6818AE),
            Color(0xff9732D1),
            Color(0xffB945EA),
            //  Color(0xffCD50F9),
            // Color(0xffD554FF),
          ]),
      animation: true,
      animationDuration: 4000,
      animateFromLastPercent: true,
      percent: widget.percent,
      radius: 39,
      lineWidth: 4,
      //progressColor: Color(0xff5118aa),
      backgroundColor: const Color(0xffc4c4c4),
      circularStrokeCap: CircularStrokeCap.round,
      center: Container(
          child: Center(
            child: Text(" ${widget.percentage}%",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w600)),
          ),
          height: 60,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.2,
                    0.5,
                    0.7,
                    0.8,
                    0.9,
                    1.0
                  ],
                  colors: [
                    Color(0xff3E008E),
                    Color(0xff6818AE),
                    Color(0xff9732D1),
                    Color(0xffB945EA),
                    Color(0xffCD50F9),
                    Color(0xffD554FF),
                  ]))),
    );
  }
}
