import 'dart:core';
import 'package:flutter/material.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ticketing/purchase_tickets/Services/yenepay_services.dart';

class YenePayPayment extends StatefulWidget {
  final Function onFinish;
  final Event event;
  final int amount;
  final List<Map<String, dynamic>> extras;

  YenePayPayment(
      {@required this.onFinish,
      @required this.event,
      @required this.amount,
      this.extras = const []})
      : super();

  @override
  State<StatefulWidget> createState() {
    return YenePayPaymentState(
      event: this.event,
      amount: this.amount,
      extras: this.extras,
    );
  }
}

class YenePayPaymentState extends State<YenePayPayment> {
  final Event event;
  final int amount;
  final List<Map<String, dynamic>> extras;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String executeUrl = null;
  String process = "Cart";
  String merchantId = "SB1016";
  YenePayServices services = YenePayServices();
  YenePayPaymentState({
    this.event,
    this.amount,
    this.extras = const [],
  });
  // you can change default currency according to your need

  String successUrl = 'return.example.com';
  String cancelUrl = 'cancel.example.com';
  String checkoutUrl = null;
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        try {
          final payload = getOrderParams(this.extras);
          final res = await services.createYenePayPayment(payload);
          print(res);
          if (res != null) {
            print(res);
            setState(() {
              checkoutUrl = res["executeUrl"];
            });
          }
        } catch (e) {
          print(e);
          final snackBar = SnackBar(
            content: Text(e.toString()),
            duration: Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(_scaffoldKey.currentContext)
              .showSnackBar(snackBar);
        }
      },
    );
  }

  // item name, price and quantity

  Map<String, dynamic> getOrderParams(List<Map<String, dynamic>> extras) {
    print("Extras YENE");
    print(extras);
    // checkout invoice details
    Map<String, dynamic> temp = {
      "process": process ?? "Express",
      "merchantOrderId": "",
      "merchantId": merchantId ?? "",
      "items": [
        {
          "itemId": this?.event?.id ?? "",
          "itemName": this?.event?.title ?? "",
          "unitPrice": this?.event?.price ?? "",
          "quantity": this?.amount ?? "",
        },
        for (Map<String, dynamic> extra in extras) extra,
      ],
      "successUrl": successUrl,
      "cancelUrl": cancelUrl,
      "ipnUrl": "",
      "failureUrl": "",
      "expiresAfter": "",
      "expiresInDays": "",
      "totalItemsHandlingFee": "",
      "totalItemsDeliveryFee": "",
      "totalItemsDiscount": "",
      "totalItemsTax1": "",
      "totalItemsTax2": ""
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print('checkoutUrl');
    print(checkoutUrl);
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            print(request.url);
            if (request.url.contains(successUrl)) {
              print('SUCCESS - ${request.url.contains(successUrl)}');

              try {
                final uri = Uri.parse(request.url);
                if (uri.queryParameters['Status'] == 'Paid') {
                  widget.onFinish(uri.queryParameters['TransactionId']);
                  Navigator.of(context).pop();
                } else {
                  widget.onFinish(null, error: '');
                  Navigator.of(context).pop();
                }
              } on FormatException catch (e) {
                print(e);
                widget.onFinish(null, error: '');
                Navigator.of(context).pop();
              } catch (e) {
                widget.onFinish(null, error: '');
                Navigator.of(context).pop();
              }
            }
            if (request.url.contains(cancelUrl)) {
              Navigator.of(context).pop();
            }
            // request.url.contains(other)
            print('Out');
            return NavigationDecision.prevent;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
