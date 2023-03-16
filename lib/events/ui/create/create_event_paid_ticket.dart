import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/events/ui/create/bloc/create_event_cubit.dart';
import 'package:ticketing/events/ui/create/create_event_app_bar.dart';
import 'package:ticketing/events/ui/create/create_event_image.dart';
import 'package:ticketing/events/ui/create/create_event_next_button.dart';

class CreateEventPaidTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createEventAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set the payment country currency for your event',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black54),
                ),
                SizedBox(height: 30),
                Text('Event Price',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _PriceForm(),
                SizedBox(height: 30),
                Text('Currency',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _CurrencyForm(),
              ],
            ),
          ),
          createEventPositionedNextButton(
            context,
            _navigateToCreateEventImage,
          )
        ],
      ),
    );
  }

  void _navigateToCreateEventImage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreateEventImage()));
  }
}

class _PriceForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            context
                .read<CreateEventCubit>()
                .onPriceChanged(double.tryParse(value) ?? 0);
          },
          decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)))),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey.withOpacity(0.5)),
        );
      },
    );
  }
}

class _CurrencyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return TextFormField(
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) {
            context.read<CreateEventCubit>().onCurrencyChanged(value);
          },
          decoration: InputDecoration(
              hintText: 'ETB',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)))),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey.withOpacity(0.5)),
        );
      },
    );
  }
}
