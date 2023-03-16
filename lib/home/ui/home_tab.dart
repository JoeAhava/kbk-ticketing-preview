import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/ui/sign_in_page.dart';
import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/home_bloc.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/constants.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/event_list_page.dart';
import 'package:ticketing/home/ui/single_event_page.dart';
import 'package:ticketing/home/ui/sub_category_list.dart';
import 'package:ticketing/utils.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            HomeRepository(),
          )..add(
              LoadHome(),
            ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state == AuthState.unauthenticated()) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Signed out')));

            Navigator.of(context)
                .pushAndRemoveUntil(SignInPage.route(), (route) => false);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadSuccess)
              return ListView.builder(
                  itemCount: state.data.categories.length + 2,
                  itemBuilder: (_, position) {
                    if (position == 0)
                      return BlocProvider(
                        create: (_) => SubCategoryBloc(HomeRepository()),
                        child: _MainSlider(state.data),
                      );
                    if (position == 1)
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        child: Text(
                          $t(context, 'home.browse_by_category'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: _SingleCategory(
                            category: state.data.categories[position - 2]));
                  });
            else if (state is HomeLoadFailed)
              return Container(child: Text(state.message));
            return Container(
                padding: EdgeInsets.only(top: 16), child: _Loading());
          },
        ),
      ),
    );
  }
}

class _MainSlider extends StatelessWidget {
  final HomeData _homeData;
  _MainSlider(this._homeData);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoadSuccess)
        return Container(
          height: 225,
          child: ListView.builder(
            itemCount: state.data.events.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, position) {
              return BlocProvider(
                create: (context) => CategoryBloc(HomeRepository())
                  ..add(
                    LoadCategory(
                      state.data.categories.firstWhere(
                        (element) =>
                            element ==
                            state.data.events[position].categories.firstWhere(
                              (cat) => element == cat,
                            ),
                      ),
                    ),
                  ),
                child: _SingleEvent(
                  event: state.data.events[position],
                  homeData: _homeData,
                ),
              );
            },
          ),
        );
      else if (state is HomeLoadFailed)
        return Container(
          child: Text('Hello World'),
        );

      return Container(child: Text('Loading'));
    });
  }
}

class _SingleCategory extends StatelessWidget {
  const _SingleCategory({this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.subCategories.isNotEmpty) {
          Navigator.of(context).push(
              SubCategoryListPage.route(category.subCategories, cat: category));
        } else {
          Navigator.of(context).push(
            EventListPage.route(
              category.title,
              category: category,
            ),
          );
        }
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black.withOpacity(0.5),
            image: category.imageUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(category.imageUrl))
                : null),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Text(
            "${category.title[0].toUpperCase()}${category.title.substring(1)}",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _SingleEvent extends StatelessWidget {
  _SingleEvent({this.event, this.homeData});

  final Event event;
  final HomeData homeData;
  final DateFormat formatter = DateFormat('LLL dd');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.homeData.categories.firstWhere(
              (category) => event.categories.any((cat) {
                print("CATEGORY -> ${category.title}");
                print("CAT -> ${cat}");
                print(cat
                    .toLowerCase()
                    .contains(RegExp(r'' + '${category.title}')));
                return cat.toLowerCase().contains(category.title);
              }),
              orElse: () => null, //.contains(element.title.toLowerCase()),
            );
        Navigator.of(context).push(
          SingleEventPage.route(
            event,
            isFeatured: true,
            category: this.homeData.categories.firstWhere(
                  (category) =>
                      event?.categories?.any(
                        (cat) => cat.toLowerCase().contains(category.title),
                      ) ??
                      null,
                  orElse: () => null, //.contains(element.title.toLowerCase()),
                ),
          ),
        );
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
                      image: event.imageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(event.imageUrl))
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
                        event.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      event.location?.name != null
                          ? Text(event.location.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey))
                          : SizedBox(height: 3),
                      SizedBox(height: 3),
                      event.eventStartDateTime != null
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                formatter.format(event.eventStartDateTime),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                            )
                          : SizedBox(height: 3),
                    ],
                  ),
                ))
              ],
            ),
          )),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.vertical,
        itemBuilder: (_, position) {
          if (position == 0)
            return Container(height: 220, child: _HorizontalLoading());
          if (position == 1)
            return Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                    width: 100.0,
                    height: 50.0,
                    margin: EdgeInsets.all(16),
                    color: Colors.grey.withOpacity(0.4)));
          return Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: EdgeInsets.all(16),
            ),
          );
        });
  }
}

class _HorizontalLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, position) {
          return Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: Container(
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: EdgeInsets.all(16),
            ),
          );
        });
  }
}
