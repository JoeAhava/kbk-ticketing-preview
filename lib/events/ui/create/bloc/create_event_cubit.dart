import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/formz/date.dart';
import 'package:ticketing/formz/required_number.dart';
import 'package:ticketing/formz/required_text.dart';
import 'package:ticketing/events/repo/events_repo.dart';
import 'package:ticketing/events/ui/create/bloc/crate_event_state.dart';
import 'package:ticketing/formz/time.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final EventsRepo _repo;

  CreateEventCubit(this._repo) : super(CreateEventState());

  void onTitleChanged(value) {
    final title = RequiredText.dirty(value);
    emit(state.copyWith(title: title, status: Formz.validate([title])));
  }

  void onDescriptionChanged(value) {
    final description = RequiredText.dirty(value);
    emit(state.copyWith(
        description: description,
        status: Formz.validate([state.title, description])));
  }

  void onDateFromChanged(DateTime value) {
    final date = Date.dirty(value: value, before: state.dateTo?.value);
    emit(
      state.copyWith(
        dateFrom: date,
        status: Formz.validate(
          [
            state.title,
            state.description,
            date,
            state.dateTo,
            state.timeFrom,
            state.timeTo
          ],
        ),
      ),
    );
  }

  void onTimeFromChanged(TimeOfDay value) {
    final time = Time.dirty(value: value);
    emit(
      state.copyWith(
        timeFrom: time,
        status: Formz.validate(
          [
            state.title,
            state.description,
            state.dateFrom,
            state.dateTo,
            time,
            state.timeTo
          ],
        ),
      ),
    );
  }

  void onDateToChanged(DateTime value) {
    final date = Date.dirty(value: value, after: state.dateFrom?.value);
    emit(
      state.copyWith(
        dateTo: date,
        status: Formz.validate(
          [
            state.title,
            state.description,
            state.dateFrom,
            date,
            state.timeFrom,
            state.timeTo
          ],
        ),
      ),
    );
  }

  void onTimeToChanged(TimeOfDay value) {
    final time = Time.dirty(value: value);
    emit(
      state.copyWith(
        timeTo: time,
        status: Formz.validate(
          [
            state.title,
            state.description,
            state.dateFrom,
            state.dateTo,
            state.timeFrom,
            time,
          ],
        ),
      ),
    );
  }

  void onLocationChanged(double lat, double lng) {
    emit(state.copyWith(
      location: {"lat": lat, "lng": lng},
      status:
          lat == null || lng == null ? FormzStatus.invalid : FormzStatus.valid,
    ));
  }

  void onEventCategoryClicked(String value) {
    final categories = List<String>.from(state.eventCategories);
    if (categories.contains(value))
      categories.remove(value);
    else
      categories.add(value);

    emit(state.copyWith(
        eventCategories: categories,
        status: categories.isNotEmpty ? FormzStatus.valid : FormzStatus.invalid));
  }

  void onTicketTypeChanged(TicketType type) {
    emit(state.copyWith(
        ticketType: type,
        status: type == null ? FormzStatus.invalid : FormzStatus.valid));
  }

  void onPriceChanged(double value) {
    final price = RequiredNumber.dirty(value);
    emit(state.copyWith(
        eventPrice: price,
        status: Formz.validate([price, state.eventCurrency])));
  }

  void onCurrencyChanged(String value) {
    final currency = RequiredText.dirty(value);
    emit(state.copyWith(
        eventCurrency: currency,
        status: Formz.validate([state.eventPrice, currency])));
  }

  void onFilePicked(File file) {
    if (file.existsSync()) {
      emit(state.copyWith(image: file, status: FormzStatus.valid));
    } else {
      emit(state.copyWith(error: 'Invalid image'));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: FormzStatus.invalid));
  }

  Future<void> publishEvent() async {
    try {
      emit(CreateEventState(networkStatus: CreateEventNetworkStatus.loading));
      await _repo.publishEvent(state.title.value,
          description: state.description.value,
          price: state.eventPrice.value,
          image: state.image);
      emit(CreateEventState(networkStatus: CreateEventNetworkStatus.created));
    } catch (ex) {
      emit(CreateEventState(
          networkStatus: CreateEventNetworkStatus.error, error: ex));
    }
  }
}
