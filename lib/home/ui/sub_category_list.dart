import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/bloc/schedule_cubit/schedule_cubit.dart';
import 'package:ticketing/home/bloc/schedule_cubit/schedule_state.dart';
import 'package:ticketing/home/bloc/single_event_bloc/single_event_bloc.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/constants.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/event_list_page.dart';
import 'package:ticketing/home/ui/single_sub_category_widget.dart';
import 'package:ticketing/purchase_tickets/ui/buy_tickets.dart';
import 'package:ticketing/purchase_tickets/ui/extras.dart';

class SubCategoryListPage extends StatelessWidget {
  static Route route(List<SubCategory> sub,
      {Category cat, bool isFeatured = false}) {
    return MaterialPageRoute(
      builder: (_) =>
          SubCategoryListPage(sub, category: cat, isFeatured: isFeatured),
    );
  }

  SubCategoryListPage(this.subCategories,
      {this.category, this.isFeatured = false});

  final List<SubCategory> subCategories;
  final Category category;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryBloc(HomeRepository())..add(LoadCategory(this.category)),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Cinema'),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: this.subCategories.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                final sub = this.subCategories[position];
                if (sub.schedule.length > 0) {
                  if (this.isFeatured) {
                    Event event = context.read<SingleEventBloc>().state.event;
                    bool hasType = this
                        .subCategories[position]
                        .schedule
                        .any((sch) => sch.id == event.id);
                    if (hasType) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: BlocProvider<ScheduleCubit>(
                          create: (_) => ScheduleCubit(),
                          child: BlocListener<ScheduleCubit, ScheduleState>(
                            listener: (context, state) {
                              if (state.selected != null) {
                                print(
                                    "SELECTED DATE - ${state.selected.millisecondsSinceEpoch}");
                                if (this.isFeatured) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (_) => SubCategoryBloc(
                                                HomeRepository())
                                              ..add(LoadSubCategory(sub)),
                                          ),
                                          BlocProvider(
                                            create: (_) => EventTypeCubit()
                                              ..changeType(EventType.movies),
                                          ),
                                          BlocProvider.value(
                                            value:
                                                context.read<SingleEventBloc>(),
                                          ),
                                          BlocProvider.value(
                                            value: context.read<TicketCubit>(),
                                          ),
                                        ],
                                        child: BlocBuilder<SingleEventBloc,
                                            SingleEventState>(
                                          builder: (context, state) {
                                            return BuyTickets(
                                              state.event,
                                              type: EventType.movies,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (_) => SubCategoryBloc(
                                                HomeRepository())
                                              ..add(LoadSubCategory(sub)),
                                          ),
                                          BlocProvider(
                                              create: (_) => EventTypeCubit()
                                                ..changeType(EventType.movies))
                                        ],
                                        child: EventListPage(
                                          this.category.title,
                                          category: this.category,
                                          byDate: state.selected,
                                          sub: sub,
                                        ),
                                      ),
                                    ),
                                  );
                              }
                            },
                            child: SingleSubCategory(
                              //subCategoryName: sub.name,
                              subCategory: sub,
                              category: category,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: BlocProvider<ScheduleCubit>(
                        create: (_) => ScheduleCubit(),
                        child: BlocListener<ScheduleCubit, ScheduleState>(
                          listener: (context, state) {
                            if (state.selected != null) {
                              if (this.isFeatured) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (_) =>
                                              SubCategoryBloc(HomeRepository())
                                                ..add(LoadSubCategory(sub)),
                                        ),
                                        BlocProvider(
                                          create: (_) => EventTypeCubit()
                                            ..changeType(EventType.movies),
                                        ),
                                        BlocProvider.value(
                                          value:
                                              context.read<SingleEventBloc>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<TicketCubit>(),
                                        ),
                                      ],
                                      child: BlocBuilder<SingleEventBloc,
                                          SingleEventState>(
                                        builder: (context, state) {
                                          return Extras(
                                            state.event,
                                            type: EventType.movies,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (_) =>
                                              SubCategoryBloc(HomeRepository())
                                                ..add(LoadSubCategory(sub)),
                                        ),
                                        BlocProvider(
                                            create: (_) => EventTypeCubit()
                                              ..changeType(EventType.movies))
                                      ],
                                      child: EventListPage(
                                        this.category.title,
                                        category: this.category,
                                        byDate: state.selected,
                                        sub: sub,
                                      ),
                                    ),
                                  ),
                                );
                            }
                          },
                          child: SingleSubCategory(
                            //subCategoryName: sub.name,
                            subCategory: sub,
                            category: category,
                          ),
                        ),
                      ),
                    );
                }
                return Container();
              },
            ),
          )),
    );
  }
}

class ItemsListPage extends StatelessWidget {
  static Route route(List<SubCategory> sub) {
    return MaterialPageRoute(builder: (_) => ItemsListPage(sub));
  }

  ItemsListPage(this.subCategories);

  final List<SubCategory> subCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cinema'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: this.subCategories.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, position) {
              final sub = this.subCategories[position];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: SingleItem(
                  subCategory: sub,
                ),
              );
            },
          ),
        ));
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (_, position) {
          return Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: EdgeInsets.all(8.0),
            ),
          );
        });
  }
}
