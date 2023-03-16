import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/bloc/favorite_event_bloc/fav_list_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/ui/favorite_events_tab_item.dart';

class FavoriteEventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FavListBloc(HomeRepository())..add(LoadFavEventList()),
        child: BlocBuilder<FavListBloc, FavEventListState>(
          builder: (context, state) {
            print(state);
            if (state is FavEventListLoaded) {
              return ListView.builder(
                itemCount: state.events.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return FavoriteEventsTabItem(state.events[index]);
                },
              );
            } else if (state is FavEventListLoading) {
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
        ));
  }
}
