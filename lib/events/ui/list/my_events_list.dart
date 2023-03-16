import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/repo/events_repo.dart';
import 'package:ticketing/events/ui/list/bloc/my_events_cubit.dart';
import 'package:ticketing/events/ui/list/bloc/my_events_state.dart';
import 'package:ticketing/home/ui/widget_single_event.dart';
import 'package:ticketing/vo/resource.dart';

class MyEventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => MyEventsCubit(context.read<EventsRepo>()),
        child: BlocConsumer<MyEventsCubit, MyEventsState>(
          listener: (context, state) {
            if (state.eventsResource is Failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text((state.eventsResource as Failure).message)));
            }
          },
          builder: (context, state) {
            return state.eventsResource.when(
              success: (events) => RefreshIndicator(
                  child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (_, position) {
                        return SingleEventWidget(events[position]);
                      }),
                  onRefresh: () => _refresh(context)),
              loading: () => Center(
                child: Text('Loading ...'),
              ),
              error: (error) => Center(
                child: Text(error),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await context.read<MyEventsCubit>().getMyEvents();
    return Future.value(null);
  }

  // void _navigateToCreateEventPage(context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (_) => CreateEventTitle()));
  // }
}
