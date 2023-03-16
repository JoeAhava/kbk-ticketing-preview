import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/cubit/language_cubit.dart';
import 'package:ticketing/home/bloc/cancelled_event_bloc/cancelled_list_bloc.dart';
import 'package:ticketing/home/bloc/joined_event_bloc/joined_list_bloc.dart';
import 'package:ticketing/home/bloc/waiting_event_bloc/waiting_list_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/ui/cancelled_events_tab.dart';
import 'package:ticketing/home/ui/joined_events_tab.dart';
import 'package:ticketing/home/ui/waiting_events_tab.dart';
import 'package:ticketing/utils.dart';

class EventsTab extends StatefulWidget {
  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  TabBar _tabBar = TabBar(
    unselectedLabelColor: Colors.black,
    labelColor: Colors.white,
    indicator: BoxDecoration(
        color: Colors.lightBlue, borderRadius: BorderRadius.circular(8)),
    tabs: [
      BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return Tab(
            text: $t(context, 'events.joined'),
          );
        },
      ),
      BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return Tab(
            text: $t(context, 'events.waiting'),
          );
        },
      ),
      BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return Tab(
            text: $t(context, 'events.cancelled'),
          );
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                WaitingListBloc(HomeRepository())..add(LoadWaitingEventList())),
        BlocProvider(
            create: (_) =>
                JoinedListBloc(HomeRepository())..add(LoadJoinedEventList())),
        BlocProvider(
            create: (_) => CancelledListBloc(HomeRepository())
              ..add(LoadCancelledEventList()))
      ],
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.all(24.0), child: _tabBar),
            Container(
              height: MediaQuery.of(context).size.height -
                  (kBottomNavigationBarHeight +
                      kToolbarHeight +
                      MediaQuery.of(context).padding.bottom +
                      MediaQuery.of(context).padding.top +
                      AppBar().preferredSize.height +
                      _tabBar.preferredSize.height +
                      24),
              child: TabBarView(
                children: [
                  BlocBuilder<JoinedListBloc, JoinedEventListState>(
                    builder: (context, state) {
                      context.read<JoinedListBloc>()
                        ..add(LoadJoinedEventList());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocProvider.value(
                          value: context.read<JoinedListBloc>(),
                          child: JoinedEventsTab(),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<WaitingListBloc, WaitingEventListState>(
                    builder: (context, state) {
                      context.read<WaitingListBloc>()
                        ..add(LoadWaitingEventList());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocProvider.value(
                          value: context.read<WaitingListBloc>(),
                          child: WaitingEventsTab(),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<CancelledListBloc, CancelledEventListState>(
                    builder: (context, state) {
                      context.read<CancelledListBloc>()
                        ..add(LoadCancelledEventList());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocProvider.value(
                          value: context.read<CancelledListBloc>(),
                          child: CancelledEventsTab(),
                        ),
                      );
                    },
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
