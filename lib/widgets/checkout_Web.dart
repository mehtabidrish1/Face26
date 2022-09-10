// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CheckoutWeb extends StatefulWidget {
//   CheckoutWeb({Key? key}) : super(key: key);

//   @override
//   State<CheckoutWeb> createState() => _CheckoutWebState();
// }

// class _CheckoutWebState extends State<CheckoutWeb> {
//   late double perRate;
//   int discount = 0;
//   String description = ' ';
//   bool highlight = false;
//   String id = '';
//   int price = 999;
//   int quantity = 999;
//   String title = '';
//   String clientSecret = '';
//   get productListLength => widget.productData!.products.length;
//   int? clicked;
//   bool loading = false;
//   PageNum pageNum = PageNum.first;

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: ShapeBorderClipper(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
//       child: SizedBox(
//         height: 959.h,
//         width: 1205.w,
//         child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Theme(
//             data: ThemeData(
//                 // accentColor: Colors.green,
//                 // primarySwatch: Colors.green,
//                 colorScheme: ColorScheme.light(
//               primary: Color(0xff5118aa),
//             )),
//             child: Row(
//               children: [
//                 Container(
//                   width: 500.w,
//                   height: 959.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20.0.r),
//                     color: Color(0xff5118aa),
//                   ),
//                   child: Container(
//                       margin: EdgeInsets.fromLTRB(70.r, 58.r, 120.r, 50.r),
//                       child: pageNum == PageNum.first
//                           ? Stack(
//                               children: [
//                                 Positioned(
//                                     left: 18.r,
//                                     child: SizedBox(
//                                         height: 53.h,
//                                         width: 53.w,
//                                         child: Image.asset(
//                                           'assets/images/group181.png',
//                                         ))),
//                                 Positioned(
//                                   right: 15.r,
//                                   top: 80.r,
//                                   child: SizedBox(
//                                       height: 47.h,
//                                       width: 67.w,
//                                       child: Image.asset(
//                                         'assets/images/highlight14.png',
//                                         color: Colors.white,
//                                       )),
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       height: 25.h,
//                                     ),
//                                     SizedBox(
//                                         height: 541.h,
//                                         width: 279.w,
//                                         child: Image.asset(
//                                           'assets/images/group36.png',
//                                         )),
//                                     SizedBox(
//                                       height: 1.h,
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                           height: 83.h,
//                                           width: 111.w,
//                                           child: Image.asset(
//                                             'assets/images/group101.png',
//                                           ),
//                                         ),
//                                         Expanded(child: SizedBox())
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             )
//                           : Stack(
//                               children: [
//                                 Positioned(
//                                   left: 10,
//                                   child: SizedBox(
//                                       height: 53.h,
//                                       width: 53.w,
//                                       child: Image.asset(
//                                         'assets/images/group181.png',
//                                       )),
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     ListTile(
//                                       minLeadingWidth: 2.w,
//                                       leading: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 10.h,
//                                           ),
//                                           CircleAvatar(
//                                             child: pageNum == PageNum.second
//                                                 ? CircleAvatar(
//                                                     backgroundImage: AssetImage(
//                                                         'assets/images/Content.png'),
//                                                     radius: 5.r,
//                                                   )
//                                                 : null,
//                                             radius: 9.r,
//                                             backgroundColor: Colors.white,
//                                           ),
//                                           Image.asset(
//                                             'assets/images/Connector.png',
//                                             height: 35.h,
//                                           ),
//                                         ],
//                                       ),
//                                       title: Text('Choose Plan',
//                                           style: TextStyle(
//                                               fontSize: 18.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700)),
//                                       subtitle: Text(
//                                           'Choose a plan that`s right for you',
//                                           style: TextStyle(
//                                               fontSize: 16.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w400)),
//                                     ),
//                                     ListTile(
//                                       minLeadingWidth: 2.w,
//                                       leading: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 10.h,
//                                           ),
//                                           CircleAvatar(
//                                             child: pageNum == PageNum.third
//                                                 ? CircleAvatar(
//                                                     backgroundImage: AssetImage(
//                                                         'assets/images/Content.png'),
//                                                     radius: 5.r,
//                                                   )
//                                                 : null,
//                                             radius: 9.r,
//                                             backgroundColor: Colors.white,
//                                           ),
//                                           Image.asset(
//                                             'assets/images/Connector.png',
//                                             height: 35.h,
//                                           ),
//                                         ],
//                                       ),
//                                       title: Text('Checkout',
//                                           style: TextStyle(
//                                               fontSize: 18.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700)),
//                                       subtitle: Text('Payment Method & Data ',
//                                           style: TextStyle(
//                                               fontSize: 16.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w400)),
//                                     ),
//                                     ListTile(
//                                       minLeadingWidth: 2.w,
//                                       leading: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 10.h,
//                                           ),
//                                           CircleAvatar(
//                                             // child: CircleAvatar(
//                                             //   backgroundImage: AssetImage(
//                                             //       'assets/images/Content.png'),
//                                             //   radius: 5.r,
//                                             // ),
//                                             radius: 9.r,
//                                             backgroundColor: Colors.white,
//                                           )
//                                         ],
//                                       ),
//                                       title: Text('Purchase completed',
//                                           style: TextStyle(
//                                               fontSize: 18.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700)),
//                                       subtitle: Text(
//                                           'Enjoy the Power of Face26`s Photo Enhancer',
//                                           style: TextStyle(
//                                               fontSize: 16.sp,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w400)),
//                                     )
//                                   ],
//                                 ),
//                                 Align(
//                                   alignment: Alignment.bottomLeft,
//                                   child: pageNum == PageNum.second
//                                       ? Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             SizedBox(
//                                               height: 14.h,
//                                               width: 86.w,
//                                               child: Image.asset(
//                                                 'assets/images/slideRectangleBig.png',
//                                               ),
//                                             ),
//                                             SizedBox(width: 10.w),
//                                             SizedBox(
//                                               height: 14.h,
//                                               width: 14.w,
//                                               child: Image.asset(
//                                                 'assets/images/slideRectangleSmall.png',
//                                               ),
//                                             ),
//                                           ],
//                                         )
//                                       : Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             SizedBox(
//                                               height: 14.h,
//                                               width: 14.w,
//                                               child: Image.asset(
//                                                 'assets/images/slideRectangleSmall.png',
//                                               ),
//                                             ),
//                                             SizedBox(width: 10.w),
//                                             SizedBox(
//                                               height: 14.h,
//                                               width: 86.w,
//                                               child: Image.asset(
//                                                 'assets/images/slideRectangleBig.png',
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                 ),
//                               ],
//                             )),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(70.r, 55.r, 100.r, 48.r),
//                     color: Colors.white,
//                     child: Center(
//                       child: SizedBox(
//                         width: 556.w,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             pageNum == PageNum.first
//                                 ? SizedBox()
//                                 : Text('7 Day Free trial ',
//                                     style: TextStyle(
//                                         fontSize: 25.sp,
//                                         color: Color(0xff5118AA),
//                                         fontWeight: FontWeight.w900)),
//                             SizedBox(
//                               height: 9.h,
//                             ),
//                             pageNum == PageNum.first
//                                 ? SizedBox()
//                                 : Text('''Add Credit to use this App''',
//                                     style: TextStyle(
//                                         fontSize: 15.sp,
//                                         color: Color(0xff1A1A31),
//                                         fontWeight: FontWeight.w600)),
//                             SizedBox(
//                               height: 50.h,
//                             ),
//                             pageNum == PageNum.first
//                                 ? Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Try the face 26 Editor for free ',
//                                           style: TextStyle(
//                                               fontSize: 22.sp,
//                                               color: Color(0xff5118AA),
//                                               fontWeight: FontWeight.w900)),
//                                       SizedBox(
//                                         height: 9.h,
//                                       ),
//                                       Text(
//                                           '''Use our powerfull AI technology to transform every of your photo into a magical masterpieces. With only 1-Click you get the perfect results in seconds''',
//                                           style: TextStyle(
//                                               fontSize: 18.sp,
//                                               color: Color(0xff1A1A31),
//                                               fontWeight: FontWeight.w600)),
//                                       SizedBox(
//                                         height: 50.h,
//                                       ),
//                                       SizedBox(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             CustomListTileWhite(
//                                                 tile:
//                                                     'Photo Enhancer with HD Resolution'),
//                                             SizedBox(height: 10.h),
//                                             CustomListTileWhite(
//                                               tile:
//                                                   'Colorizer Black&White Photos',
//                                             ),
//                                             SizedBox(height: 10.h),
//                                             CustomListTileWhite(
//                                               tile: 'Access to all filters',
//                                             ),
//                                             SizedBox(height: 10.h),
//                                             CustomListTileWhite(
//                                               tile: 'No Watermarks',
//                                             ),
//                                             SizedBox(height: 10.h),
//                                             CustomListTileWhite(
//                                               tile: 'Never any ads',
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 60.h,
//                                         constraints: BoxConstraints(
//                                             minHeight: 50.h, maxHeight: 160.h),
//                                       ),
//                                       SizedBox(
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                                 '''Try now the magic of most powerfull AI Photo Enhancer''',
//                                                 style: TextStyle(
//                                                     fontSize: 20.sp,
//                                                     color: Color(0xff1A1A31),
//                                                     fontWeight:
//                                                         FontWeight.w500)),
//                                             SizedBox(
//                                               height: 65.h,
//                                             ),
//                                             Text(
//                                                 '''By continuing, you accept our Terms of Service and acknowledge receipt of our Privacy and Cookie Policy''',
//                                                 style: TextStyle(
//                                                     fontSize: 20.sp,
//                                                     color: Color(0xff1A1A31),
//                                                     fontWeight:
//                                                         FontWeight.w500)),
//                                             SizedBox(
//                                               height: 13.h,
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 : pageNum == PageNum.second
//                                     ? loading
//                                         ? Center(
//                                             child: CircularProgressIndicator())
//                                         : Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: List.generate(
//                                                 productListLength, (index) {
//                                               List<Product> products =
//                                                   widget.productData!.products;
//                                               return Transform.scale(
//                                                 scale: (clicked == index)
//                                                     ? 1.1
//                                                     : 1.0,
//                                                 child: Column(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 20.h,
//                                                     ),
//                                                     InkWell(
//                                                         onTap: () {
//                                                           print(
//                                                               'clicked$index');
//                                                           clicked = index;
//                                                           setState(() {});
//                                                         },
//                                                         child:
//                                                             SubscriptionOptionCard(
//                                                                 product:
//                                                                     products[
//                                                                         index])),
//                                                     SizedBox(
//                                                       height: 20.h,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             }))
//                                     : pageNum == PageNum.third
//                                         ? WhiteContainerContent2()
//                                         : SizedBox(),
//                             Expanded(child: SizedBox()),
//                             Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                 height: 70.h,
//                                 width: 500.w,
//                                 margin: EdgeInsets.all(5.0.r),
//                                 child: ElevatedButton(
//                                   onPressed: (() {
//                                     setState(() {
//                                       if (pageNum == PageNum.first) {
//                                         // loading = true;
//                                         // getProductInfoFunction();

//                                         pageNum = PageNum.second;
//                                       } else if (pageNum == PageNum.second) {
//                                         // getClientSecret();
//                                         pageNum = PageNum.third;
//                                       } else if (pageNum == PageNum.third) {}
//                                     });
//                                   }),
//                                   child: pageNum == PageNum.first
//                                       ? Text(
//                                           "Register now",
//                                           textAlign: TextAlign.center,
//                                         )
//                                       : pageNum == PageNum.second
//                                           ? Text("Go To Payment")
//                                           : pageNum == PageNum.third
//                                               ? Text("Start Free Trial")
//                                               : SizedBox(),
//                                   style: ButtonStyle(
//                                       shape: MaterialStateProperty.all(
//                                           RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(35.r),
//                                               side: BorderSide(
//                                                   color: Color(0xff0056d7),
//                                                   width: 1.5.w))),
//                                       padding: MaterialStateProperty.all(
//                                           EdgeInsets.symmetric(
//                                               // horizontal: 190.w,
//                                               //vertical: 40.h
//                                               )),
//                                       textStyle: MaterialStateProperty.all(
//                                           TextStyle(
//                                               fontSize: 20.sp,
//                                               fontWeight: FontWeight.w700)),
//                                       backgroundColor:
//                                           MaterialStateProperty.all(
//                                               const Color(0XFF5118AA)),
//                                       foregroundColor:
//                                           MaterialStateProperty.all(
//                                               Colors.white)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomListTileWhite extends StatelessWidget {
//   String tile;
//   CustomListTileWhite({Key? key, required this.tile}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(
//           Icons.check_circle_outline,
//           color: Color(0xff00DA8B),
//           size: 18,
//         ),
//         SizedBox(
//           width: 10.w,
//         ),
//         Text('$tile ',
//             style: TextStyle(
//                 fontSize: 18.sp,
//                 color: Color(0xff1a1a31),
//                 fontWeight: FontWeight.w900)),
//       ],
//     );
//   }
// }

// enum PageNum {
//   first,
//   second,
//   third,
// }

// class PaymentItem {
//   final String descrition;
//   final bool highlight;
//   final String? id;
//   final int? price;
//   final int? quantity;
//   final String? title;

//   const PaymentItem(
//       {this.descrition = '',
//       this.highlight = false,
//       this.id,
//       this.price,
//       this.quantity,
//       this.title});

//   Map<String, Object?> toMap() => {
//         'descrition': descrition,
//         'highlight': highlight,
//         'id': id,
//         'price': price,
//         'quantity': quantity,
//         'title': title,
//       };
// }
