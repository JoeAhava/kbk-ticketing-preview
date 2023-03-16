import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/bloc/joined_event_bloc/joined_list_bloc.dart';
import 'package:ticketing/home/ui/joined_events_tab_item.dart';

class JoinedEventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoinedListBloc, JoinedEventListState>(
      builder: (context, state) {
        if (state is JoinedEventListLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return JoinedEventsTabItem(state.events[index]);
            },
          );
        } else if (state is JoinedEventListLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(
              'No events found !',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
