import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ticketing/auth/bloc/auth/auth_bloc.dart';
import 'package:ticketing/auth/repo/auth_repo.dart';
import 'package:ticketing/home/ui/edit_profile.dart';
import 'package:ticketing/home/ui/events_tab.dart';
import 'package:ticketing/home/ui/favorite_events_tab.dart';
import 'package:ticketing/home/ui/home_tab.dart';
import 'package:ticketing/home/ui/language.dart';
import 'package:ticketing/home/ui/my_profile_tab.dart';
import 'package:ticketing/notifications/ui/notifications.dart';
import 'package:ticketing/payment_history/ui/payment_history.dart';
import 'package:ticketing/search/ui/search_page.dart';
import 'package:ticketing/settings/ui/settings_list.dart';
import 'package:ticketing/utils.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => HomePage(),
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> listOfViews = [
    HomeTab(),
    EventsTab(),
    FavoriteEventsTab(),
    MyProfileTab()
  ];

  final List<Widget> listOfAppBars = [
    HomeTab(),
    EventsTab(),
    FavoriteEventsTab(),
    MyProfileTab()
  ];

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: Scaffold(
          drawer: _MainDrawer(),
          appBar: _appBar(context, pageIndex),
          bottomNavigationBar: _bottomNavigationBar(context),
          body: listOfViews[pageIndex],
        ),
    );
  }

  _appBar(context, index) {
    if (index == 0) {
      return AppBar(
        centerTitle: true,
        title: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text($t(context, 'home.app_name'),
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Icon(
              //     Icons.keyboard_arrow_down,
              //     color: Colors.white,
              //   ),
              // )
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).push<void>(SearchPage.route()),
          ),
        ],
      );
    } else if (index == 1) {
      return AppBar(
        title: Text($t(context, 'events.appbar'),
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
      );
    } else if (index == 2) {
      return AppBar(
        title: Text($t(context, 'favorite.appbar'),
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
      );
    } else if (index == 3) {
      return AppBar(
        title: Text($t(context, 'account.appbar'),
            style: TextStyle(fontSize: 18, color: Colors.white)),
        centerTitle: true,
      );
    }
  }

  BottomNavigationBar _bottomNavigationBar(context) => BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.calendar_today),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.favorite_border),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.person_outline),
          ),
        ],
      );
}

class _MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: [
          DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4fabf6), Color(0XFF6dc2e7)],
                        stops: [0.4, 1],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       context.read<AuthBloc>().state.user.photo == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/avatar.png",
                                    ),
                                    radius: 40,
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      context.read<AuthBloc>().state.user.photo,
                                    ),
                                    radius: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 7,
                              ),
                              Text(
                                "${context.read<AuthBloc>().state.user.name ?? context.read<AuthBloc>().state.user.email.split("@")[0]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                "${context.read<AuthBloc>().state.user.email}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(EditProfile.route());
                                    },
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.language),
              title: Text($t(context, 'navigator.select_language')),
              onTap: () {
                Navigator.of(context).push(Language.route());
              },
            ),
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          //   child: ListTile(
          //     leading: FaIcon(FontAwesomeIcons.solidFileAlt),
          //     title: Text($t(context, 'navigator.payment_history')),
          //     onTap: () {
          //       Navigator.of(context).push(PaymentHistory.route());
          //     },
          //   ),
          // ),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          //   child: ListTile(
          //     leading: Icon(Icons.notifications),
          //     title: Text($t(context, 'navigator.notifications')),
          //     onTap: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (_) => Notifications()));
          //     },
          //   ),
          // ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text($t(context, 'navigator.settings')),
              onTap: () {
                //add routes to navigate
                Navigator.of(context).push(SettingsList.route());
              },
            ),
          ),
           Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: ListTile(
              leading: Icon(Icons.info_sharp),
              title: Text($t(context, 'account.about')),
              onTap: () {
                //add routes to navigate
                // Navigator.of(context).push(SettingsList.route());
              },
            ),
          ),
        ],
      ),
    );
  }
}
