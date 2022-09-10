import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutMob extends StatelessWidget {
  const CheckoutMob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: 65.w,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios_new_outlined,
                              color: Colors.black),
                          Text("Back",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                translation(context).sevenDay,
                style: TextStyle(
                    color: Color(0xff5118aa),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              Text(
                "Payment method (You won’t be",
                style: TextStyle(
                    color: Color(0xff1a1a31),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 05.h),
              Text(
                "charged today)",
                style: TextStyle(
                    color: Color(0xff1a1a31),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 42.h),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xff5118aa), width: 1.5)),
                            prefixIcon: Icon(Icons.credit_card,
                                color: Color(0xff5118aa)),
                            hintText: "Card",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xffd8d8d8), width: 1.5))),
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xff5118aa), width: 1.5)),
                            prefixIcon: Icon(
                              Icons.paypal,
                              color: Colors.blue.shade700,
                            ),
                            hintText: "Paypal",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xffd8d8d8), width: 1.5))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(color: Color(0xff5118aa), width: 1.5)),
                    hintText: "Name on Card",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
              ),
              SizedBox(height: 10.h),
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            BorderSide(color: Color(0xff5118aa), width: 1.5)),
                    suffixIcon: Icon(
                      Icons.credit_card,
                      color: Color(0xff5118aa),
                    ),
                    hintText: "Card Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide:
                            BorderSide(color: Color(0xffd8d8d8), width: 1.5))),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xff5118aa), width: 1.5)),
                            hintText: "Expiry Date",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xffd8d8d8), width: 1.5))),
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xff5118aa), width: 1.5)),
                            suffixIcon: Icon(
                              Icons.credit_card,
                              color: Color(0xff5118aa),
                            ),
                            hintText: "CVC",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: Color(0xffd8d8d8), width: 1.5))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      text: 'This site is protected by Google ',
                      style: TextStyle(
                          color: Color(0xff757575),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: Color(0xff5118aa),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                              })
                      ]),
                ),
              ),
              SizedBox(
                height: 07,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      text: 'and ',
                      style: TextStyle(
                          color: Color(0xff757575),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms of Services',
                            style: TextStyle(
                                color: Color(0xff5118aa),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                              }),
                        TextSpan(
                            text: ' apply',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400))
                      ]),
                ),
              ),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Year Price",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w500)),
                  Text("\$55",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Taxes",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w500)),
                  Text("\$0",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w700)),
                  Text("\$55.99",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: 33.h),
              ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [Spacer(), Text("Start Free Trial"), Spacer()],
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.r))),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          // horizontal: 200.w,
                          vertical: 23.h)),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w700)),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0XFF5118AA)),
                      foregroundColor: MaterialStateProperty.all(Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}
