import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:formz/formz.dart';

final createEventPositionedNextButton = (context,
        Function(BuildContext context) callback,
        {String text}) =>
    BlocBuilder<CreateEventCubit, CreateEventState>(builder: (context, state) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.fromWidth(double.infinity),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              primary: Theme.of(context).primaryColor,
            // disabledColor: Colors.grey,
             shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)))
            ),
            onPressed: state.status.isValidated
                ? () {
                    context.read<CreateEventCubit>().resetStatus();
                    callback(context);
                  }
                : null,
            child: Text(text ?? 'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3)),
          ),
        ),
      );
    });
