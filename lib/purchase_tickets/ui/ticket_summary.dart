import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/purchase_tickets/Services/CustomCardClipper.dart';
import 'package:ticketing/purchase_tickets/ui/payment_platform.dart';
import 'package:ticketing/purchase_tickets/ui/separator.dart';
import 'package:ticketing/utils.dart';

class TicketSummary extends StatefulWidget {
  final Event event;
  final int amount;
  final double additionalCharge;
  final String order_id;

  TicketSummary(
      {this.event,
      this.order_id = null,
      this.amount = 0,
      this.additionalCharge = 0});

  @override
  _TicketSummaryState createState() => _TicketSummaryState();
}

class _TicketSummaryState extends State<TicketSummary> {
  final GlobalKey _scaffoldKey = GlobalKey();
  double total = 0;
  @override
  Widget build(BuildContext context) {
    if (this.total == 0) {
      context.read<TicketCubit>().state.additionalCharge.forEach((element) {
        this.setState(() {
          total +=
              (element.entries.first.key.price * element.entries.first.value);
        });
      });
      print("TOTAL : ${this.total}");
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text($t(context, 'event.ticket_summary')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                child: ClipPath(
                  clipper: CustomCardClipper(),
                  child: Card(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.lightBlue,
                                ),
                                child: (FirebaseAuth.instance.currentUser
                                                ?.photoURL ??
                                            null) !=
                                        null
                                    ? Image.network(
                                        FirebaseAuth
                                            .instance.currentUser?.photoURL,
                                        width: 90,
                                        height: 90,
                                      )
                                    : Image.asset(
                                        "assets/avatar.png",
                                        width: 90,
                                        height: 90,
                                      ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      this.widget.event?.title ?? "--",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      this.widget.event?.description ?? "--",
                                      style:
                                          TextStyle(color: Color(0XFFc2c9d2)),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      this.widget.event?.location?.name ?? "--",
                                      style:
                                          TextStyle(color: Color(0XFFc2c9d2)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    $t(context, 'event.starts'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 220,
                                    child: Wrap(children: [
                                      Text(
                                        '${DateFormat.yMMMMEEEEd().add_jm().format(widget.event.eventStartDateTime).toString()}' ??
                                            "-",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    $t(context, 'event.ends'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 220,
                                    child: Wrap(children: [
                                      Text(
                                        '${DateFormat.yMMMMEEEEd().add_jm().format(widget.event.eventEndDateTime).toString()}' ??
                                            "-",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 0.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    $t(context, 'event.location'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.event.location.name ?? "",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Container(
                            width: 400,
                            child: MySeparator(width: 5, color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                $t(context, 'event.ticket_summary'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Container(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    $t(context, 'event.ticket_amount'),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '${(this?.widget.amount ?? 0) > 0 ? (this?.widget.amount ?? 0) : BlocProvider.of<TicketCubit>(context, listen: true).state.amount}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Container(
                                height: 3,
                              ),
                              Container(
                                  width: 400,
                                  child: MySeparator(
                                      width: 5.0, color: Colors.grey)),
                              Container(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    $t(context, 'event.ticket_price'),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    widget.event.price.toString() ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: 3,
                              ),
                              Container(
                                  width: 400,
                                  child: MySeparator(
                                      width: 5.0, color: Colors.grey)),
                              Container(
                                height: 10,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       $t(context, 'event.additional_charge'),
                              //       style: TextStyle(color: Colors.grey),
                              //     ),
                              //     Text(
                              //       "${this.additionalCharge > 0 ? this.additionalCharge : '-'}",
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.red),
                              //     )
                              //   ],
                              // ),
                              for (var item in context
                                  .read<TicketCubit>()
                                  .state
                                  .additionalCharge)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.entries.first.key.name[0].toUpperCase()}${item.entries.first.key.name.substring(1)}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      "${item.entries.first.key.price > 0 ? (item.entries.first.key.price * (item.entries.first.value)) : '-'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    )
                                  ],
                                ),
                              Container(
                                height: 3,
                              ),
                              Container(
                                  width: 400,
                                  child: MySeparator(
                                      width: 5.0, color: Colors.grey)),
                              Container(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    $t(context, 'event.total'),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    (((widget.event.price ?? 0) *
                                                    ((this.widget.amount > 0
                                                            ? this.widget.amount
                                                            : BlocProvider.of<
                                                                        TicketCubit>(
                                                                    context,
                                                                    listen:
                                                                        true)
                                                                .state
                                                                .amount) ??
                                                        0)) +
                                                (this.total ?? 0))
                                            .toString() ??
                                        "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 2.0),
                child: Row(
                  children: [
                    Expanded(
                      child: this.widget.order_id == null
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                primary: Colors.lightBlue,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  $t(context, 'event.make_payment'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BlocProvider<TicketCubit>.value(
                                      value:
                                          BlocProvider.of<TicketCubit>(context),
                                      child: PaymentPlatform(
                                        event: widget.event,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              this.widget.order_id != null
                  ? Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: QrImage(
                          data:
                              '${this.widget.order_id} ${FirebaseAuth.instance.currentUser.uid}',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
