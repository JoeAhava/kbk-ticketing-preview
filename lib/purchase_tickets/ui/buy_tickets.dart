import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/models/ticket.dart';
import 'package:ticketing/purchase_tickets/ui/extras.dart';
import 'package:ticketing/purchase_tickets/ui/ticket_summary.dart';
import 'package:ticketing/utils.dart';

class BuyTickets extends StatelessWidget {
  final Event event;
  final EventType type;
  final bool isFeatured;
  final GlobalKey scaffoldKey = GlobalKey();
  final Function onBooking;
  BuyTickets(this.event,
      {this.type = null, this.isFeatured = false, this.onBooking = null});
  @override
  Widget build(BuildContext context) {
    print(context.read<TicketCubit>().state.type);
    // if (context.watch<TicketCubit>().state.networkStatus ==
    //     TicketNetworkStatus.created) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Booking was successful!',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Colors.lightGreen,
    //     ),
    //   );
    //   Navigator.of(context).pop();
    // }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text($t(context, 'event.buy_ticket')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 40,
                    ),
                    context.watch<AuthBloc>().state.user.photo != null
                        ? Image.network(
                            context.watch<AuthBloc>().state.user.photo,
                            height: 200,
                            width: 200,
                          )
                        : Image.asset(
                            "assets/avatar.png",
                            height: 200,
                            width: 200,
                          ),
                    Container(
                      height: 40,
                    ),
                    Text(
                      $t(context, 'event.ticket_amount_message'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    Container(
                      height: 40,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () =>
                                context.read<TicketCubit>().changeAmount(1),
                            style: TextButton.styleFrom(
                              backgroundColor: BlocProvider.of<TicketCubit>(
                                        context,
                                        listen: true,
                                      ).state.amount ==
                                      1
                                  ? Colors.lightBlue
                                  : Colors.transparent,
                              shape: CircleBorder(),
                              side: BorderSide(
                                color: Colors.lightBlue,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "1",
                              style: TextStyle(
                                color: BlocProvider.of<TicketCubit>(context,
                                                listen: true)
                                            .state
                                            .amount ==
                                        1
                                    ? Colors.white
                                    : Colors.lightBlue,
                              ),
                            ),
                          ),
                          if (context.read<TicketCubit>().state.amount >= 2)
                            TextButton(
                              onPressed: () =>
                                  context.read<TicketCubit>().changeAmount(2),
                              style: TextButton.styleFrom(
                                backgroundColor: BlocProvider.of<TicketCubit>(
                                                context,
                                                listen: true)
                                            .state
                                            .amount ==
                                        2
                                    ? Colors.lightBlue
                                    : Colors.transparent,
                                shape: CircleBorder(),
                                side: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "2",
                                style: TextStyle(
                                  color: BlocProvider.of<TicketCubit>(context,
                                                  listen: true)
                                              .state
                                              .amount ==
                                          2
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ),
                            ),
                          if (context.read<TicketCubit>().state.amount >= 3)
                            TextButton(
                              onPressed: () =>
                                  context.read<TicketCubit>().changeAmount(3),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    context.watch<TicketCubit>().state.amount ==
                                            3
                                        ? Colors.lightBlue
                                        : Colors.transparent,
                                shape: CircleBorder(),
                                side: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "3",
                                style: TextStyle(
                                  color: context
                                              .watch<TicketCubit>()
                                              .state
                                              .amount ==
                                          3
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ),
                            ),
                          if (context.read<TicketCubit>().state.amount >= 4)
                            TextButton(
                              onPressed: () =>
                                  context.read<TicketCubit>().changeAmount(4),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    context.watch<TicketCubit>().state.amount ==
                                            4
                                        ? Colors.lightBlue
                                        : Colors.transparent,
                                shape: CircleBorder(),
                                side: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "4",
                                style: TextStyle(
                                  color: context
                                              .watch<TicketCubit>()
                                              .state
                                              .amount ==
                                          4
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ),
                            ),
                          if (context.read<TicketCubit>().state.amount >= 5)
                            TextButton(
                              onPressed: () =>
                                  context.read<TicketCubit>().changeAmount(5),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    context.watch<TicketCubit>().state.amount ==
                                            5
                                        ? Colors.lightBlue
                                        : Colors.transparent,
                                shape: CircleBorder(),
                                side: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "5",
                                style: TextStyle(
                                  color: context
                                              .watch<TicketCubit>()
                                              .state
                                              .amount ==
                                          5
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ),
                            ),
                          if (context.read<TicketCubit>().state.amount >= 6)
                            TextButton(
                              onPressed: () =>
                                  context.read<TicketCubit>().changeAmount(6),
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    context.watch<TicketCubit>().state.amount ==
                                            6
                                        ? Colors.lightBlue
                                        : Colors.transparent,
                                shape: CircleBorder(),
                                side: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "6",
                                style: TextStyle(
                                  color: context
                                              .watch<TicketCubit>()
                                              .state
                                              .amount ==
                                          6
                                      ? Colors.white
                                      : Colors.lightBlue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocListener<TicketCubit, TicketState>(
                              listener: (context, state) {
                                print(state);
                                if (state.networkStatus ==
                                    TicketNetworkStatus.created) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Booking was successful!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.lightGreen,
                                    ),
                                  );
                                  this?.onBooking();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  primary: Colors.lightBlue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    _getButtonText(context),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                onPressed: () {
                                  if (context.read<TicketCubit>().state.type ==
                                      TicketType.waiting) {
                                    context
                                        .read<TicketCubit>()
                                        .bookWaitingTicket();
                                    print(context.read<TicketCubit>().state);
                                  } else {
                                    if (this.type == EventType.movies) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider<
                                              SubCategoryBloc>.value(
                                            value:
                                                context.read<SubCategoryBloc>(),
                                            child:
                                                BlocProvider<TicketCubit>.value(
                                              value:
                                                  BlocProvider.of<TicketCubit>(
                                                      context),
                                              child: Extras(
                                                event,
                                                type: this.type ?? null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              BlocProvider<TicketCubit>.value(
                                            value: BlocProvider.of<TicketCubit>(
                                                context),
                                            child: TicketSummary(event: event),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getButtonText(BuildContext context) {
    switch (context.watch<TicketCubit>().state.type) {
      case TicketType.joined:
        return $t(context, 'event.book_ticket');
      case TicketType.waiting:
        return $t(context, 'event.join_waiting');
      default:
        return 'Next';
    }
  }
}

class _SingleEvent extends StatelessWidget {
  _SingleEvent({this.service});

  final Service service;

  // final DateFormat formatter = DateFormat('LLL dd');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(
          'SERVICE ${this.service.name} - PRICE ${this.service.price}',
        );
        print(
          'TICKET AMOUNT ${context.read<TicketCubit>().state.amount}',
        );
        context.read<TicketCubit>().changeAdditional({this.service: 1});
        // Navigator.of(context).push(SingleservicePage.route(service));
      },
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      image: service.imageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(service.imageUrl))
                          : null),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 3),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "${service.price.toString()} ETB",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
