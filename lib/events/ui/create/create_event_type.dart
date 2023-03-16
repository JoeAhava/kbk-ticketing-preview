import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';
import 'package:ticketing/events/ui/create/create_event_ticket_type.dart';

class CreateEventType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              Text('What type of event is it?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 20),
              _SingleCategory('Conference', Icons.shopping_bag),
              _SingleCategory('Seminar or Talk', Icons.no_drinks),
              _SingleCategory('Trade Show', Icons.stars_rounded),
              _SingleCategory('Convention', Icons.check_circle),
              _SingleCategory('Dinner Event', Icons.food_bank),
            ],
          ),
          createEventPositionedNextButton(
              context, _navigateToCreateEventTicketType),
        ],
      ),
    );
  }

  void _navigateToCreateEventTicketType(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventTicketType()));
  }
}

class _SingleCategory extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SingleCategory(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        bool selected = state.eventCategories.contains(title);
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
          ),
          child: ListTile(
            selected: selected,
            selectedTileColor: Theme.of(context).primaryColor,
            onTap: () {
              context.read<CreateEventCubit>().onEventCategoryClicked(title);
            },
            title: Row(
              children: [
                Icon(icon,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    size: 18),
                SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}
