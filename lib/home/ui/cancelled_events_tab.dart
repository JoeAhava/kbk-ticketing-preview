import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/bloc/cancelled_event_bloc/cancelled_list_bloc.dart';
import 'package:ticketing/home/ui/cancelled_events_tab_item.dart';

class CancelledEventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CancelledListBloc, CancelledEventListState>(
      builder: (context, state) {
        if (state is CancelledEventListLoaded) {
          return ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (BuildContext context, int index) {
              return CancelledEventsTabItem(state.events[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
