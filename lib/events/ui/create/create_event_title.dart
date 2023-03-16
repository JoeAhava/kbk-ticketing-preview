import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_description.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';

class CreateEventTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(5, 10),
                        blurRadius: 10.0,
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Give your event a nice title',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      _EventTitleForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          createEventPositionedNextButton(
              context, _navigateToCreateEventDescriptionPage),
        ],
      ),
    );
  }

  void _navigateToCreateEventDescriptionPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventDescription()));
  }
}

class _EventTitleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
        builder: (context, state) {
      return TextFormField(
        minLines: 10,
        maxLines: 20,
        onChanged: (value) =>
            context.read<CreateEventCubit>().onTitleChanged(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0, top: 16),
          hintText: 'Enter Title Here',
          hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      );
    });
  }
}
