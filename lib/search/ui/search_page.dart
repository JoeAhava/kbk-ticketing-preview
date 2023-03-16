import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/widget_single_event.dart';
import 'package:ticketing/search/bloc/search_bloc.dart';
import 'package:ticketing/search/repository/search_repository.dart';

class SearchPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SearchPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: BlocProvider<SearchBloc>(
        create: (_) => SearchBloc(SearchRepository(), SearchEmpty()),
        child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          return Column(children: [
            _SearchBar(),
            state is SearchResultsLoaded
                ? _SearchResults(state.events)
                : state is SearchError
                    ? _SearchError()
                    : state is SearchLoading
                        ? _LoadingSearch()
                        : _EmptySearch(),
          ]);
        }),
      ),
    );
  }

  AppBar _appBar(context) => AppBar(
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      );
}

class _LoadingSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SearchError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20);
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20);
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              key: const Key('loginForm_emailInput_textField'),
              onChanged: (query) {
                context.read<SearchBloc>().add(DoSearch(query));
              },
              decoration: InputDecoration(
                filled: true,
                suffixIcon: Icon(Icons.mic, color: Colors.grey),
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.search, color: Colors.grey)),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(50)),
                    borderSide:
                        BorderSide(width: 0, color: Colors.transparent)),
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(50)),
                    borderSide:
                        BorderSide(width: 0, color: Colors.transparent)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Event> events;

  _SearchResults(this.events);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: events.length,
            itemBuilder: (_, position) {
              return SingleEventWidget(events[position]);
            }));
  }
}
