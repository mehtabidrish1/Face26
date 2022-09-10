import 'dart:convert';
import 'package:face26_mobile/backend/apis/paymentIntentApi.dart';
import 'package:face26_mobile/backend/models/paymentIntentModel.dart';
import 'package:face26_mobile/backend/models/productPackageRateModel.dart';
import 'package:face26_mobile/widgets/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/apis/productRatePackageApi.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  String token;
  Checkout({Key? key, required this.token}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late double perRate;
  int discount = 0;
  String description = ' ';
  bool highlight = false;
  String id = '';
  int price = 999;
  int quantity = 999;
  String title = '';
  String clientSecret = '';
  Uri? paymentLink;

  PageNum pageNum = PageNum.first;
  ProductRatePackageGet packageInfoservice = ProductRatePackageGet();
  ProductPackageList? productpackageInfoModel;
  PaymentIntentService paymentIntentService = PaymentIntentService();
  late PaymentIntentModel paymentIntentModel;

  getClientSecret() async {
    await paymentIntentService.paymentIntent(widget.token).then((value) {
      paymentIntentModel = value;
      clientSecret = paymentIntentModel.clientSecret;
      print("client ka secret $clientSecret");
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: SizedBox(
        height: 959.h,
        width: 1205.w,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Theme(
            data: ThemeData(
                // accentColor: Colors.green,
                // primarySwatch: Colors.green,
                colorScheme: ColorScheme.light(
              primary: Color(0xff5118aa),
            )),
            child: Row(
              children: [
                Container(
                  width: 500.w,
                  height: 959.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0.r),
                    color: Color(0xff5118aa),
                  ),
                  child: Container(
                      margin: EdgeInsets.fromLTRB(70.r, 58.r, 120.r, 50.r),
                      child: pageNum == PageNum.first
                          ? Stack(
                              children: [
                                Positioned(
                                    left: 18.r,
                                    child: SizedBox(
                                        height: 53.h,
                                        width: 53.w,
                                        child: Image.asset(
                                          'assets/images/group181.png',
                                        ))),
                                Positioned(
                                  right: 15.r,
                                  top: 80.r,
                                  child: SizedBox(
                                      height: 47.h,
                                      width: 67.w,
                                      child: Image.asset(
                                        'assets/images/highlight14.png',
                                        color: Colors.white,
                                      )),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    SizedBox(
                                        height: 541.h,
                                        width: 279.w,
                                        child: Image.asset(
                                          'assets/images/group36.png',
                                        )),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 83.h,
                                          width: 111.w,
                                          child: Image.asset(
                                            'assets/images/group101.png',
                                          ),
                                        ),
                                        Expanded(child: SizedBox())
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned(
                                  left: 10,
                                  child: SizedBox(
                                      height: 53.h,
                                      width: 53.w,
                                      child: Image.asset(
                                        'assets/images/group181.png',
                                      )),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListTile(
                                      minLeadingWidth: 2.w,
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          CircleAvatar(
                                            child: pageNum == PageNum.second
                                                ? CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/Content.png'),
                                                    radius: 5.r,
                                                  )
                                                : null,
                                            radius: 9.r,
                                            backgroundColor: Colors.white,
                                          ),
                                          Image.asset(
                                            'assets/images/Connector.png',
                                            height: 35.h,
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                          translation(context).choosePlan,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                      subtitle: Text(
                                          translation(context).chooserightPlan,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    ListTile(
                                      minLeadingWidth: 2.w,
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          CircleAvatar(
                                            child: pageNum == PageNum.third
                                                ? CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/Content.png'),
                                                    radius: 5.r,
                                                  )
                                                : null,
                                            radius: 9.r,
                                            backgroundColor: Colors.white,
                                          ),
                                          Image.asset(
                                            'assets/images/Connector.png',
                                            height: 35.h,
                                          ),
                                        ],
                                      ),
                                      title: Text(translation(context).checkout,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                      subtitle: Text(
                                          translation(context).checkoutSub,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    ListTile(
                                      minLeadingWidth: 2.w,
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          CircleAvatar(
                                            // child: CircleAvatar(
                                            //   backgroundImage: AssetImage(
                                            //       'assets/images/Content.png'),
                                            //   radius: 5.r,
                                            // ),
                                            radius: 9.r,
                                            backgroundColor: Colors.white,
                                          )
                                        ],
                                      ),
                                      title: Text(
                                          translation(context).purchaseComplete,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                      subtitle: Text(
                                          translation(context)
                                              .purchaseCompleteSub,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: pageNum == PageNum.second
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 14.h,
                                              width: 86.w,
                                              child: Image.asset(
                                                'assets/images/slideRectangleBig.png',
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            SizedBox(
                                              height: 14.h,
                                              width: 14.w,
                                              child: Image.asset(
                                                'assets/images/slideRectangleSmall.png',
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 14.h,
                                              width: 14.w,
                                              child: Image.asset(
                                                'assets/images/slideRectangleSmall.png',
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            SizedBox(
                                              height: 14.h,
                                              width: 86.w,
                                              child: Image.asset(
                                                'assets/images/slideRectangleBig.png',
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ],
                            )),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(70.r, 55.r, 100.r, 48.r),
                    color: Colors.white,
                    child: Center(
                      child: SizedBox(
                        width: 556.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pageNum == PageNum.first
                                ? SizedBox()
                                : Text(translation(context).sevenDay,
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: Color(0xff5118AA),
                                        fontWeight: FontWeight.w900)),
                            SizedBox(
                              height: 9.h,
                            ),
                            pageNum == PageNum.first
                                ? SizedBox()
                                : Text(translation(context).addCredit,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff1A1A31),
                                        fontWeight: FontWeight.w600)),
                            SizedBox(
                              height: 50.h,
                            ),
                            pageNum == PageNum.first
                                ? WhiteContainerContent()
                                : pageNum == PageNum.second
                                    ? loading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : WhiteContainerContent1(
                                            productData:
                                                productpackageInfoModel)
                                    : pageNum == PageNum.third
                                        ? WhiteContainerContent2()
                                        : SizedBox(),
                            Expanded(child: SizedBox()),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 70.h,
                                width: 500.w,
                                margin: EdgeInsets.all(5.0.r),
                                child: ElevatedButton(
                                  onPressed: (() async {
                                    if (pageNum == PageNum.first) {
                                      print('page1 start');
                                      pageNum = PageNum.second;
                                      var request = http.Request(
                                          'POST',
                                          Uri.parse(
                                              'http://176.9.137.77:8023/authentication/payment/'));
                                      http.StreamedResponse response =
                                          await request.send();

                                      if (response.statusCode == 200) {
                                        print('page1 success');
                                        String abc = await response.stream
                                            .bytesToString();
                                        print(abc);
                                        String asd =
                                            abc.substring(1, abc.length - 1);
                                        print(asd);
                                        paymentLink = Uri.parse(asd);
                                        getProductInfoFunction();
                                      } else {
                                        print(response.reasonPhrase);
                                      }
                                    } else if (pageNum == PageNum.second) {
                                      print('2nd button');
                                      //final link = Uri.parse(paymentLink);
                                      await launchUrl(paymentLink!);
                                      // getClientSecret();
                                      // pageNum = PageNum.third;
                                    }
                                    // setState(() async {
                                    //   if (pageNum == PageNum.first) {
                                    //     loading = true;
                                    //     getProductInfoFunction();
                                    //     pageNum = PageNum.second;
                                    //   } else if (pageNum == PageNum.second) {
                                    //     print('2nd button');
                                    //     var request = http.Request(
                                    //         'POST',
                                    //         Uri.parse(
                                    //             'http://176.9.137.77:8023/authentication/payment/'));
                                    //     http.StreamedResponse response =
                                    //         await request.send();

                                    //     if (response.statusCode == 200) {
                                    //       String paymentLink = await response
                                    //           .stream
                                    //           .bytesToString();
                                    //       print(paymentLink);
                                    //       await launchUrl(
                                    //           Uri.parse(paymentLink));
                                    //     } else {
                                    //       print(response.reasonPhrase);
                                    //     }
                                    //     // getClientSecret();
                                    //     // pageNum = PageNum.third;
                                    //   } else if (pageNum == PageNum.third) {
                                    //     //redirectToCheckout(context);

                                    //   }
                                    // });
                                  }),
                                  child: pageNum == PageNum.first
                                      ? Text(
                                          translation(context).registerNow,
                                          textAlign: TextAlign.center,
                                        )
                                      : pageNum == PageNum.second
                                          ? Text(translation(context).payment)
                                          : pageNum == PageNum.third
                                              ? Text(translation(context)
                                                  .startTrial)
                                              : SizedBox(),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35.r),
                                              side: BorderSide(
                                                  color: Color(0xff0056d7),
                                                  width: 1.5.w))),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              // horizontal: 190.w,
                                              //vertical: 40.h
                                              )),
                                      textStyle: MaterialStateProperty.all(
                                          TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w700)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0XFF5118AA)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
  getProductInfoFunction() async {
    //loading = true;

    final response = await packageInfoservice.productPackagesInfo();
    if (response.body.isNotEmpty) {
      try {
        final responseJsonData = jsonDecode(response.body);
        productpackageInfoModel = ProductPackageList.fromJson(responseJsonData);
        packageInfoservice.dispose();
      } catch (e) {
        Toast.show("Error occured $e", duration: 2, gravity: Toast.center);
      }
    } else {
      Toast.show("response is null", duration: 2, gravity: Toast.center);
    }

    if (productpackageInfoModel!.products != null ||
        productpackageInfoModel!.products.length != 0) {
      setState(() {
        loading = false;
      });
    } else {
      Toast.show("ProductList is null", duration: 2, gravity: Toast.center);
    }
  }
}

class WhiteContainerContent extends StatelessWidget {
  const WhiteContainerContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translation(context).freeTrialTitle,
            style: TextStyle(
                fontSize: 22.sp,
                color: Color(0xff5118AA),
                fontWeight: FontWeight.w900)),
        SizedBox(
          height: 9.h,
        ),
        Text(translation(context).registersubTitle,
            style: TextStyle(
                fontSize: 18.sp,
                color: Color(0xff1A1A31),
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: 50.h,
        ),
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomListTileWhite(tile: translation(context).registerStep1),
              SizedBox(height: 10.h),
              CustomListTileWhite(
                tile: translation(context).registerStep2,
              ),
              SizedBox(height: 10.h),
              CustomListTileWhite(
                tile: translation(context).registerStep3,
              ),
              SizedBox(height: 10.h),
              CustomListTileWhite(
                tile: translation(context).registerStep4,
              ),
              SizedBox(height: 10.h),
              CustomListTileWhite(
                tile: translation(context).registerStep5,
              ),
            ],
          ),
        ),
        Container(
          height: 60.h,
          constraints: BoxConstraints(minHeight: 50.h, maxHeight: 160.h),
        ),
        SizedBox(
          child: Column(
            children: [
              Text(translation(context).registerText1,
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Color(0xff1A1A31),
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 65.h,
              ),
              Text(translation(context).registerText2,
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Color(0xff1A1A31),
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 13.h,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CustomListTileWhite extends StatelessWidget {
  String tile;
  CustomListTileWhite({Key? key, required this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Color(0xff00DA8B),
          size: 18,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text('$tile ',
            style: TextStyle(
                fontSize: 18.sp,
                color: Color(0xff1a1a31),
                fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class WhiteContainerContent2 extends StatefulWidget {
  const WhiteContainerContent2({
    Key? key,
  }) : super(key: key);

  @override
  State<WhiteContainerContent2> createState() => _WhiteContainerContent2State();
}

class _WhiteContainerContent2State extends State<WhiteContainerContent2> {
  String dropdownValue = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.only(left: 5.0.r, right: 5.0.r),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3.0.r)),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, size: 22.r),
                      underline: SizedBox(),
                      items: <String>[
                        'Credit Card',
                        'Net Banking',
                        'UPI',
                        'Debit Card'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        //Do something with this value

                        dropdownValue = value!;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                    child: Container(
                        height: 60.h,
                        padding: EdgeInsets.only(left: 5.0.r, right: 5.0.r),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3.0.r)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            SizedBox(
                                height: 65.h,
                                width: 80.w,
                                child: Image.asset('assets/images/Paypal.png')),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text('PayPal'),
                          ],
                        ))),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text('Name on Card'),
          SizedBox(height: 8.0.h),
          SizedBox(
            height: 60.h,
            width: double.maxFinite,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'add Card Holders Name',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 32.0.w),
                      borderRadius: BorderRadius.circular(5.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                      borderRadius: BorderRadius.circular(5.0))),
              onChanged: (value) {
                //Do something with this value
              },
            ),
          ),
          SizedBox(height: 15.0.h),
          Text('Card Number'),
          SizedBox(height: 8.0.h),
          SizedBox(
            height: 60.h,
            width: double.maxFinite,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'add Card Number',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 32.0.w),
                      borderRadius: BorderRadius.circular(5.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                      borderRadius: BorderRadius.circular(5.0))),
              onChanged: (value) {
                //Do something with this value
              },
            ),
          ),
          SizedBox(height: 15.0.h),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                    height: 60.h,
                    //  width: 200,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'expiry date',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 32.0.w),
                              borderRadius: BorderRadius.circular(5.0.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0.w),
                              borderRadius: BorderRadius.circular(5.0.r))),
                      onChanged: (value) {
                        //Do something with this value
                      },
                    )),
              ),
              SizedBox(
                width: 20.w,
              ),
              Flexible(
                child: SizedBox(
                    height: 60.h,
                    //  width: 200,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'CVC',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 32.0.w),
                              borderRadius: BorderRadius.circular(5.0.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0.w),
                              borderRadius: BorderRadius.circular(5.0.r))),
                      onChanged: (value) {
                        //Do something with this value
                      },
                    )),
              )
            ],
          ),
          Text('Billing Address'),
          SizedBox(height: 8.0.h),
          SizedBox(
            height: 60.h,
            width: double.maxFinite,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Country',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 32.0.w),
                      borderRadius: BorderRadius.circular(5.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                      borderRadius: BorderRadius.circular(5.0))),
              onChanged: (value) {
                //Do something with this value
              },
            ),
          ),
          SizedBox(height: 15.0.h),
          SizedBox(
            height: 60.h,
            width: double.maxFinite,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Street',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 32.0.w),
                      borderRadius: BorderRadius.circular(5.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0.w),
                      borderRadius: BorderRadius.circular(5.0))),
              onChanged: (value) {
                //Do something with this value
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WhiteContainerContent1 extends StatefulWidget {
  WhiteContainerContent1({
    Key? key,
    required this.productData,
  }) : super(key: key);

  final ProductPackageList? productData;

  @override
  State<WhiteContainerContent1> createState() => _WhiteContainerContent1State();
}

class _WhiteContainerContent1State extends State<WhiteContainerContent1> {
  get productListLength => widget.productData!.products.length;

  int? clicked;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(productListLength, (index) {
          List<Product> products = widget.productData!.products;
          // List<String> price = [
          //   'price_1LUVhCSDW8g6kowQtN6Y4XRh',
          //   'price_1LUVplSDW8g6kowQQ6wWqvO4',
          //   'price_1LUVvhSDW8g6kowQDnsd5sxe'
          // ];
          return Transform.scale(
            scale: (clicked == index) ? 1.1 : 1.0,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                InkWell(
                    onTap: () {
                      print('clicked$index');
                      clicked = index;
                      setState(() {});
                    },
                    child: SubscriptionOptionCard(product: products[index])),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          );
        }));
  }
}
// [
//         SizedBox(
//           height: 40.h,
//         ),
//         SubscriptionOptionCard(
//           discount: discount,
//           price: price,
//           perRate: perRate,
//           subsplanDuration: 'Yearly',
//         ),
//         SizedBox(
//           height: 30.h,
//         ),
//         SubscriptionOptionCard(
//           discount: discount,
//           price: price,
//           perRate: perRate,
//           subsplanDuration: 'Monthly',
//         ),
//         SizedBox(
//           height: 44.h,
//         ),
//         Text('''7-day free trial. Cancel anytime.''',
//             style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Color(0xff1A1A31),
//                 fontWeight: FontWeight.w500)),
//       ],

class SubscriptionOptionCard extends StatefulWidget {
  SubscriptionOptionCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<SubscriptionOptionCard> createState() => _SubscriptionOptionCardState();
}

class _SubscriptionOptionCardState extends State<SubscriptionOptionCard> {
  final double discount = 50;

  late final double pricePerProduct;

  @override
  void initState() {
    pricePerProduct = widget.product.price / widget.product.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: (widget.product.price == 10)
              ? SizedBox(
                  height: 38.h,
                  width: 113.w,
                  child: Image.asset('assets/images/rectangle474.png'))
              : SizedBox(),
          top: 2.r,
          right: -8.r,
        ),
        Positioned(
          child: (widget.product.price == 10)
              ? Text('save $discount%',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w700))
              : SizedBox(),
          top: 10.r,
          right: 20.r,
        ),
        Container(
          width: 564.w,
          height: 125.h,
          decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: Color(0xff5118AA)),
              borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(widget.product.title,
                        style: TextStyle(
                            fontSize: 22.sp,
                            letterSpacing: 1,
                            color: Color(0xff453C53),
                            fontWeight: FontWeight.w900)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.product.quantity}x Photos ',
                        style: TextStyle(
                            fontSize: 14.sp,
                            letterSpacing: 0.5,
                            color: Color(0xff453C53),
                            fontWeight: FontWeight.w900)),
                    RichText(
                      text: TextSpan(
                          text: translation(context).euro,
                          style: TextStyle(
                              color: Color(0xff5118AA), fontSize: 18.sp),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${widget.product.price}',
                              style: TextStyle(
                                  color: Color(0xff5118AA),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                              // recognizer: TapGestureRecognizer()
                              //   ..onTap = () {
                              //     // navigate to desired screen
                              //   }
                            ),
                            TextSpan(
                              text: translation(context).euro,
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12.sp),
                            ),
                            TextSpan(
                              text: pricePerProduct.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12.sp),
                              // recognizer: TapGestureRecognizer()
                              //   ..onTap = () {
                              //     // navigate to desired screen
                              //   }
                            ),
                            TextSpan(
                              text: ' /photo',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12.sp),
                              // recognizer: TapGestureRecognizer()
                              //   ..onTap = () {
                              //     // navigate to desired screen
                              //   }
                            )
                          ]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum PageNum {
  first,
  second,
  third,
}

class PaymentItem {
  final String descrition;
  final bool highlight;
  final String? id;
  final int? price;
  final int? quantity;
  final String? title;

  const PaymentItem(
      {this.descrition = '',
      this.highlight = false,
      this.id,
      this.price,
      this.quantity,
      this.title});

  Map<String, Object?> toMap() => {
        'descrition': descrition,
        'highlight': highlight,
        'id': id,
        'price': price,
        'quantity': quantity,
        'title': title,
      };
}
