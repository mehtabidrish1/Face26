import 'dart:ui';
import 'package:face26_mobile/widgets/payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pay/pay.dart';

showDialogs(BuildContext context) {
  String title = '';
  double? cost;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.h, vertical: 28.h),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("GET",
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Color(0xff5118aa),
                            fontWeight: FontWeight.w700)),
                    SizedBox(width: 15.w),
                    SizedBox(
                      width: 85.w,
                      height: 44.h,
                      child: Image.asset("assets/icons/probutton.png"),
                    )
                  ]),
                  SizedBox(height: 22.h),
                  Column(
                    children: [
                      Text("Add Credit to use this App",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xff1a1a31),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 26.h)
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        cost = 2.0;
                        title = "3x Photos Package";
                      });
                    },
                    child: Container(
                      height: 77.h,
                      width: 290.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              color: const Color(0xff8115aa), width: 2.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<double>(
                                activeColor: const Color(0xff5118aa),
                                fillColor: MaterialStateProperty.all(
                                    const Color(0xff5118aa)),
                                value: 2.0,
                                groupValue: cost,
                                onChanged: (value) {
                                  setState(() {
                                    cost = 2.0;
                                    title = "3x Photos Package";
                                  });
                                }),
                          ),
                          //SizedBox(width: 15.w),
                          Text("3x Photos",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff453c53),
                                  fontWeight: FontWeight.w600)),
                          //SizedBox(width: 45.w),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("€",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 5.w),
                                  Text("2",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              // SizedBox(height: 3.h),
                              Text("€ 0.67/photo",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xff1a1a31),
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 6.h)
                            ],
                          ),
                          SizedBox(width: 22.w)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 17.h),
                  InkWell(
                    onTap: () {
                      setState(() {
                        cost = 5.0;
                        title = "10x Photos Package";
                      });
                    },
                    child: Container(
                      height: 77.h,
                      width: 290.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              color: const Color(0xff8115aa), width: 2.0)),
                      child: Row(
                        children: [
                          // SizedBox(width: 13),
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<double>(
                                activeColor: const Color(0xff5118aa),
                                fillColor: MaterialStateProperty.all(
                                    const Color(0xff5118aa)),
                                value: 5.0,
                                groupValue: cost,
                                onChanged: (value) {
                                  setState(() {
                                    cost = 5.0;
                                    title = "10x Photos Package";
                                  });
                                }),
                          ),
                          // SizedBox(width: 13),
                          Text("10x Photos",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff453c53),
                                  fontWeight: FontWeight.w600)),
                          //SizedBox(width: 41.w),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("€",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 5.w),
                                  Text("5",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              // const SizedBox(height: 5),
                              Text("€ 0.50/photo",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xff1a1a31),
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 6.h)
                            ],
                          ),
                          SizedBox(width: 20.w)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 17.h),
                  InkWell(
                    onTap: () {
                      setState(() {
                        cost = 10.0;
                        title = "30x Photo Package";
                      });
                    },
                    child: Container(
                      height: 77.h,
                      width: 290.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              color: const Color(0xff8115aa), width: 2.0)),
                      child: Row(
                        children: [
                          // SizedBox(width: 13),
                          Transform.scale(
                            scale: 1.5,
                            child: Radio<double>(
                                activeColor: const Color(0xff5118aa),
                                fillColor: MaterialStateProperty.all(
                                    const Color(0xff5118aa)),
                                value: 10.0,
                                groupValue: cost,
                                onChanged: (value) {
                                  setState(() {
                                    cost = value;
                                    title = "30x Photo Package";
                                  });
                                }),
                          ),
                          Text("30x Photos",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff453c53),
                                  fontWeight: FontWeight.w600)),
                          //SizedBox(width: 36.w),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("€",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 5.w),
                                  Text("10",
                                      style: TextStyle(
                                          fontSize: 30.sp,
                                          color: Color(0xff5118aa),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              // SizedBox(height: 5.h),
                              Text("€ 0.33/photo",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xff1a1a31),
                                      fontWeight: FontWeight.w500)),

                              SizedBox(height: 6.h)
                            ],
                          ),

                          SizedBox(width: 20.w)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                      onPressed: () {
                        if (kIsWeb) {
                          Navigator.pushNamed(context, '/checkout');
                        } else {
                          final List<PaymentItem> _paymentItems = [
                            PaymentItem(
                                amount: cost.toString(),
                                label: title,
                                status: PaymentItemStatus.final_price)
                          ];
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: Payments(paymentItem: _paymentItems)));
                        }
                      },
                      child: Text(
                        "Choose a Plan",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.r))),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 65.w, vertical: 24.h)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff5118aa))))
                ]),
              );
            },
          ),
        );
      });
}
