import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ticketing/home/bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/event_type_cubit/event_type_cubit.dart';
import 'package:ticketing/home/constants.dart';
import 'package:ticketing/home/data/repository.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/ui/widget_single_event.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EventListPage extends StatefulWidget {
  static Route route(String categoryName,
      {Category category, DateTime byDate, SubCategory sub = null}) {
    return MaterialPageRoute(
      builder: (_) => EventListPage(
        categoryName,
        category: category,
        byDate: byDate,
        sub: sub,
      ),
    );
  }

  EventListPage(this.categoryName,
      {this.category, this.byDate, this.sub = null});

  final String categoryName;
  final Category category;
  final DateTime byDate;
  final SubCategory sub;

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  YoutubePlayerController _controller = null;
  bool showVideo = false;
  @override
  Widget build(BuildContext context) {
    if (this.widget.category.ad.length > 0) {
      if (this.widget.category.ad[0].link != null && this._controller == null) {
        this.setState(() {
          _controller = YoutubePlayerController(
            initialVideoId:
                YoutubePlayer.convertUrlToId(this.widget.category.ad[0].link),
            flags: YoutubePlayerFlags(
              autoPlay: true,
              // mute: true,
            ),
          );
          showVideo = true;
        });
      }
    } else {
      this.setState(() {
        showVideo = false;
      });
    }
    if (this.showVideo) {
      return Container(
        height: 300,
        child: YoutubePlayer(
          aspectRatio: 4 / 3,
          topActions: [
            Positioned(
              // right: 0,
              child: Container(
                color: Colors.black38,
                padding: const EdgeInsets.only(top: 15.0),
                child: IconButton(
                  constraints: BoxConstraints.tightFor(width: 50, height: 50),
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
            ),
          ],
          bottomActions: [
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
            this?._controller?.addListener(() {
              print("Listener ...");
            });
          },
        ),
      );
    }
    return BlocProvider<EventListBloc>(
      create: (context) {
        if (this.widget.byDate != null) {
          return EventListBloc(HomeRepository())
            ..add(LoadEventListByDate(this.widget.byDate,
                category: this.widget.category, sub: this.widget.sub));
        }
        return EventListBloc(HomeRepository())
          ..add(LoadEventList(this.widget?.category?.id ?? ""));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.categoryName[0].toUpperCase()}${widget.categoryName.substring(1)}"),
        ),
        body: BlocBuilder<EventListBloc, EventListState>(
          builder: (context, state) {
            if (state is EventListLoaded) {
              return Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: state.events.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, position) {
                    final event = state.events[position];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: SingleEventWidget(
                        event,
                        type: EventType.values.firstWhere((element) {
                          print(
                              "${element.toString().toLowerCase().split(".")[1]} - ${this.widget.categoryName.toLowerCase()}");
                          return (element
                                  .toString()
                                  .toLowerCase()
                                  .split(".")[1] ==
                              this.widget.categoryName.toLowerCase());
                        }),
                      ),
                    );
                  },
                ),
              );
            }

            return _Loading();
          },
        ),
      ),
    );
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
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: EdgeInsets.all(16),
            ),
          );
        });
  }
}
