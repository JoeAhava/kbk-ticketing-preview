import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_location.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';

class CreateEventTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: BlocConsumer<CreateEventCubit, CreateEventState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error.isNotEmpty)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('When will your event happen',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 16),
                        Text('From:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        _DateTimePicker(from: true),
                        SizedBox(height: 16),
                        Text('To:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        _DateTimePicker(from: false),
                      ],
                    ),
                  ],
                ),
              ),
              createEventPositionedNextButton(
                  context, _navigateToCreateEventTimePage),
            ],
          );
        },
      ),
    );
  }

  void _navigateToCreateEventTimePage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventLocation()));
  }
}

class _DateTimePicker extends StatelessWidget {
  final bool from;

  _DateTimePicker({@required this.from});

  Future<void> _selectDate(context, Function(DateTime) onPicked) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2099));

    if (picked != null) onPicked(picked);
  }

  Future<void> _selectTime(context, Function(TimeOfDay) onPicked) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(
                    context,
                    (picked) => from
                        ? context
                            .read<CreateEventCubit>()
                            .onDateFromChanged(picked)
                        : context
                            .read<CreateEventCubit>()
                            .onDateToChanged(picked)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _DateValue(from),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(
                    context,
                    (picked) => from
                        ? context
                            .read<CreateEventCubit>()
                            .onTimeFromChanged(picked)
                        : context
                            .read<CreateEventCubit>()
                            .onTimeToChanged(picked)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: _TimeValue(from),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateValue extends StatelessWidget {
  final bool _from;

  _DateValue(this._from);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        final date = _from ? state.dateFrom.value : state.dateTo.value;
        return Text(
            date == null ? 'Date' : "${date.day}/${date.month}/${date.year}",
            style: TextStyle(color: Colors.grey));
      },
    );
  }
}

class _TimeValue extends StatelessWidget {
  final bool _from;

  _TimeValue(this._from);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        final time = _from ? state.timeFrom.value : state.timeTo.value;
        return Text(time == null ? 'Time' : "${time.hour}:${time.minute}",
            style: TextStyle(color: Colors.grey));
      },
    );
  }
}
