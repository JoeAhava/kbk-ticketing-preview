import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/models/ticket.dart';
import 'package:ticketing/purchase_tickets/ui/ticket_summary.dart';
import 'package:ticketing/utils.dart';

class Extras extends StatefulWidget {
  final Event event;
  final EventType type;

  Extras(this.event, {this.type = null});

  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  final GlobalKey scaffoldKey = GlobalKey();

  TextEditingController _txtctl;

  @override
  Widget build(BuildContext context) {
    print(context.read<TicketCubit>().state.type);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text($t(context, 'event.buy_ticket')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            this.widget.type == EventType.movies
                ? Expanded(
                    child: BlocBuilder<SubCategoryBloc, SubCategoryState>(
                      builder: (context, state) {
                        if (state is SubCategoryLoaded)
                          return ListView.builder(
                            itemCount:
                                state?.subCategory?.services?.length ?? 0,
                            itemBuilder: (context, position) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Stack(
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      elevation: 5.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: (state
                                                                    .subCategory
                                                                    .services[
                                                                        position]
                                                                    .imageUrl !=
                                                                null &&
                                                            (state
                                                                        .subCategory
                                                                        .services[
                                                                            position]
                                                                        .imageUrl
                                                                        ?.length ??
                                                                    0) !=
                                                                0)
                                                        ? Image.network(
                                                            state
                                                                .subCategory
                                                                .services[
                                                                    position]
                                                                .imageUrl,
                                                            width: 90,
                                                            height: 90,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            "assets/avatar.png",
                                                            width: 90,
                                                            height: 90,
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${state.subCategory.services[position].name[0].toUpperCase()}${state.subCategory.services[position].name.substring(1)}" ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          '${state.subCategory.services[position].price} ETB' ??
                                                              "0 ETB",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0XFFc2c9d2)),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          height: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.orange,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          // color: Colors.orange,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1.0, horizontal: 2.0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  color: Colors.orange,
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .minus_circle_fill,
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<TicketCubit>()
                                                        .decrementAdditionalAmount(
                                                          state.subCategory
                                                                  .services[
                                                              position],
                                                          1,
                                                        );
                                                    print(context
                                                        .read<TicketCubit>()
                                                        .state
                                                        .additionalCharge);
                                                  }),
                                              BlocBuilder<TicketCubit,
                                                  TicketState>(
                                                builder: (context, _state) {
                                                  return Text(
                                                    // "0",
                                                    "${(_state?.additionalCharge?.firstWhere((element) => (element?.containsKey(state?.subCategory?.services[position])), orElse: () => null)?.entries?.first?.value ?? 0).toString()}",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                  color: Colors.orange,
                                                  icon: Icon(
                                                    CupertinoIcons
                                                        .add_circled_solid,
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<TicketCubit>()
                                                        .incrementAdditionalAmount(
                                                          state.subCategory
                                                                  .services[
                                                              position],
                                                          1,
                                                        );
                                                    print(context
                                                        .read<TicketCubit>()
                                                        .state
                                                        .additionalCharge);
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        else if (state is SubCategoryFailed)
                          return Container(
                            child: Text('Error'),
                          );

                        return Container(child: Text('Loading'));
                      },
                    ),
                  )
                : SizedBox(
                    height: 1,
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        primary: Colors.lightBlue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          context.watch<TicketCubit>().state.type ==
                                  TicketType.waiting
                              ? $t(context, 'event.join_waiting')
                              : $t(context, 'event.book_ticket'),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      onPressed: () {
                        print(
                          context.read<TicketCubit>().state.type.toString() +
                              ' OnPressed',
                        );
                        if (context.read<TicketCubit>().state.type ==
                            TicketType.waiting) {
                          context.read<TicketCubit>().bookWaitingTicket();
                          if (context.read<TicketCubit>().state.networkStatus ==
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
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider<TicketCubit>.value(
                                value: BlocProvider.of<TicketCubit>(context),
                                child: TicketSummary(event: widget.event),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      child: Container(
        width: (MediaQuery.of(context).size.width / 3),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
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
                  children: [
                    Text(
                      service.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
      ),
    );
  }
}
