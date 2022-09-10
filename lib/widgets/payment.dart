import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class Payments extends StatefulWidget {
  List<PaymentItem> paymentItem;
  Payments({Key? key, required this.paymentItem}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  // final _paymentItems = [
  //   PaymentItem(
  //     label: "ghj",
  //     amount: "99",
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];
  late List<PaymentItem> _paymentItems;
  assignValue() {
    _paymentItems = widget.paymentItem;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${widget.paymentItem.first.label}"),
          Text("Total amount : ${widget.paymentItem.first.amount}"),
          ApplePayButton(
            height: 50,
            width: 150,
            paymentConfigurationAsset: 'applepay.json',
            paymentItems: _paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: (data) {
              print(data);
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          GooglePayButton(
            height: 50,
            width: 150,
            paymentConfigurationAsset: 'gpay.json',
            paymentItems: _paymentItems,
            style: GooglePayButtonStyle.black,
            type: GooglePayButtonType.pay,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: (data) {
              print(data);
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

void onApplePayResult(paymentResult) {
  // Send the resulting Apple Pay token to your server / PSP
}

void onGooglePayResult(paymentResult) {
  // Send the resulting Google Pay token to your server / PSP
}
