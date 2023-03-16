import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/bloc/waiting_event_bloc/waiting_list_bloc.dart';
import 'package:ticketing/home/ui/waiting_events_tab_item.dart';

class WaitingEventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaitingListBloc, WaitingEventListState>(
      builder: (context, state) {
        if (state is WaitingEventListLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return WaitingEventsTabItem(state.events[index]);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
