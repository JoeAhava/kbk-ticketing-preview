import 'dart:core';
import 'package:flutter/material.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ticketing/purchase_tickets/Services/paypal_services.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final Event event;
  final int amount;
  final List<Map<Service, dynamic>> extras_raw;
  PaypalPayment(
      {@required this.onFinish,
      @required this.event,
      @required this.amount,
      this.extras_raw = const []})
      : super();

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState(
      event: this.event,
      amount: this.amount,
      extras_raw: this.extras_raw,
    );
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final Event event;
  final int amount;
  final List<Map<Service, int>> extras_raw;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  PaypalPaymentState({this.event, this.amount, this.extras_raw = const []});
  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () async {
        try {
          accessToken = await services.getAccessToken();

          final transactions = getOrderParams();
          final res =
              await services.createPaypalPayment(transactions, accessToken);
          if (res != null) {
            setState(() {
              checkoutUrl = res["approvalUrl"];
              executeUrl = res["executeUrl"];
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

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": '${this.event.title} ticket' ?? '',
        "quantity": this.amount ?? 0,
        "price": this.event.price ?? 0,
        "currency": defaultCurrency["currency"]
      }
    ];
    this.extras_raw.forEach(
          (extra) => extra.entries.forEach(
            (entry) {
              items.add(
                // Map.from(
                {
                  // "itemId": entry?.key?.id ?? "",
                  "name": entry?.key?.name ?? "",
                  "price": entry?.key?.price ?? "",
                  "quantity": entry.value ?? "",
                  "currency": defaultCurrency["currency"],
                },
                // ),
              );
            },
          ),
        );

    // checkout invoice details
    double priceTotal = 0;
    items.forEach((element) {
      priceTotal += (element["price"] * element["quantity"]);
      print("Total Calc : ${(element["price"] * element["quantity"])}");
    });
    String totalAmount = priceTotal.toString();
    print("Items - PayPal totalPrice : ${totalAmount}");
    print(items);
    String subTotalAmount = totalAmount;
    String shippingCost = 0.0.toString();
    int shippingDiscountCost = 0;
    String userFirstName = 'Anonymous';
    String userLastName = 'Anonymous';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName + " " + userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(executeUrl);

    if (executeUrl != null) {
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
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(Uri.parse(executeUrl), payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                }).catchError((Error e) {
                  widget.onFinish(null, error: e.toString());
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
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
