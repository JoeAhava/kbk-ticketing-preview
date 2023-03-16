import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticketing/cubit/ticket_cubit.dart';
import 'package:ticketing/home/bloc/cancelled_event_bloc/cancelled_list_bloc.dart';
// import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
// import 'package:ticketing/home/bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/bloc/joined_event_bloc/joined_list_bloc.dart';
// import 'package:ticketing/home/bloc/home_bloc.dart';
import 'package:ticketing/home/bloc/single_event_bloc/single_event_bloc.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/bloc/waiting_event_bloc/waiting_list_bloc.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/sub_category_list.dart';
import 'package:ticketing/purchase_tickets/repo/tickets_repo.dart';
import 'package:ticketing/purchase_tickets/ui/buy_tickets.dart';
import 'package:ticketing/purchase_tickets/ui/ticket_summary.dart';
import 'package:ticketing/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SingleEventPage extends StatefulWidget {
  static Route route(
    Event event, {
    EventType type = null,
    bool isFeatured = false,
    Category category = null,
  }) {
    YoutubePlayerController _controller = null;
    if (type == EventType.movies) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(event.trailer),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    }
    return MaterialPageRoute(
        builder: (_) => SingleEventPage(
              event: event,
              controller: _controller,
              isFeatured: isFeatured,
              category: category,
            ));
  }

  SingleEventPage({
    @required this.event,
    this.status = EventStatus.NONE,
    this.type = null,
    this.controller,
    this.isFeatured = false,
    this.category = null,
  });

  final Event event;
  final EventStatus status;
  final EventType type;
  final bool isFeatured;
  final Category category;
  final YoutubePlayerController controller;

  @override
  _SingleEventPageState createState() => _SingleEventPageState();
}

class _SingleEventPageState extends State<SingleEventPage> {
  final GlobalKey scaffoldKey = new GlobalKey();

  YoutubePlayerController _controller = null;
  ScrollController _scrollController = null;
  bool showVideo;
  final TicketsRepo _ticketsRepo = new TicketsRepo();

  final DateFormat formatter = DateFormat('EEEE, LLL dd, y @ HH:mm');

  @override
  Widget build(BuildContext context) {
    if (this._scrollController == null) {
      this.setState(() {
        _scrollController =
            ScrollController(initialScrollOffset: 0, keepScrollOffset: false);
      });
    }
    if (this.widget.event.trailer != null) {
      if (this._controller == null) {
        this.setState(
          () {
            showVideo = false;
          },
        );
        this.setState(
          () {
            _controller = YoutubePlayerController(
              initialVideoId:
                  YoutubePlayer.convertUrlToId(this.widget.event.trailer),
              flags: YoutubePlayerFlags(
                autoPlay: true,
                // mute: true,
              ),
            );
            print("Controller - ${this.widget.controller}");
          },
        );
      }
    } else {
      this.setState(() {
        showVideo = false;
      });
    }

    print("TRAILER - ${this.widget.event.trailer}");
    print("Controller - ${this._controller}");

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TicketCubit(_ticketsRepo, event_id: widget.event.id),
        ),
        BlocProvider(
          create: (_) => SingleEventBloc(HomeRepository(), widget.event)
            ..add(CheckStatus()),
        ),
      ],
      child: BlocListener<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state.networkStatus == TicketNetworkStatus.created) {
            {
              try {
                context.read<WaitingListBloc>().add(LoadWaitingEventList());
                context.read<CancelledListBloc>().add(LoadCancelledEventList());
                context.read<JoinedListBloc>().add(LoadJoinedEventList());
              } catch (e) {
                print(e);
                // throw e;
              }
            }
          }
        },
        child: BlocBuilder<TicketCubit, TicketState>(
          //
          builder: (context, state) {
            if (this.widget.type == EventType.movies) {
              this
                  ._controller
                  .fitHeight(Size(MediaQuery.of(context).size.width, 300));
            }
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: widget.event.imageUrl != null
                          ? DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(widget.event.imageUrl))
                          : null,
                    ),
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [Colors.black12, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    controller: this._scrollController,
                    scrollDirection: Axis.vertical,
                    children: [
                      this.widget.event?.trailer != null
                          ? !this.showVideo
                              ? Center(
                                  heightFactor: 3.5,
                                  child: Container(
                                    // foregroundDecoration: BoxDecoration(),
                                    color: Colors.black38,
                                    // padding: const EdgeInsets.only(top: 15.0),
                                    child: IconButton(
                                      constraints: BoxConstraints.tightFor(
                                          width: 50, height: 50),
                                      color: Colors.white,
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () {
                                        this._controller.play();
                                        this.setState(() {
                                          showVideo = !showVideo;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(height: 200),
                      SizedBox(height: !this.showVideo ? 0 : 300),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 150,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${widget.event.title[0].toUpperCase()}${widget.event.title.substring(1)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21)),
                                Row(
                                  children: [
                                    BlocBuilder<SingleEventBloc,
                                        SingleEventState>(
                                      buildWhen: (prev, state) =>
                                          prev is SingleEventChecking,
                                      builder: (ctx, state) {
                                        if (state is SingleEventLoaded) {
                                          print("fav check");
                                          print(state.favorite);
                                          // bool fav = state.favorite;
                                          return IconButton(
                                            onPressed: () {
                                              BlocProvider.of<SingleEventBloc>(
                                                      context)
                                                  .add(ToggleFav(
                                                      !state.favorite));
                                            },
                                            icon: Icon(
                                              state.favorite
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                            ),
                                          );
                                        }
                                        return Shimmer(
                                          child: CircleAvatar(
                                            maxRadius: 15,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.black12,
                                              Colors.transparent
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${widget.event?.organizer?.name[0].toUpperCase() ?? ''}${widget.event?.organizer?.name?.substring(1) ?? ''}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.event.price} ETB',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                widget.event.amount != null
                                    ? Text(
                                        widget.event.amount >= 1
                                            ? '${widget.event.amount} tickets left'
                                            : 'Sold out',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.event.amount >= 1
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).errorColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.event.description,
                              style: TextStyle(
                                height: 1.3,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(FontAwesomeIcons.calendar),
                                SizedBox(width: 25),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      $t(context, 'event.starts'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formatter.format(
                                          widget.event.eventStartDateTime),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      $t(context, 'event.ends'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formatter.format(
                                          widget.event.eventEndDateTime),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      $t(context, 'event.type'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Movie',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                /*FlatButton(
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                  ),*/
                              ],
                            ),
                            SizedBox(height: 20),
                            Text($t(context, 'event.organizer_detail'),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Image.network(
                                      'https://www.shareicon.net/data/512x512/2016/08/05/806962_user_512x512.png'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                    "${widget.event?.organizer?.name[0].toUpperCase() ?? ''}${widget.event?.organizer?.name?.substring(1) ?? ''}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              widget.event.organizer?.description?.substring(
                                  0,
                                  min(
                                      widget.event.organizer?.description
                                              ?.length ??
                                          0,
                                      200)),
                              style: TextStyle(
                                height: 1.3,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text($t(context, 'event.connect_with'),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                  children: [
                                    _SocialIcon(FontAwesomeIcons.facebookF,
                                        widget.event.organizer?.facebook),
                                    SizedBox(width: 10),
                                    _SocialIcon(FontAwesomeIcons.twitter,
                                        widget.event.organizer?.twitter),
                                    SizedBox(width: 10),
                                    _SocialIcon(FontAwesomeIcons.solidEnvelope,
                                        widget.event.organizer?.email),
                                    SizedBox(width: 10),
                                    _SocialIcon(FontAwesomeIcons.phoneAlt,
                                        "tel://${widget.event.organizer?.phone}"),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 30,
                            ),
                            BlocBuilder<SingleEventBloc, SingleEventState>(
                              builder: (ctx, state) {
                                if (state is SingleEventLoaded) {
                                  if (state.ticketType == TicketType.none ||
                                      state.ticketType == null) {
                                    print("ticket type : ${state.ticketType}");
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                context
                                                                .watch<
                                                                    SingleEventBloc>()
                                                                .state
                                                                .event
                                                                .amount !=
                                                            null &&
                                                        context
                                                                .watch<
                                                                    SingleEventBloc>()
                                                                .state
                                                                .event
                                                                .amount >=
                                                            1
                                                    ? $t(context,
                                                        'event.book_ticket')
                                                    : $t(context,
                                                        'event.join_waiting'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              print(this.widget.category);
                                              if (this.widget.isFeatured &&
                                                  this
                                                      .widget
                                                      .event
                                                      .categories
                                                      .any((cat) => cat
                                                          .toLowerCase()
                                                          .contains(
                                                              "movies"))) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider.value(
                                                          value: context.read<
                                                              SingleEventBloc>(),
                                                        ),
                                                        BlocProvider.value(
                                                          value: context.read<
                                                              TicketCubit>(),
                                                        )
                                                      ],
                                                      child:
                                                          SubCategoryListPage(
                                                        this
                                                            .widget
                                                            .category
                                                            .subCategories,
                                                        category: this
                                                            .widget
                                                            .category,
                                                        isFeatured: true,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        MultiBlocProvider(
                                                      providers: [
                                                        BlocProvider(
                                                          create: (_) =>
                                                              TicketCubit(
                                                            TicketsRepo(),
                                                            event_id:
                                                                widget.event.id,
                                                            type: (widget
                                                                            .event
                                                                            ?.amount ??
                                                                        0) >=
                                                                    1
                                                                ? TicketType
                                                                    .joined
                                                                : TicketType
                                                                    .waiting,
                                                          ),
                                                        ),
                                                        if (this.widget.type ==
                                                            EventType.movies)
                                                          BlocProvider.value(
                                                            value: context.read<
                                                                SubCategoryBloc>(),
                                                          )
                                                      ],
                                                      child: BuyTickets(
                                                        widget.event,
                                                        type: this.widget.type,
                                                        isFeatured: this
                                                            .widget
                                                            .isFeatured,
                                                        onBooking: () =>
                                                            context.read<
                                                                SingleEventBloc>()
                                                              ..add(
                                                                  CheckStatus()),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (state.ticketType ==
                                      TicketType.joined) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            onPressed: () {
                                              // print(
                                              //     'state - order -id ${state.order_id}');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => BlocProvider<
                                                      TicketCubit>.value(
                                                    value: BlocProvider.of<
                                                        TicketCubit>(context),
                                                    child: TicketSummary(
                                                      event: widget.event,
                                                      order_id: state.order_id,
                                                      amount: state.amount,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Center(
                                              child: Text('Ticket Summary'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  this.showVideo
                      ? Positioned(
                          // top: 20,
                          child: Container(
                            height: 300,
                            child: YoutubePlayer(
                              aspectRatio: 4 / 3,
                              bottomActions: [
                                // PlayPauseButton(
                                //   controller: this._controller,
                                // ),
                                ProgressBar(
                                  controller: this._controller,
                                  isExpanded: true,
                                ),
                              ],
                              controller: this._controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.amber,
                              progressColors: ProgressBarColors(
                                playedColor: Colors.amber,
                                handleColor: Colors.amberAccent,
                              ),
                              onReady: () {
                                this?.widget?.controller?.addListener(() {
                                  print("Listener ...");
                                });
                              },
                            ),
                          ),
                        )
                      : Container(),
                  this.widget.event?.trailer != null
                      ? this.showVideo
                          ? Positioned(
                              right: 0,
                              child: Container(
                                color: Colors.black38,
                                padding: const EdgeInsets.only(top: 15.0),
                                child: IconButton(
                                  constraints: BoxConstraints.tightFor(
                                      width: 50, height: 50),
                                  color: Colors.white,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    this._controller.reset();
                                    this.setState(() {
                                      showVideo = !showVideo;
                                    });
                                  },
                                ),
                              ),
                            )
                          : Container()
                      : Container(),
                  Positioned(
                    top: 20,
                    child: Container(
                      color: Colors.black38,
                      child: IconButton(
                        constraints:
                            BoxConstraints.tightFor(width: 50, height: 50),
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton:
                  BlocBuilder<SingleEventBloc, SingleEventState>(
                builder: (ctx, state) {
                  if (state is SingleEventLoaded) {
                    print(state.ticketType);
                    return state.ticketType == TicketType.waiting
                        ? BlocListener<TicketCubit, TicketState>(
                            listener: (context, state) {
                              if (state.networkStatus ==
                                  TicketNetworkStatus.created) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Booking cancelled successfuly!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                );
                                ctx.read<SingleEventBloc>()..add(CheckStatus());
                                Navigator.pop(context);
                              }
                            },
                            child: FloatingActionButton(
                              onPressed: () {
                                showDialog(
                                    context: scaffoldKey.currentContext,
                                    builder: (_) => AlertDialog(
                                          content: Text(
                                              'Are you sure you want to exit from waiting?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Back',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<TicketCubit>()
                                                    .cancelWaitingTicket();
                                                print(context
                                                    .read<TicketCubit>()
                                                    .state
                                                    .networkStatus);
                                              },
                                              child: Text('Continue'),
                                            )
                                          ],
                                        ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.signOutAlt,
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red,
                              tooltip: 'Cancel ticket',
                            ),
                          )
                        : SizedBox();
                  }
                  return Shimmer(
                    child: CircleAvatar(
                      child: FaIcon(FontAwesomeIcons.signOutAlt),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black12, Colors.transparent],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData iconData;
  final String url;

  _SocialIcon(this.iconData, this.url);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(iconData, size: 15, color: Colors.grey),
        onPressed: () {
          _goToUrl(url);
        });
  }

  void _goToUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
    // else unable to launch url
  }
}
