import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';
import 'package:ticketing/events/ui/create/create_event_paid_ticket.dart';

class CreateEventTicketType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: BlocBuilder<CreateEventCubit, CreateEventState>(
        builder: (context, state) {
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.all(10),
                children: [
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('What type of ticket do you want to sell?',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                  SizedBox(height: 10),
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Free Ticket',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      onTap: () {
                        context
                            .read<CreateEventCubit>()
                            .onTicketTypeChanged(TicketType.free);
                      },
                      leading: Radio(
                        value: 'free',
                        groupValue: state.ticketType == TicketType.free
                            ? 'free'
                            : 'paid',
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        context
                            .read<CreateEventCubit>()
                            .onTicketTypeChanged(TicketType.paid);
                      },
                      title: Text(
                        'Paid Ticket',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      leading: Radio(
                        value: 'paid',
                        groupValue: state.ticketType == TicketType.free
                            ? 'free'
                            : 'paid',
                      ),
                    ),
                  ),
                ],
              ),
              createEventPositionedNextButton(
                  context, _navigateToCreateEventTicket),
            ],
          );
        },
      ),
    );
  }

  void _navigateToCreateEventTicket(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventPaidTicket()));
  }
}
